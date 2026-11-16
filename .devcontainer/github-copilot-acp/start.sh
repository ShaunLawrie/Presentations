#!/usr/bin/env bash
set -euo pipefail

# The host's KVM device can use a different group ID from the image's group.
# Reapply this after each start, when Codespaces exposes host devices again.
if [[ -c /dev/kvm ]]; then
  sudo chgrp kvm /dev/kvm
  sudo chmod g+rw /dev/kvm
fi

sbx daemon start --detach --policy balanced

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir/../../2026-11-16-github-copilot-acp"

if curl --fail --silent http://127.0.0.1:3030/ >/dev/null; then
  exit 0
fi

nohup setsid npm run dev:cloud </dev/null >/tmp/github-copilot-acp-slidev.log 2>&1 &

for attempt in {1..30}; do
  if curl --fail --silent http://127.0.0.1:3030/ >/dev/null; then
    exit 0
  fi
  sleep 1
done

cat /tmp/github-copilot-acp-slidev.log
exit 1
