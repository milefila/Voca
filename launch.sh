#!/usr/bin/env bash
# Launch all content sessions in separate terminal tabs.
# Works with iTerm2 (AppleScript), tmux, or Zellij.

DIR="$(cd "$(dirname "$0")" && pwd)"

# ── tmux (cross-platform) ────────────────────────────────────────────────────
if command -v tmux &>/dev/null && [ -z "$TMUX" ]; then
  tmux new-session  -d -s content -n newsletter  "cd $DIR && claude"
  tmux new-window       -t content -n tweets     "cd $DIR && claude"
  tmux new-window       -t content -n crosspost  "cd $DIR && claude"
  tmux new-window       -t content -n remotion   "cd $DIR && claude"
  tmux select-window    -t content:newsletter
  tmux attach-session   -t content
  exit 0
fi

# ── Zellij ───────────────────────────────────────────────────────────────────
if command -v zellij &>/dev/null; then
  zellij --session content action new-tab --name newsletter -- bash -c "cd $DIR && claude"
  zellij --session content action new-tab --name tweets     -- bash -c "cd $DIR && claude"
  zellij --session content action new-tab --name crosspost  -- bash -c "cd $DIR && claude"
  zellij --session content action new-tab --name remotion   -- bash -c "cd $DIR && claude"
  exit 0
fi

# ── iTerm2 (macOS) ───────────────────────────────────────────────────────────
if [[ "$OSTYPE" == darwin* ]] && command -v osascript &>/dev/null; then
  osascript <<EOF
tell application "iTerm2"
  tell current window
    set newsletter to current tab
    tell current session of newsletter
      set name to "newsletter"
      write text "cd $DIR && claude"
    end tell
    set tweets to (create tab with default profile)
    tell current session of tweets
      set name to "tweets"
      write text "cd $DIR && claude"
    end tell
    set crosspost to (create tab with default profile)
    tell current session of crosspost
      set name to "crosspost"
      write text "cd $DIR && claude"
    end tell
    set remotion to (create tab with default profile)
    tell current session of remotion
      set name to "remotion"
      write text "cd $DIR && claude"
    end tell
  end tell
end tell
EOF
  exit 0
fi

echo "No supported terminal multiplexer found (tmux, zellij, or iTerm2 on macOS)."
echo "Open 4 tabs manually and run: cd $DIR && claude"
