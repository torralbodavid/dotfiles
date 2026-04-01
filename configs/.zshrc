# ============================================================
# .zshrc - Configuración de shell
# Gestionado por dotfiles: https://github.com/tu-usuario/dotfiles
# ============================================================

# ------- SSH Aliases -------
alias par01='ssh par01'
alias par04='ssh par04'
alias par05='ssh par05'
alias par06='ssh par06'
alias par07='ssh par07'
alias par08='ssh par08'
alias mia03='ssh mia03'
alias bp02='ssh bp02'

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

# Mata el proceso que esté escuchando en un puerto dado
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
