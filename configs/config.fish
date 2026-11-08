if status is-interactive
    # 交互式会话专用配置可在内部或下方放置
end

# ─── 环境变量与路径 (Environment & Paths) ──────────────────────────────
# Homebrew（自适应 Apple Silicon 与 Intel 架构）
if test -d /opt/homebrew
    fish_add_path /opt/homebrew/bin /opt/homebrew/sbin
else if test -d /usr/local/Homebrew -o -f /usr/local/bin/brew -o -d /usr/local/Cellar
    fish_add_path /usr/local/bin /usr/local/sbin
end

# 用户本地二进制目录
if test -d "$HOME/.local/bin"
    fish_add_path "$HOME/.local/bin"
end

# ─── 常用别名 (Aliases) ────────────────────────────────────────────────
# 文件浏览平替 (eza 带图标且目录排前)
if command -q eza
    alias ls "eza --icons --group-directories-first"
    alias la "eza -a --icons --group-directories-first"
    alias l "eza -lgh --icons --group-directories-first"
    alias ll "eza -lgha --icons --group-directories-first"
    alias lt "eza --tree --level=2 --icons --group-directories-first"
end

# 常用编辑器与 TUI 工具快捷映射
if command -q nvim
    alias vi nvim
end
if command -q yazi
    alias y yazi
end
if command -q lazygit
    alias lg lazygit
end
alias find "fd"
alias grep "rg"
alias top "btop"
alias sr "sudo -i"

# 兼容 Debian/Ubuntu 命令名
if command -q batcat
    alias bat "batcat"
end
if command -q fdfind
    alias fd "fdfind"
end

# 实用工具选项强化
alias tar "tar --no-xattrs" # 打包时禁止包含 macOS 专有扩展属性
alias dus "du -d 1 -h | sort -hr" # 查看当前目录下各子目录容量并降序排序

# AI 辅助工具
if command -q claude
    alias claude "claude --dangerously-skip-permissions"
    alias claude-ds "claude --settings ~/.claude/settings-ds.json --dangerously-skip-permissions"
end

# Docker 快捷指令
if command -q docker
    alias dk "sudo docker"
    alias dkp "sudo docker ps -a"
    alias dki "sudo docker images -a"
    alias dke "sudo docker exec -it"
    alias dks "sudo docker stats --no-stream"
end

# Git 常用操作缩写
if command -q git
    alias gs "git status"
    alias ga "git add -A"
    alias gc "git commit -m"
    alias gac "git add -A && git commit -m"
    alias gco "git checkout"
    alias gpl "git pull"
    alias gps "git push"
    alias gb "git branch"
    alias gba "git branch -a"
    alias gd "git diff"
    alias gr "git reset"
    alias gl "git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
end

# ─── 提示符与交互增强工具 (Prompts & Interactive Tools) ────────────────
# Starship 高颜值提示符
if command -q starship
    starship init fish | source
end

# fnm (Node.js 版本管理器)
if command -q fnm
    fnm env --use-on-cd --shell fish | source
end

# zoxide (基于使用频次的智能路径跳转)
if command -q zoxide
    zoxide init fish | source
end

# fzf (模糊查找工具集成)
if command -q fzf
    fzf --fish | source
    set -gx FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border'
    if command -q fd
        set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
        set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
        set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
    end
end

# Atuin (跨终端 Shell 历史记录同步)
if command -q atuin
    atuin init fish --disable-up-arrow | source
end

# ─── 包管理器与运行时路径 (Package Managers) ──────────────────────────
# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end

# Bun
set -gx BUN_INSTALL "$HOME/.bun"
if test -d "$BUN_INSTALL/bin"
    fish_add_path "$BUN_INSTALL/bin"
end

# ─── 自定义函数 (Functions) ──────────────────────────────────────────
# set-ssh-key: 切换当前激活的 SSH 私钥
# 用途：在多账号或多身份开发场景下，一键清空现有密钥并添加指定密钥至 ssh-agent
# 参数：$argv[1] 私钥文件名（位于 ~/.ssh 目录下，如 id_ed25519 或 custom_key）
# 异常：若密钥文件不存在则列出当前所有可用公钥并返回 1
function set-ssh-key -d "Switch active SSH key in ssh-agent"
    set -l key "$HOME/.ssh/$argv[1]"
    if not test -f "$key"
        echo "Key not found: $key" >&2
        echo "Available keys:" >&2
        for f in ~/.ssh/*.pub
            echo "  "(basename $f .pub) >&2
        end
        return 1
    end
    ssh-add -D 2>/dev/null
    ssh-add "$key"
    echo "Active SSH key: $argv[1]"
end

# rgf: 交互式代码内容搜索
# 用途：结合 ripgrep 与 fzf，交互式筛选包含关键字的文件，并在右侧高亮预览匹配代码上下文
# 参数：$argv 待检索的内容关键字或正则表达式
# 异常：未传入参数时输出使用帮助并返回非零状态码
function rgf -d "Search file contents with ripgrep and preview with fzf"
    if test (count $argv) -eq 0
        echo "用法: rgf <搜索关键字>" >&2
        return 1
    end
    set -l pattern "$argv"
    rg -l "$pattern" | fzf --preview "rg -n --color=always -C 3 \"$pattern\" {}"
end

