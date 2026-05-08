#!/usr/bin/env python3
"""Create the concise 30-minute BSEBench CTO KPI email."""

from __future__ import annotations

import argparse
import datetime as dt
import email.utils
import json
import os
import shutil
import smtplib
import socket
import subprocess
import sys
import urllib.request
from email.message import EmailMessage
from pathlib import Path


ROOT = Path("/mnt/c/doctorat/bsebench-org")
ASYNC_REPO_DEFAULT = ROOT / "bsebench-async-codex"
STATE_DIR = Path.home() / ".local/state/bsebench-kpi-email"

PHASE_TASKS = {
    "P9": ["P9_RUNNER_PROFILE_AXIS_INVENTORY", "P9_STATS_PROFILE_COMPARABILITY", "P9-RUNNER-2", "P9-EMPIRICAL-1", "P9-VERDICT-1"],
    "P10": ["P10_DATASETS_AGING_READINESS_GATE", "P10_RUNNER_AGING_PREDISPATCH_BUDGET", "P10-STATS-1", "P10-EMPIRICAL-1", "P10-VERDICT-1"],
    "P11": ["P11_RUNNER_RESIDUAL_INPUT_CONTRACT", "P11_STATS_RESIDUAL_DECOMP_CONTRACT", "P11-RUNNER-2", "P11-EMPIRICAL-1", "P11-VERDICT-1"],
}


def run(cmd: list[str], cwd: Path | None = None, timeout: int = 25) -> str:
    try:
        proc = subprocess.run(cmd, cwd=cwd, text=True, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, timeout=timeout, check=False)
    except Exception:
        return ""
    return proc.stdout.strip() if proc.returncode == 0 else ""


def codex_wrappers() -> list[str]:
    out = run(["pgrep", "-af", "codex exec"], timeout=10)
    lines = [line for line in out.splitlines() if "codex exec" in line]
    wrappers = [line for line in lines if "timeout " in line]
    return wrappers or lines


def direct_labels(async_repo: Path) -> set[str]:
    active_pids = {line.split(maxsplit=1)[0] for line in codex_wrappers() if line.split(maxsplit=1)}
    labels: set[str] = set()
    for registry in sorted((async_repo / ".codex-direct-logs").glob("direct-workers-*.tsv")):
        for raw in registry.read_text(encoding="utf-8", errors="replace").splitlines():
            cols = raw.split(maxsplit=3)
            if len(cols) >= 4 and cols[0] in active_pids:
                labels.add(cols[1])
    return labels


def hf_count() -> int | None:
    token_path = Path(f"/run/user/{os.getuid()}/bsebench/hf_token")
    req = urllib.request.Request("https://huggingface.co/api/datasets?author=bsebench-org&limit=1000&full=false")
    if token_path.exists():
        req.add_header("Authorization", "Bearer " + token_path.read_text(encoding="utf-8").strip())
    try:
        with urllib.request.urlopen(req, timeout=20) as resp:
            payload = json.loads(resp.read().decode("utf-8"))
    except Exception:
        return None
    return len(payload) if isinstance(payload, list) else None


def status_counts(async_repo: Path) -> dict[str, int]:
    counts: dict[str, int] = {}
    for path in (async_repo / "inbox").glob("*/STATUS.json"):
        try:
            status = json.loads(path.read_text(encoding="utf-8")).get("status", "unknown")
        except Exception:
            status = "unknown"
        counts[status] = counts.get(status, 0) + 1
    return counts


def recent_commits(async_repo: Path) -> int:
    out = run(["git", "log", "--since=30.minutes", "--oneline"], cwd=async_repo, timeout=20)
    return len([line for line in out.splitlines() if line.strip()])


def load_state() -> dict[str, object]:
    path = STATE_DIR / "state.json"
    if not path.exists():
        return {}
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return {}


def save_state(state: dict[str, object]) -> None:
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    (STATE_DIR / "state.json").write_text(json.dumps(state, indent=2, sort_keys=True), encoding="utf-8")


def phase(active: set[str]) -> dict[str, dict[str, int]]:
    result: dict[str, dict[str, int]] = {}
    for phase_id, tasks in PHASE_TASKS.items():
        active_n = sum(1 for task in tasks if task in active)
        total = len(tasks)
        result[phase_id] = {"verified_pct": 0, "active_pct": round(active_n * 100 / total), "active_tasks": active_n, "total_tasks": total}
    return result


def metrics(async_repo: Path) -> dict[str, object]:
    wrappers = codex_wrappers()
    labels = direct_labels(async_repo)
    return {
        "timestamp": dt.datetime.now(dt.timezone.utc).isoformat(),
        "codex_active": len(wrappers),
        "hf_upload_active": sum(1 for line in wrappers if ".hf-upload-stage" in line),
        "direct_active": len(labels),
        "direct_labels": sorted(labels),
        "hf_count": hf_count(),
        "recent_commits_30m": recent_commits(async_repo),
        "blocks": len(list((async_repo / "outbox/_blocks").glob("*.block"))),
        "status_counts": status_counts(async_repo),
        "phase": phase(labels),
    }


