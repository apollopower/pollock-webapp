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
