#!/usr/bin/env bash

# get rid of kequeue warning after macOS Sierra
export EVENT_NOKQUEUE=1

export PATH="/Users/mudox/.bin:/usr/local/bin:$PATH"

target_pane='Xcode:Log.1'
input_dir='/tmp/mudox/log/Xcode/Jack'
input_file="${input_file}/Jack.log"

log_dir='/tmp/mudox/log/Xcode'
log_file="${log_dir}/PreRun.log"

cmd="tail -s0.1 -n0 -F ${input_dir}/Jack.log | xlog -f"

mkdir -p "${input_dir}" &>/dev/null
touch "$input_file"

touch "${log_file}" &>/dev/null
exec &>>"${log_file}"

# log start
printf '\n\n'
xlog -l "W| ${PROJECT_NAME}: launched
>> at: $(date +'%Y-%m-%d %H:%M:%S')
"

# clear screen
xlog -l 'V| clear log screen'
tmux send -t "${target_pane}" C-c C-c C-l

# start tailing
xlog -l 'V| start tailing'
tmux send -t "${target_pane}" "${cmd}" Enter

# switch to `Log` tmux pane
tty="$(tmux list-clients -F '#{client_tty}')"
if [[ -n $tty ]]; then
  xlog -l 'V| Switch to Xcode session'
  tmux switch-client -c "${tty}" -t "${target_pane}"
else
  xlog -l 'W| No tmux client is found'
fi
