#!/usr/bin/env bash
set -euo pipefail

source ~/Git/dot-files/bash/lib/jack

tput civis
trap 'tput cnorm' EXIT

# client size
set +u
if [[ -n "$TMUX" ]]; then
  client_width="$(tmux list-clients -t '.' -F '#{client_width}')"
  client_height="$(tmux list-clients -t '.' -F '#{client_height}')"
else
  client_width=$(tput lines)
  client_height=$(tput cols)
fi
set -u


session_name='JacKit'
if tmux has-session -t ${session_name} &>/dev/null; then
  jackWarn "session [${session_name}] already exisits, kill it!"
  tmux kill-session -t "${session_name}"
fi


#
# window: Editor (JacKit)
#
jackProgress 'Creating window [Editor (JacKit)] ...'

root="${HOME}/Develop/Apple/Frameworks/JacKit/"
window_name='Editor (JacKit)'
window="${session_name}:${window_name}"
tmux new-session        \
  -s "${session_name}"  \
  -n "${window_name}"   \
  -x "${client_width}"  \
  -y "${client_height}" \
  -c "${root}"          \
  -d
tmux send-keys -t "${window}.1" "
vv -O ${session_name}.podspec Demo/Podfile
:tabnew   fastlane/Fastfile
:tabnew   .travis.yml
:tabnew   .gitignore
:tabnew   .tmux-session.sh
:tabnew   .codecov.yml
:vnew     .codeclimate.yml
:tabnew   README.md
:tabnew   CHANGELOG.md
"

#
# window: Editor (jacsrv)
#
jackProgress 'Creating window [Editor (jacsrv)] ...'

root="${HOME}/Develop/Python/jac-srv/"
window_name='Editor (jacsrv)'
window="${session_name}:${window_name}"
tmux new-window              \
  -a                         \
  -t "${session_name}:{end}" \
  -n "${window_name}"        \
  -c "${root}"               \
  -d
sleep 1
tmux send-keys -t "${window}" "
v python *.py
"

#
# window: Shell
#
jackProgress 'Creating window [Shell] ...'

root="${HOME}/Develop/Apple/Frameworks/JacKit/"
window_name='Shell'
window="${session_name}:${window_name}"
tmux new-window              \
  -a                         \
  -t "${session_name}:{end}" \
  -n "${window_name}"        \
  -c "${root}"               \
  -d


#
# window: Test
#
jackProgress 'Creating window [Test] ...'

root="${HOME}/.local/share/jacsrv/log"
window_name='Test'
window="${session_name}:${window_name}"

# .1 on the left side shows jacserver stdout
tmux new-window              \
  -a                         \
  -t "${session_name}:{end}" \
  -n "${window_name}"        \
  -c "${root}"               \
  -d
sleep 1
tmux send-keys -t "${window}.1" '
jacsrv
'

# pane .2
# at top right corner
# runs `test.py`
root="${HOME}/Develop/Python/jac-srv/"
tmux split-window  \
  -t "${window}.1" \
  -h               \
  -l 60            \
  -c "${root}"

# pane: .3
# at botom right corner
# `tail -f` jacserver.py stderr
root="${HOME}/.local/share/jacsrv/log"
tmux split-window  \
  -t "${window}.2" \
  -v               \
  -c "${root}"


jackEndProgress
tmux select-window -t "${session_name}:1.1"
echo "[${session_name}] started"
tmux list-window -t "${session_name}" -F ' - #W'