def body(now: dict[str, object], prev: dict[str, object]) -> str:
    hf = now.get("hf_count")
    prev_hf = prev.get("hf_count")
    delta = f", HF delta {hf - prev_hf:+d}" if isinstance(hf, int) and isinstance(prev_hf, int) else ""
    hf_text = str(hf) if isinstance(hf, int) else "unknown"
    p9, p10, p11 = now["phase"]["P9"], now["phase"]["P10"], now["phase"]["P11"]
    s1 = f"Depuis le dernier point: {now['recent_commits_30m']} commit(s) GLASSBOX async, {now['direct_active']} taches directes Phase 9/10/11+site actives, {now['hf_upload_active']} uploads HF actifs, block chef={now['blocks']}{delta}."
    s2 = f"KPI: codex_exec={now['codex_active']}, HF datasets={hf_text}, P9={p9['verified_pct']}% verifie/{p9['active_pct']}% actif, P10={p10['verified_pct']}% verifie/{p10['active_pct']}% actif, P11={p11['verified_pct']}% verifie/{p11['active_pct']}% actif; ETA preflights P9/P10/P11=1-3h si validations vertes, ETA phases completes=apres cache/provenance et runs empiriques."
    return s1 + "\n" + s2 + "\n"


def message(to_addr: str, text: str, data: dict[str, object]) -> EmailMessage:
    msg = EmailMessage()
    msg["To"] = to_addr
    msg["From"] = os.environ.get("BSEBENCH_EMAIL_FROM", "cto-kpi@bsebench.local")
    msg["Subject"] = f"[BSEBench KPI] codex={data['codex_active']} P9={data['phase']['P9']['active_pct']}a P10={data['phase']['P10']['active_pct']}a P11={data['phase']['P11']['active_pct']}a"
    msg["Date"] = email.utils.formatdate(localtime=True)
    msg["Message-ID"] = email.utils.make_msgid(domain=socket.getfqdn() or "bsebench.local")
    msg.set_content(text)
    return msg


def try_send(msg: EmailMessage) -> str:
    host = os.environ.get("BSEBENCH_SMTP_HOST")
    user = os.environ.get("BSEBENCH_SMTP_USER")
    password = os.environ.get("BSEBENCH_SMTP_PASSWORD")
    if host and user and password:
        try:
            with smtplib.SMTP(host, int(os.environ.get("BSEBENCH_SMTP_PORT", "587")), timeout=30) as smtp:
                smtp.starttls()
                smtp.login(user, password)
                smtp.send_message(msg)
            return "sent_smtp"
        except Exception as exc:
            return f"smtp_failed_{exc.__class__.__name__}"
    sendmail = shutil.which("sendmail")
    if sendmail:
        proc = subprocess.run([sendmail, "-t", "-oi"], input=msg.as_string(), text=True, check=False, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=30)
        return "sent_sendmail" if proc.returncode == 0 else f"sendmail_failed_{proc.returncode}"
    return "queued_no_transport"


def commit_email(async_repo: Path, path: Path, status: str) -> None:
    run(["git", "add", str(path.relative_to(async_repo))], cwd=async_repo, timeout=20)
    run(["git", "commit", "-m", f"notify(email): periodic KPI report {path.stem}\n\n[role: codex-cto]\n\nThirty-minute KPI email for akir.oussama@gmail.com. Dispatch status: {status}."], cwd=async_repo, timeout=30)
    run(["git", "pull", "--rebase", "origin", "main"], cwd=async_repo, timeout=60)
    run(["git", "push", "origin", "main"], cwd=async_repo, timeout=60)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--async-repo", default=str(ASYNC_REPO_DEFAULT))
    parser.add_argument("--to", default="akir.oussama@gmail.com")
    parser.add_argument("--send-if-configured", action="store_true")
    parser.add_argument("--git-push", action="store_true")
    args = parser.parse_args()

    async_repo = Path(args.async_repo)
    data = metrics(async_repo)
    text = body(data, load_state())
    msg = message(args.to, text, data)
    ts = dt.datetime.now(dt.timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    pending = async_repo / "outbox/_emails_pending"
    sent = async_repo / "outbox/_emails_sent"
    pending.mkdir(parents=True, exist_ok=True)
    sent.mkdir(parents=True, exist_ok=True)
    path = pending / f"{ts}-cto-kpi-30min.eml"
    path.write_text(msg.as_string(), encoding="utf-8")
    status = try_send(msg) if args.send_if_configured else "queued_no_attempt"
    if status.startswith("sent_"):
        new_path = sent / path.name
        path.replace(new_path)
        path = new_path
    data["email_path"] = str(path)
    data["send_status"] = status
    save_state(data)
    if args.git_push:
        commit_email(async_repo, path, status)
    print(json.dumps(data, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    sys.exit(main())
