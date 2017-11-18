#!/usr/bin/env zsh

# get rid of kequeue warning after macOS Sierra
export EVENT_NOKQUEUE=1

export PATH="/Users/mudox/.bin:/usr/local/bin:$PATH"

target_pane='Xcode:CocoaLumberjack.2'
target_path="${SRCROOT}/${PROJECT_NAME}"

log_dir='/tmp/mudox/log/Xcode'
log_file="${log_dir}/SchemeAction.log"

# clear screen & empty log file & start tailing
mkdir -p "${log_dir}" &>/dev/null
rm "${log_file}" &>/dev/null
touch "${log_file}"

echo "error: before redirection!!!"
exec &>>"${log_file}"

tmux send -t "${target_pane}" C-c C-c C-l
tmux send -t "${target_pane}"  "tail -f ${log_file}" c-m

# start --------------------------------------------------
echo "\n\n"
xlog -l "W| ${PROJECT_NAME}: Build -----------
>> at: $(date +'%Y-%m-%d %H:%M:%S')
>> in: ${target_path}
"

cd "${target_path}"

#xlog -l 'I| swiftlint: autocorrect ...'
#swiftlint autocorrect |& xlog -i

#xlog -l 'I| swiftformat: format code ...'
#swiftformat --indent 2 **/*.swift |& xlog -i

echo '🎉     '
