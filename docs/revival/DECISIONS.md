# Revival Decisions & Surprises

Append-only. One dated entry per decision or surprise. Never edit a past entry;
if a decision is reversed, append the reversal. The reversals are the interesting part.

---

## 2026-08-20 — Session 01: Phase 0 freeze begins

### GH007: private email blocked the tag push
Attempting `git push --tags` for `v0-2018` was rejected by GitHub with
`GH007: Your push would publish a private email address`. The commit `master`
pointed at was authored by `erthaljonas@gmail.com` (private), even though
`user.email` was already the noreply address.
Resolution: rewrote the tip commit's author+committer to the noreply identity
(`20910008+apollopower@users.noreply.github.com`) via `git commit --amend
--reset-author`, force-pushed with `--force-with-lease`, re-tagged `v0-2018`.
Only the latest commit was scrubbed; 48 older commits still carry the private
email (a later, full history rewrite remains possible if ever needed).
Kept email hidden; no public-email toggle.

### Repo strategy: one repo, linear history, `revival` branch
Chose to work in `apollopower/pollock-webapp` on a `revival` branch rather than
a fresh repo. The `v0-2018` tag stays; the diff `v0-2018..HEAD` is the story,
and post code samples get permalinks. Downside accepted: we inherit `.DS_Store`,
the stray `1.22.0.pre1` file, and 12 stale Dependabot PRs (closed this session
with a comment pointing at `revival`).

### Capture infrastructure
`docs/revival/` skeleton created and committed alongside code:
`DECISIONS.md`, `metrics.md`, `logs/`, `transcripts/`, `media/`.
Logs are numbered chronologically. Session discipline: dated header at start,
transcript+commit at end.

### Architecture baseline written
`docs/revival/architecture-2018.md` — one-page description of the 2018 pipeline
derived by reading the `v0-2018` code before any agent touched it. Baseline for
contrasting with what the porting agent later infers.

### Dead deps inventoried
`docs/revival/dependency-inventory.md` — each dead gem, pinned version, why it
breaks on Ruby 4.0.6 / Rails 8, and rough dates.

## 2026-08-20 — First-contact failures captured

Tee'd the two verbatim failures on modern Ruby 4.0.6 (Bundler 4.0.16):

- `docs/revival/logs/01-bundle-install-modern-ruby.txt` — Bundler tried to
  fall back to lockfile-era Bundler 2.0.2, which crashed:
  `uninitialized constant DidYouMean::SPELL_CHECKERS (NameError)`.
- `docs/revival/logs/02-rails-server-modern-ruby.txt` — `bin/rails` died in
  Bundler 2.0.2's `shared_helpers.rb` on `undefined method 'untaint' for an
  instance of String` (Ruby 4 removed `String#untaint`).

Nothing was fixed. Per the Phase 0 gate, evidence is on disk only. Period Ruby
(2.x) install is deferred to Phase 1.
