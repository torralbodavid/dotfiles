# ============================================================
# .zshrc - Shell configuration
# Managed by dotfiles: https://github.com/tu-usuario/dotfiles
# ============================================================

# ------- SSH Aliases -------
# Add your SSH aliases here (make sure they are not tracked in a public repo)

# ------- Laravel / PHP Aliases -------
alias artisan='php artisan'
alias dump='php artisan dump-server'
alias tinker='php artisan tinker'

# ------- General Aliases -------
alias ls='ls -lisa'

# ------- macOS Finder Helpers -------
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple's System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

# ------- IDE -------
alias ps='open -na "PhpStorm.app" --args'

# ------- Functions -------

# Kills the process running on a given port
killport() {
    local port=$1
    local pid=$(lsof -ti tcp:$port)
    if [ -n "$pid" ]; then
        kill -9 $pid
        echo "✅ Process in port $port deleted (PID: $pid)."
    else
        echo "⚠️ There is no process running in $port port."
    fi
}

# ------- Local Configuration (Not tracked in Git) -------
if [[ -f ~/.zsh_aliases ]]; then
    source ~/.zsh_aliases
fi
