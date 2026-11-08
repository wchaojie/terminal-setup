if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Homebrew (auto-detect Apple Silicon vs Intel)
if test -d /opt/homebrew
    fish_add_path /opt/homebrew/bin
else if test -d /usr/local/Cellar
    fish_add_path /usr/local/bin
end

# Starship prompt
if command -q starship
    source (starship init fish --print-full-init | psub)
end

# fnm (Node version manager) — only if installed
if command -q fnm
    fnm env --use-on-cd --shell fish | source
end

# Atuin (shell history sync) — only if installed
if command -q atuin
    atuin init fish --disable-up-arrow | source
end

# SSH key switcher (fallback for multi-account setups)
# Usage: set-ssh-key lewis-official-20260224
# Prefer ~/.ssh/config Host aliases for automatic matching.
function set-ssh-key
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

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
