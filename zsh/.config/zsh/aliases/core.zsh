alias l='ls -lAFh --color=tty'
alias h='sha1sum'
alias u='uptime --pretty'
alias k='kill'
alias K='kill -9'

alias ln='ln -s -n -f $LINK_TO $LINK_NAME'
alias lc='ls | wc -l'

alias cp='cp -i'
alias mv='mv -i'
alias md='mkdir -p'
alias ip='ip -color=auto'
alias diff='diff --color=auto'
alias make="make --jobs=$(($(nproc) + 1))"
alias grep='grep --color=auto'
alias dmesg='sudo dmesg --color=auto --follow'

alias dd='dd status=progress'
alias ddr='dd if=/dev/urandom bs=4K count=1 | base64 > output.dat'

alias src='exec zsh'
alias rmr='rm -rf'
alias rmf='shred -uz'

# Disk Usage Directories
alias dud='du -d 1 -ch --apparent-size | sort --human-numeric-sort'
# Disk Usage Files
alias duf='find . -type f -exec du -csh --apparent-size {} + | sort --human-numeric-sort'

alias treec="find . -path './.git' -prune -o -type f -print | wc -l"
alias genstr="LC_ALL=C tr -dc 'A-Za-z0-9_' </dev/urandom | head -c 12"
alias diffproc='diff <() <()'
alias follow='tail -n 10k -F'

alias kern='uname --kernel-release --machine'
alias kerncfg='zless /proc/config.gz'
alias kernparam='cat /proc/cmdline'

alias psls='ps aux'
alias pscpu='ps -e -o pid,ppid,cmd:100,%mem,%cpu --sort=-%cpu | head'
alias psmem='ps -e -o user,pid,%cpu,%mem,args --sort=-%mem | head -n 20'