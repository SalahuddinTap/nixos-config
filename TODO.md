# TODO

## Private Git Remote
- [ ] Create private git remote (GitHub/GitLab/self-hosted)
- [ ] Add remote: `git remote add origin <url>`
- [ ] Push: `git push -u origin master`
- [ ] Verify backup: `git ls-remote origin`

## Secrets
- [ ] ROTATE/REVOKE the old `data/rsa_key.pem` RSA key — it was committed once
      (purge done via git filter-repo on 2026-11-18; backup copy with old
      history kept at ~/projects/nixos-config-backup-*) and a copy also lives
      in the syncthing folder ~/sync/pc/nixos-config/data/rsa_key.pem — delete
      that copy too and treat the key as compromised
- [ ] If a private remote is ever created BEFORE the purge is pushed, the key
      leaks — push the rewritten history only (current master has no key)

## Notes
- Current repo is local only (no remote configured)
- History was rewritten 2026-11-18 to remove data/rsa_key.pem (66 commits);
  pre-rewrite backup: ~/projects/nixos-config-backup-20261118-095823
