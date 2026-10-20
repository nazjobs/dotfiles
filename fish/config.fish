source /usr/share/cachyos-fish-config/cachyos-config.fish

alias shareon='sudo share-toggle.sh; echo 🟢 Sharing active'
alias shareoff='sudo share-toggle.sh; echo 🔴 Sharing disabled'

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

#
# Android SDK Environment Variables
#
set -gx ANDROID_HOME $HOME/Android/Sdk
set -gx ANDROID_AVD_HOME $HOME/.config/.android/avd

fish_add_path $ANDROID_HOME/emulator
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin

zoxide init fish | source

set -gx BROWSER zen-browser

# >>> conda initialize >>>
# Lazy conda init (only loads when you use conda)
function conda --wraps=conda
    # Remove this function so future calls use real conda
    functions -e conda
    # Run the real init
    eval /home/nazrawi/miniconda3/bin/conda "shell.fish" hook $argv | source
    # Call conda again with original arguments
    conda $argv
end

# Optional: alias for quick manual init if needed
alias conda-init='eval (/home/nazrawi/miniconda3/bin/conda shell.fish hook)'
# <<< conda initialize <<<

# API keys loaded from untracked file
source ~/.config/fish/secrets.fish

# Lazy Ollama initialization
function ollama --wraps=ollama
    # Remove this function so future calls use real ollama
    functions -e ollama

    # Start Ollama server if not running
    if not pgrep -x ollama >/dev/null
        echo "🔧 Starting Ollama server..."
        ollama serve &>/dev/null &
        sleep 1 # Give it a moment to start
    end

    # Execute the actual ollama command
    ollama $argv
end

# Custom config for pacman update
alias update='sudo pacman -Syu'
alias rateupdate='sudo cachyos-rate-mirrors && sudo pacman -Syu'

# Custom config for paru update
alias pudate='sudo pacman -Syu'

# initializes fnm in your shell and enable node version switching when changing directories
fnm env --use-on-cd | source

# Ensure local bin is at front of path without duplication
fish_add_path -m ~/.local/bin

# Configure fzf.fish bindings to avoid Hyprland compositor shortcuts:
# - Ctrl+Alt+L is reserved for screen lock -> remapped git log to Ctrl+Alt+G
# - Ctrl+Alt+P is reserved for powermenu (wlogout) -> remapped processes to Ctrl+Alt+T
if status is-interactive; and functions -q fzf_configure_bindings
    fzf_configure_bindings --git_log=ctrl-alt-g --processes=ctrl-alt-t
end

# ── Git & Developer Abbreviations ──────────────────────────────────────────
if status is-interactive
    # Git
    abbr -a g git
    abbr -a ga 'git add'
    abbr -a gaa 'git add -A'
    abbr -a gap 'git add -p'
    abbr -a gst 'git status'
    abbr -a gc 'git commit -m'
    abbr -a gca 'git commit -a -m'
    abbr -a gco 'git checkout'
    abbr -a gcb 'git checkout -b'
    abbr -a gsw 'git switch'
    abbr -a gb 'git branch'
    abbr -a gd 'git diff'
    abbr -a gdc 'git diff --cached'
    abbr -a gl 'git log --oneline -n 20'
    abbr -a glo 'git log --oneline --decorate --graph'
    abbr -a gp 'git push'
    abbr -a gpf 'git push --force-with-lease'
    abbr -a gpl 'git pull'
    abbr -a grb 'git rebase'
    abbr -a gsta 'git stash'
    abbr -a gstp 'git stash pop'

    # Rust
    abbr -a cr 'cargo run'
    abbr -a crr 'cargo run --release'
    abbr -a cb 'cargo build'
    abbr -a cbr 'cargo build --release'
    abbr -a cc 'cargo check'
    abbr -a ct 'cargo test'

    # Vue / Node / Frontend
    abbr -a pnd 'pnpm dev'
    abbr -a pnb 'pnpm build'
    abbr -a pni 'pnpm install'
    abbr -a pnx 'pnpm dlx'
    abbr -a nrd 'npm run dev'
    abbr -a nrb 'npm run build'

    # Dev tools
    abbr -a lg lazygit
    abbr -a v nvim
end
