#!/bin/zsh
# ─── terminal-setup: Zsh config ─────────────────────────────────────
# Powered by: Starship + zsh-autosuggestions + zsh-syntax-highlighting + fzf + fnm

# ─── Environment & PATH ──────────────────────────────────────────────
# 优先加载用户本地 bin 目录与 fnm 路径
export PATH="$HOME/.local/bin:$HOME/.local/share/fnm:$PATH"

# Homebrew 兼容判断 (macOS Apple Silicon / Intel / Linuxbrew)
if [[ -d /opt/homebrew ]]; then
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
    BREW_PREFIX="/opt/homebrew"
elif [[ -d /home/linuxbrew/.linuxbrew ]]; then
    export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
    BREW_PREFIX="/home/linuxbrew/.linuxbrew"
elif [[ -d "$HOME/.linuxbrew" ]]; then
    export PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
    BREW_PREFIX="$HOME/.linuxbrew"
elif [[ -d /usr/local/Homebrew || -f /usr/local/bin/brew || -d /usr/local/Cellar ]]; then
    export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
    BREW_PREFIX="/usr/local"
elif (( $+commands[brew] )); then
    BREW_PREFIX="${commands[brew]:h:h}"
    export PATH="$BREW_PREFIX/bin:$BREW_PREFIX/sbin:$PATH"
else
    BREW_PREFIX=""
fi

# Go 环境 (存在时自动加载)
if [[ -d /usr/local/go ]]; then
    export GOROOT=/usr/local/go
    export PATH="$PATH:$GOROOT/bin"
fi
if [[ -d "$HOME/go/bin" ]]; then
    export GOPATH="$HOME/go"
    export PATH="$PATH:$GOPATH/bin"
fi

# pnpm 环境 (macOS: ~/Library/pnpm, Linux: ~/.local/share/pnpm)
if [[ -d "$HOME/Library/pnpm" ]]; then
    export PNPM_HOME="$HOME/Library/pnpm"
elif [[ -d "$HOME/.local/share/pnpm" ]]; then
    export PNPM_HOME="$HOME/.local/share/pnpm"
else
    [[ "$OSTYPE" == darwin* ]] && export PNPM_HOME="$HOME/Library/pnpm" || export PNPM_HOME="$HOME/.local/share/pnpm"
