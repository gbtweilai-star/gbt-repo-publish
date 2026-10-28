#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_repo_publish info
PYTHONPATH=src python -m gbt_repo_publish check --payload '{}'
PYTHONPATH=src python -m gbt_repo_publish run   --payload '{}'
