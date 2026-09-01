
# Vibe Proof System

<div align="center">

*Governance for AI-assisted work, by proof. Spec is law. Law is code. Legitimacy is a theorem.*

[![Lean 4.33.1](https://img.shields.io/badge/Lean-4.33.1-6f6f6f?style=flat-square)](https://github.com/leanprover/lean4/releases/tag/v4.33.1)
[![status](https://img.shields.io/badge/status-alpha-orange?style=flat-square)](https://github.com/wlilley93/vibe-proof-system)

**Not a real court. Not legal advice.**

</div>

---

## What it is

Vibe Proof System (VPS) is the small Lean 4 governance kernel beneath the
[Vibe Justice System](https://github.com/wlilley93/vibe-justice-system). It turns the
constitution from a document that an implementation is expected to obey into code that
must compile before it can take effect.

VPS is a clean restart of the VJS line. The earlier VJS generation used a Rust kernel and
then accumulated locks, sweeps and ratchets to check that the kernel was still obeying its
own law. VPS moves the enforcement substrate into Lean: the world model, statute book,
legitimacy door and gate are definitions and theorems, and the compiled gate is the artifact
that runs in the pre-commit hook.

The central claim is deliberately narrow:

> Illegal states are unrepresentable, illegal transitions are unprovable, and integrity is
> therefore a property of the artifact rather than an activity performed beside it.

VPS does not decide natural-language meaning. Probabilistic judges may propose or interpret
contested questions in VJS; only a typed, lawful instrument can enter the statute book, and
the proof kernel decides whether that instrument is admissible.

## What the kernel proves

The current book proves, over every lawful book:

- the authority floor: law cannot make itself sovereign;
- append-only legitimacy and valid authority chains;
- citation freshness and uniqueness;
- rank-guarded supersession;
- entrenchment immunity and force;
- res judicata for the precedent table; and
- denial-naming: a denial carries the law that caused it.

The headline theorems live in
[kernel/Vps/Proofs.lean](kernel/Vps/Proofs.lean), with the book's self-legitimacy
established by Vps.book_lawful.

## Trust boundary

Proof is not a synonym for magic. VPS names what remains trusted: Lean and its pinned
toolchain, the independent proof checker, the small facts extractor in the gate, the CI
runner, git, and the sovereign assent key. The content of a bench ruling is also trusted
input; VJS records and appeals it, but VPS does not pretend to prove whether a model's
interpretation of prose is correct.

The separate checker is run over the built modules in CI. The point is to make the proof
path inspectable and replayable, not to hide the remaining assumptions behind a badge.

## Quickstart

The repository is pinned to
[Lean 4.33.1](https://github.com/leanprover/lean4/releases/tag/v4.33.1).
Install that exact toolchain through elan, then build the kernel and replay its proofs:

    git clone https://github.com/wlilley93/vibe-proof-system.git
    cd vibe-proof-system
    elan toolchain install leanprover/lean4:v4.33.1
    cd kernel
    lake build
    lake env leanchecker Vps
    lake exe vps book

Install the fail-closed pre-commit wall from the repository root:

    cd ..
    sh gate/install.sh

The gate extracts only simple facts from the staged change and asks the compiled kernel for
the verdict. It does not decide law in shell. A governed kernel or gate change without the
required record is denied, and every denial names the instrument that caused it.

## The kernel in one page

[kernel/Vps/World.lean](kernel/Vps/World.lean) defines the closed world of instruments,
facts, citations and rules. [Instrument.lean](kernel/Vps/Instrument.lean) gives those
values their typed shape. [Legitimacy.lean](kernel/Vps/Legitimacy.lean) defines lawful
enactment; [Gate.lean](kernel/Vps/Gate.lean) turns facts into an allow/deny result; and
[Proofs.lean](kernel/Vps/Proofs.lean) proves the invariants that make those transitions
safe. [Book.lean](kernel/Vps/Book.lean) is the current statute book and
[Main.lean](kernel/Main.lean) compiles the gate as the vps executable.

## Relationship with Vibe Justice System

VPS is the constitutional substrate; VJS is the reusable court above it. VJS owns filings,
questions, benches, appeals, judgments and the exact-match citator. VPS owns the lawful
spine: what can be enacted, cited, superseded and enforced. VJS consumes VPS as a pinned
Lean dependency rather than copying the kernel and creating a second implementation to
watch.

Foundry builds on the same split. It turns prose requirements into a typed representation,
asks probabilistic models and humans to resolve meaning, generates Lean, and lets the
kernel return the mechanical verdict.

## Repository map

- [CHARTER.md](CHARTER.md) — the human-readable constitution; Lean is authoritative.
- [ASSESSMENT.md](ASSESSMENT.md) — the Rust-to-Lean design decision and its costs.
- [LEARNINGS.md](LEARNINGS.md) — settlements carried forward from VJS v1/v2.
- [kernel/](kernel/) — Lean world model, law, proofs, book and executable.
- [gate/](gate/) — the deliberately small pre-commit wall.
- [court/](court/) — the bench protocol for the layer above the kernel.
- [law/](law/) — prose mirrors of enacted instruments.
- [record/](record/) — historical decisions about the build, not operative law.
- [.github/workflows/gate.yml](.github/workflows/gate.yml) — build and checker trust root.

## Status

The kernel builds and its proofs replay on the pinned Lean 4.33.1 toolchain. It is an
alpha research implementation: it makes a narrow class of governance invariants
machine-checkable; it does not make model judgments true, remove the need for human
sign-off, or replace engineering and legal review.
