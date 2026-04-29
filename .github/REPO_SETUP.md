# Repository Setup Notes

After pushing, set these GitHub repository settings to align with
agentskills.io conventions:

```bash
# Add the agent-skills topic so gh skill can discover it
gh repo edit --add-topic agent-skills
gh repo edit --add-topic claude-code
gh repo edit --add-topic holacracy

# Recommended for skills repositories
gh repo edit --enable-discussions

# Tag protection (recommended for immutable releases)
# Configure in Settings → Branches → Tag rulesets
```

When publishing a new release:

```bash
gh skill publish --dry-run    # validate against agentskills.io spec
gh skill publish --dry-run --fix  # auto-fix common issues
gh skill publish              # tag a release
```
