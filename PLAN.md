# Build Plan

The skeleton in this repo is Phase 0 output. Each later phase ends with the same green bar:
`lake build` clean, `leanchecker` replay clean, gate self-test denying what the theorems say
it denies. Learnings-ledger items marked PHASE n land in their phase (see LEARNINGS.md).

## Phase 0 — verify the skeleton (first session on your machine)

The sandbox that authored this could not reach Lean's release hosts, so the proofs are
written but unchecked. First action: `cd kernel && lake build` (elan will fetch the pinned
v4.33.0 toolchain). Expect at worst minor lemma-name drift in `Proofs.lean` — the theorem
statements and proof shapes are conservative core-Lean. Then `sh gate/install.sh`, make a
commit touching `kernel/` without a record entry, and watch `[2026] VPS 2` deny it. Push to
GitHub so `gate.yml` becomes the standing trust root. Finally: replace
`genesisDigest` with the sha256 of the genesis text you actually sign, and commit that as
the first record entry.

## Phase 1 — richer rule language, honestly small

Grow `Rule` only when a real governance need hits the closed language's limit: glob scopes
rather than prefixes, protected-content rules (the entrenchment-clause-survives class),
dependency fences, size ceilings as lint. Every constructor added must stay decidable over
`Facts`, ship both example vectors, and extend the theorems where it interacts with
entrenchment. Property-test the fact extractor (the one trusted component that can lie to
the kernel) against adversarial paths: quotes, newlines, unicode, prefix confusion —
`"gateX/"` vs `"gate/"` is the known sharp edge of prefix scoping.

## Phase 2 — courts live, precedent wired

Wire `record/precedents.json` into the binary (`vps ask <question>`): hash lookup, fast-path
disposal, `Sound`-table maintenance at enactment time. Bench harness: prompts for
County/Council/Supreme sittings whose only output channel is a PR containing the diff (the
registrar-check becomes CI on the PR). Re-derive permits as capabilities only if Phase 1
surfaces a need the gate can't express: expiring, use-limited, actor-carrying (learnings
#28, #33) — and if so, their algebra gets the same theorem treatment (no permit-closed
bypass class by construction). Add the finer constitutive/correctable lattice (learning #24)
as a typed severity on rules, with the non-launderability theorem.

## Phase 3 — publication and federation

Publication as a governed act: publish surfaces protected by statute; redaction/pseudonymity
as a typed transform whose "no private identifier survives" obligation is scoped to named
fields (learning #30 — v2 spent three statutes correcting publication residue). Federation:
a subscriber repo's book = further enactments on the same genesis line under a local
authority instrument; the anti-relaxation guarantee ("local law never weakens canon")
becomes a theorem about the overlay join, proved once, in the style of `entrenched_immune`
(learning #31).

## Phase 4 — hardening the trust story

`lake env leanchecker` replay is already in CI; add toolchain digest pinning of the CI
actions, a second independent checker run (Lean4Lean) if wanted, and a signed-tag release
ritual for the kernel binary. Revisit Article 8's trusted-base list annually and shrink it
where possible. The one thing never to build: a watcher that watches the compiler.

## Standing discipline

One session, one concern. Law changes only through `Book.lean`. If you notice meta-work —
work whose subject is the system's own integrity rather than governed work — stop: under
this design that is always a smell, because integrity is not an activity here. The measure
of success: a year from now, the record should be mostly about *your projects*, and the
court docket should be short. v2's docket was the system itself; that is the failure mode
this plan exists to prevent.