fi
case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Bun 环境 (存在时自动加载)
if [[ -d "$HOME/.bun" ]]; then
    [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
fi

# Eza 配色设置
export EZA_COLORS="di=93:fi=97:ex=92:sn=36:sb=96:uu=95:gu=97:da=37"

# ─── Starship prompt ────────────────────────────────────────────────
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

# ─── Zsh plugins & Completions ──────────────────────────────────────
# Autosuggestions (fish-like suggestions)
if [[ -n "$BREW_PREFIX" && -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Completions
if [[ -n "$BREW_PREFIX" && -d "$BREW_PREFIX/share/zsh-completions" ]]; then
    fpath=("$BREW_PREFIX/share/zsh-completions" $fpath)
elif [[ -d /usr/share/zsh-completions ]]; then
    fpath=(/usr/share/zsh-completions $fpath)
fi
autoload -Uz compinit && compinit

# Substring + case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=*'

# ─── History ─────────────────────────────────────────────────────────
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# ─── Key Bindings ────────────────────────────────────────────────────
# 1. Home & End 键
bindkey '^[[H' beginning-of-line      # xterm
bindkey '^[[F' end-of-line            # xterm
bindkey '^[[1~' beginning-of-line     # tmux, screen, rxvt, putty
bindkey '^[[4~' end-of-line           # tmux, screen, rxvt, putty
bindkey '^[OH' beginning-of-line      # 某些特定终端
bindkey '^[OF' end-of-line            # 某些特定终端

# 2. Ctrl + Left / Right (按单词左右移动)
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[OD' backward-word
bindkey '^[OC' forward-word
bindkey '^[[5D' backward-word
bindkey '^[[5C' forward-word

# 3. 删除类按键
bindkey '^[[3~' delete-char           # Delete 键向后删除

# 4. 智能历史前缀搜索 (↑ / ↓ 箭头)
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# 5. PageUp & PageDown 键
bindkey '^[[5~' up-line-or-history
bindkey '^[[6~' down-line-or-history

# 6. Alt + S 快捷在命令行首添加 / 取消 sudo
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        BUFFER="${BUFFER#sudo }"
    else
        BUFFER="sudo $BUFFER"
    fi
    zle end-of-line
}
zle -N sudo-command-line
bindkey '^[s' sudo-command-line

# ─── fzf ─────────────────────────────────────────────────────────────
if [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
elif command -v fzf &>/dev/null; then
    eval "$(fzf --zsh 2>/dev/null)" || {
        # 兼容 Debian/Ubuntu apt 安装的 fzf 键位绑定路径
        [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
        [[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh
    }
fi
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# 自动适配 fd 或 Debian/Ubuntu 的 fdfind
if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
elif command -v fdfind &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fdfind --type d --hidden --follow --exclude .git'
fi

# ─── Atuin (shell history sync) ──────────────────────────────────────
# 初始化 Atuin 历史管理，--disable-up-arrow 保留原有的 ↑/↓ 智能前缀搜索，Ctrl+R 唤起 Atuin 历史看板
if command -v atuin &>/dev/null; then
    eval "$(atuin init zsh --disable-up-arrow)"
fi

# ─── Zoxide (smart cd) ──────────────────────────────────────────────
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# ─── fnm (Node version manager) ─────────────────────────────────────
if command -v fnm &>/dev/null; then
    eval "$(fnm env --use-on-cd --shell zsh)"
fi

# ─── SSH key switcher ────────────────────────────────────────────────
function set-ssh-key() {
    local key="$HOME/.ssh/$1"
    if [[ ! -f "$key" ]]; then
        echo "Key not found: $key" >&2
        echo "Available keys:" >&2
        command ls ~/.ssh/*.pub 2>/dev/null | sed 's/.*\//  /; s/\.pub$//' >&2
        return 1
    fi
    ssh-add -D 2>/dev/null
    ssh-add "$key"
    echo "Active SSH key: $1"
}

# ─── rgf: 交互式代码内容搜索 ──────────────────────────────────────────────
# 用途：结合 ripgrep 与 fzf，交互式筛选包含关键字的文件，并在右侧高亮预览匹配代码上下文
# 参数：$* 待检索的内容关键字或正则表达式
# 异常：未传入参数时输出使用帮助并返回非零状态码
rgf() {
    local pattern="${*:-}"
    if [[ -z "$pattern" ]]; then
        echo "用法: rgf <搜索关键字>" >&2
        return 1
    fi
    rg -l "$pattern" | fzf --preview "rg -n --color=always -C 3 \"$pattern\" {}"
}

# ─── Aliases ─────────────────────────────────────────────────────────
# System & modern coreutils
alias ls='eza --icons --group-directories-first'
alias la='eza -a --icons --group-directories-first'
alias l='eza -lg --icons --group-directories-first'
alias ll='eza -lga --icons --group-directories-first'
alias lt='eza -a --tree --icons --level=2'
alias find='fd'
alias grep='rg'
alias top='btop'
alias lg='lazygit'
alias y='yazi'
alias sr='sudo -i'
alias dus='du -d 1 -h | sort -hr'

# 兼容 Debian/Ubuntu 命令名
command -v batcat &>/dev/null && alias bat='batcat'
command -v fdfind &>/dev/null && alias fd='fdfind'

# Docker
alias dk='sudo docker'
alias dkp='sudo docker ps -a'
alias dki='sudo docker images -a'
alias dke='sudo docker exec -it'
alias dks='sudo docker stats --no-stream'

# Git
alias gs="git status"
alias ga="git add -A"
alias gc="git commit -m"
alias gac='git add -A && git commit -m'
alias gco="git checkout"
alias gpl="git pull"
alias gps="git push"
alias gl="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gb="git branch"
alias gd="git diff"
alias gr="git reset"

# ─── zsh-syntax-highlighting (保持在最底部) ──────────────────────────
if [[ -n "$BREW_PREFIX" && -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
