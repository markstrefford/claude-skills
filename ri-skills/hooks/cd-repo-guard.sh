#!/usr/bin/env bash
# PreToolUse(Bash) guard: auto-approve `cd` navigation that stays INSIDE the
# current git repo. Any cd that leaves the repo — or that we can't prove stays
# inside it — is left to the normal permission prompt, so the operator is asked
# before we wander outside the repo.
#
# Generic by design: the repo root is discovered at runtime from the session's
# cwd via `git rev-parse`. No repo paths are hard-coded, so this works in every
# repository unchanged.
#
# Fail-safe: the ONLY thing this hook ever does is *add* an allow for a proven
# in-repo cd. It never blocks and never forces a prompt beyond normal behaviour,
# so a parsing miss degrades to "ask as usual", never to a wrong auto-approve.

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')

# Fast path: do nothing unless there's an actual `cd` command word.
printf '%s' "$cmd" | grep -qE '(^|[;&|]|&&|\|\|)[[:space:]]*cd([[:space:]]|$)' || exit 0

cwd=$(printf '%s' "$input" | jq -r '.cwd // ""')
[ -n "$cwd" ] || exit 0

repo=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null) || exit 0
[ -n "$repo" ] || exit 0

# How many `cd` command-words are in the command?
n_cd=$(printf '%s' "$cmd" \
  | grep -oE '(^|[;&|]|&&|\|\|)[[:space:]]*cd([[:space:]]|$)' | wc -l | tr -d ' ')

# The argument following each cd, up to the next shell separator.
targets=$(printf '%s\n' "$cmd" \
  | grep -oE '(^|[;&|[:space:]])cd[[:space:]]+[^;&|]+' \
  | sed -E 's/^[;&|[:space:]]*cd[[:space:]]+//' \
  | sed -E 's/[[:space:]]+$//')

n_ok=0
while IFS= read -r t; do
  [ -n "$t" ] || continue
  t=${t%\"}; t=${t#\"}; t=${t%\'}; t=${t#\'}      # strip surrounding quotes
  dest=$(cd "$cwd" 2>/dev/null && cd "$t" 2>/dev/null && pwd -P)  # resolve (must exist)
  [ -n "$dest" ] || continue
  case "$dest/" in
    "$repo/"*) n_ok=$((n_ok + 1)) ;;
  esac
done <<EOF
$targets
EOF

# Auto-approve only when EVERY cd word resolved to an in-repo destination.
if [ "$n_cd" -gt 0 ] && [ "$n_ok" -eq "$n_cd" ]; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}\n'
fi
exit 0
