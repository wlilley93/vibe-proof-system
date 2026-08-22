#!/bin/sh
# Point git at the gate. Run once from the repo root.
set -e
cd "$(git rev-parse --show-toplevel)"
chmod +x gate/pre-commit
git config core.hooksPath gate
echo "vps: gate installed (core.hooksPath = gate/)"
echo "vps: building the kernel and checking the proofs..."
cd kernel && lake build
echo "vps: the book is lawful (it compiled). The court is in session."
