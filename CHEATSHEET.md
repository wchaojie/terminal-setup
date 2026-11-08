# 🛠️ 现代化终端工具栈全景速查手册 (Cheatsheet)

本手册涵盖 `terminal-setup` 脚本所安装及配置的**全部工具、命令、快捷键与实用函数**。
所有工具已预先配置好主题、插件、别名以及跨平台协作。

---

## 📑 完整目录导航

1. [Shell 快捷键与高频操作 (Zsh)](#1-shell-快捷键与高频操作-zsh)
2. [路径穿梭与目录管理 (zoxide / yazi)](#2-路径穿梭与目录管理-zoxide--yazi)
3. [现代核心文件操作 (eza / fd / bat / file)](#3-现代核心文件操作-eza--fd--bat--file)
4. [高效文本与模糊搜索 (ripgrep / fzf)](#4-高效文本与模糊搜索-ripgrep--fzf)
5. [数据处理与对比助手 (jq / jd / tldr)](#5-数据处理与对比助手-jq--jd--tldr)
6. [Git 效率全家桶 (lazygit / delta / 常用别名)](#6-git-效率全家桶-lazygit--delta--常用别名)
7. [终端多路复用与会话 (zellij)](#7-终端多路复用与会话-zellij)
8. [提示符诊断与预设管理 (starship)](#8-提示符诊断与预设管理-starship)
9. [开发环境与运行时 (fnm / pnpm)](#9-开发环境与运行时-fnm--pnpm)
10. [系统性能监控与日常运维 (fastfetch / btop / 运维别名 / SSH切换)](#10-系统性能监控与日常运维-fastfetch--btop--运维别名--ssh切换)
11. [跨机器配置与 Dotfiles 管理 (chezmoi)](#11-跨机器配置与-dotfiles-管理-chezmoi)
12. [魔法历史记录与跨设备同步 (atuin)](#12-魔法历史记录与跨设备同步-atuin)
13. [终端模拟器快捷技巧 (Ghostty)](#13-终端模拟器快捷技巧-ghostty)

---

## 1. Shell 快捷键与高频操作 (Zsh)

| 快捷键 | 功能说明 | 场景举例 |
| :--- | :--- | :--- |
| `Alt + S` | **首尾快速切换 sudo** | 敲完一条命令发现权限不够，无需从头补打，直接按 `Alt+S` |
| `↑` / `↓` | **智能前缀历史搜索** | 输入 `docker` 后按上下键，只滚动以 `docker` 开头的历史命令 |
| `Ctrl + R` | **Atuin 历史命令全景看板** | 调出带有时间、耗时、退出码与按目录过滤的交互式历史查询看板 |
| `→` 或 `End` | **采纳自动补全建议** | 输入命令时出现灰色虚影提示，一键补全全句 |
| `Ctrl + ←` / `Ctrl + →` | **按单词左右跳跃** | 在长命令参数之间快速穿梭光标 |
| `Delete` | **向后删除字符** | 删除光标当前覆盖的字符 |
| `Ctrl + U` / `Ctrl + K` | **行剪切** | `Ctrl+U` 剪切光标前所有输入；`Ctrl+K` 剪切光标后内容 |
| `Ctrl + L` | **清屏** | 保持当前正在输入的命令行，清空屏幕上方杂乱输出 |

---

## 2. 路径穿梭与目录管理 (zoxide / yazi)

### 📁 zoxide — 智能目录跳转 (给终端装上导航记忆芯片)
```bash
z prj           # 模糊匹配并跳转到访问最频繁的包含 prj 的目录（如 ~/workspace/my-project）
z foo bar       # 输入多个关键词逐步精确缩小候选范围
zi              # 呼出交互式候选列表（上下箭头选择历史目录）
z -             # 返回上一次所在的目录（等同于 cd -）
```

### 🗂 yazi — 极速终端文件管理器 (带伴生工具 ya)
```bash
y               # 快速唤起 yazi（退出时自动将终端目录切至当前所处目录）
y /var/log      # 直接在指定路径打开 yazi
```
**核心操作键**：
- `j` / `k` 或 `↑` / `↓`：上下移动光标
- `h` / `l`：返回上一层 / 进入选中文件夹（或打开文件）
- `空格`：多选文件/文件夹
- `y` / `x` / `p`：复制 / 剪切 / 粘贴
- `d`：移动到系统回收站；`D`：物理永久删除
- `/`：在当前目录中模糊查找文件
- `~`：呼出完整帮助菜单；`q`：退出

**伴生命令行工具 `ya`**：
```bash
ya pack -a yazi-rs/plugins:git   # 一键安装 yazi 官方插件
ya pack -u                       # 更新所有已安装插件
```

**🎨 界面三栏比例自定义 (`~/.config/yazi/yazi.toml`)**：
- 官方默认比例为 `[mgr] ratio = [ 1, 4, 3 ]`（第二列过宽，预览区较窄）；
- 本配置已默认优化为 **`ratio = [ 1, 2, 5 ]`**（第二列紧凑，预览区域大幅拓宽至 62.5%，长行代码与文档一览无余）；
- 若需自定义调整，可在 `~/.config/yazi/yazi.toml` 的 `[mgr]` 段修改该数组。

---

## 3. 现代核心文件操作 (eza / fd / bat / file)

### 📦 eza — 现代替代 ls (带文件图标、Git 状态与树状图)
```bash
ls              # 基础目录清单（彩色、图标展示、文件夹排前）
l               # 详细列表（包含权限、精确文件大小、用户属组）
ll              # 完整详细列表（包含隐藏文件）
la              # 仅包含隐藏文件的快速简略视图
lt              # 2 层深度的树状目录结构视图 (tree)
eza -T --level=3 # 自定义查看 3 层深度目录树
```

### 🔍 fd — 现代替代 find (极速、默认跳过 .git 与 ignore 文件)
```bash
fd filename               # 快速模糊搜索文件名
fd -g "*.js"              # 通配符搜索特定格式文件
fd -t d src               # 仅搜索名称包含 src 的文件夹 (-t d: directory)
fd -t f config            # 仅搜索普通文件 (-t f: file)
fd -e png                 # 按文件扩展名精确搜索 (-e: extension)
fd -H filename            # 搜索包含隐藏文件和隐藏目录 (-H: hidden)
fd --size +100m           # 查找体积大于 100MB 的大文件
fd --changed-within 1d    # 查找最近 1 天内修改过的文件
fd --changed-within 1h    # 查找最近 1 小时内修改过的文件
fd -e log -x rm           # 批量操作：找到所有 .log 文件并直接执行删除 (-x: exec)
```

### 📄 bat — 现代替代 cat (语法高亮、行号与 Git 变更线标记)
```bash
bat file.py     # 查看文件带语法高亮与行号
bat main.go     # 高亮阅读代码文件
bat -n app.js   # 仅展示纯行号（不带外部边框）
bat -A data.txt # 显示所有非打印字符（制表符、行尾换行符）
```

### 📑 file — 文件真实格式与 MIME 探测 (Yazi 核心运行依赖)
```bash
file document.pdf          # 检查文件真实类型（即使无后缀或后缀被篡改）
file -bL --mime-type demo  # 纯输出文件的 MIME 类型（例如 text/plain, image/png）
file -i app.log            # 查看文件的字符编码集（如 charset=utf-8）
```

---

## 4. 高效文本与模糊搜索 (ripgrep / fzf)

### ⚡ ripgrep (`rg`) — 现代替代 grep (毫秒级全文内容检索)
```bash
rg "keyword"              # 递归搜索当前目录下所有文件内容（默认跳过 .git 与二进制）
rg -i "error"             # 忽略大小写搜索
rg -w "count"             # 精确整词匹配
rg -v "DEBUG"             # 反向匹配：仅输出不包含关键字的行 (-v: invert-match，过滤日志/注释神器)
rg -v '^#' config.yaml    # 过滤掉以 # 开头的注释行
rg "TODO" -t py           # 仅在 Python 文件中搜索指定模式 (-t: type)
rg "TODO" -T md           # 排除指定文件类型 (-T: type-not，在除 Markdown 之外的所有代码中搜索)
rg "import" -g "!*.test.*" # 排除特定测试文件 (-g: glob 过滤)
rg -C 3 "panic"           # 显示匹配行前后各 3 行上下文内容
rg -l "import"           # 仅输出包含匹配项的文件路径清单 (-l: files with matches，管道组合神器)
rg --files                # 快速列出所有将被检索的文件路径清单
rg --type-list            # 列出内置支持的所有预置语言与文件类型别名
```

### 🔍 fzf — 交互式模糊查找神器
```bash
Ctrl + R        # 交互式搜索并回填历史执行过的 Bash/Zsh 命令
Ctrl + T        # 在当前命令行光标处模糊查找文件路径并插入
Alt + C         # 模糊查找当前目录下的子文件夹并直接 cd 进入

# 智能补全触发 (在命令后输入 ** 再按 Tab 键)：
kill **<Tab>    # 模糊搜索系统运行中进程名，回车发送 kill 信号
ssh **<Tab>     # 模糊搜索 ~/.ssh/config 与 hosts 主机名直接连接
vim **<Tab>     # 模糊查找文件并用编辑器打开
cd **<Tab>      # 模糊搜索子目录并补全路径

# 经典管道联动技巧：
bat $(fzf)                                  # 模糊选择文件后立即用 bat 高亮预览
git branch | fzf | xargs git checkout       # 模糊挑选本地分支并切换

# 专属交互式内容搜索神器 rgf (已内置于 .zshrc 与 config.fish)：
rgf "import"                                # 交互式筛选含 import 的文件，右侧实时预览上下文匹配行
# 底层原理: rg -l "import" | fzf --preview 'rg -n --color=always -C 3 "import" {}'
```

---

## 5. 数据处理与对比助手 (jq / jd / tldr)

### 🧩 jq — 强大的命令行 JSON 格式化与查询处理器
```bash
# 格式化与美化输出
curl -s https://api.github.com/users/octocat | jq .

# 提取关键字段值
cat package.json | jq '.name'
jq -r '.version' package.json               # -r 提取纯文本原始值（不带引号，脚本中常用）

# 遍历与结构重组
cat users.json | jq '.[] | {id: .id, name: .name}'

# 条件过滤 (筛选 status 为 active 的条目)
cat data.json | jq '.items[] | select(.status == "active")'

# 统计数组长度与查看所有的 Key
cat data.json | jq '.items | length'
cat data.json | jq 'keys'
```

### 📑 jd — JSON 与 YAML 语义差异对比与补丁工具
> 传统的 `diff` 只会对比纯文本行，遇上字段调换顺序、格式化缩进变动就会产生大量误报；
> 而 `jd` 是专为结构化数据设计的**“语义比对器”**，只关注数据结构与值本身的实质变更，自动忽略乱序和缩进差异，并支持生成符合 RFC 6902 的标准补丁。

```bash
# 1. 结构化对比两个 JSON 文件
jd old.json new.json

# 2. 带有终端彩色语法高亮输出
jd -color old.json new.json

# 3. 对比两个 YAML 配置文件（Kubernetes / CI 配置利器）
jd -yaml old.yaml new.yaml

# 4. 生成标准 JSON 补丁 (RFC 6902 Patch 格式)
jd -f patch a.json b.json > diff.patch

# 5. 应用补丁 (Patch 模式)
jd -p diff.patch a.json > result.json

# 6. 配合管道使用
curl -s https://api.example.com/v1 | jd baseline.json -
```

### 📖 tldr — 告别繁琐 man，查看最常用的实战示例
> 比冗长的手册好用 10 倍，只给你最常用的 5~8 条经典用例命令：

```bash
tldr tar        # 查看 tar 压缩/解压的最常用命令（不用再记参数）
tldr curl       # 查看 curl 常见发送 GET/POST、带 Header 请求的例子
tldr docker     # 查看 docker 容器与镜像常见操作
tldr git commit # 查看 commit 命令典型用例
tldr --update   # （首次使用建议执行）更新本地手册离线缓存
```

---

## 6. Git 效率全家桶 (lazygit / delta / 常用别名)

### 🔀 lazygit — 终端 Git TUI 全功能控制台
```bash
lg              # 快速启动 lazygit 终端交互界面
```
- **核心面板快速跳转**：数字键 `1` (Files), `2` (Branches), `3` (Commits), `4` (Stash)；
- `空格`：暂存 (Stage) / 取消暂存单个文件或代码段；
- `c`：输入提交信息并执行 Commit；
- `P`：Git Push；`p`：Git Pull；
- `z`：撤销上一步操作；
- `?`：呼出当前面板完整快捷键说明。

### 🎨 delta — 语法高亮并排差异对比器
- 已配置为 Git 全局默认分页器：
  - 执行 `git diff`、`git show` 或 `git log -p` 时，自动采用语法高亮、并排（Side-by-side）或行内高亮模式渲染；
  - 遇到代码冲突时，以三路色彩明确标识（diff3 模式）。

### 常用 Git 快速命令别名
| 别名 | 完整命令 | 说明 |
| :--- | :--- | :--- |
| `gs` | `git status` | 查看当前工作区状态 |
| `ga` | `git add -A` | 暂存所有工作区变更 |
| `gc "feat: 描述"` | `git commit -m "..."` | 快速提交 |
| `gac "fix: 描述"`| `git add -A && git commit -m "..."` | 一键暂存并提交 |
| `gco <分支>` | `git checkout <branch>` | 切换目标分支 |
| `gb` | `git branch` | 查看本地分支清单 |
| `gd` | `git diff` | 查看未暂存代码差异 |
| `gpl` / `gps` | `git pull` / `git push` | 从远端拉取 / 推送到远端 |
| `gl` | `git log --graph ...` | 优美图形化单行提交日志图谱 |

---

## 7. 终端多路复用与会话 (zellij)

### 基础会话操作
```bash
zellij                     # 启动全新未命名 Zellij 会话
zellij -s work             # 创建名为 work 的会话（或已存在时连接）
zellij attach work         # 重新连接到后台运行的名为 work 的会话
zellij ls                  # 列出所有正在后台挂起的 Zellij 会话
zellij kill-session work   # 关闭并结束指定会话
```

### 核心快捷键模式
> Zellij 底部状态栏会根据当前模式实时显示可用按键：

- **`Ctrl + p` (Pane 面板管理)**：
  - `d`：向下分割新面板（上下分屏）
  - `r`：向右分割新面板（左右分屏）
  - `x`：关闭当前焦点面板
  - `f`：最大化当前面板全屏 / 再次按恢复
  - 方向键 `h`/`j`/`k`/`l`：在各个分屏面板间切换焦点
- **`Ctrl + t` (Tab 标签页管理)**：
  - `n`：新建一个标签页
  - `x`：关闭当前标签页
  - `1` ~ `9`：快速切换到对应序号标签页
- **`Ctrl + o` (Session 会话管理)**：
  - `d`：**脱离会话 (Detach)** —— 终端退出到原 shell，会话内运行的任务后台继续跑
- **`Ctrl + q`**：彻底退出并杀掉当前会话

---

## 8. 提示符诊断与预设管理 (starship)

Starship 会在安装时根据当前系统自动选用对应官方预设：
- **macOS 平台**：默认预设为 **Catppuccin Powerline**
- **Linux / WSL 平台**：默认预设为 **Gruvbox Rainbow**

```bash
starship explain                                                # 诊断当前提示符中各个模块的含义与执行耗时
starship timings                                                # 测量每个模块渲染耗时，排查终端卡顿
starship preset catppuccin-powerline -o ~/.config/starship.toml # 部署 Catppuccin 渐变预设 (macOS 默认)
starship preset gruvbox-rainbow -o ~/.config/starship.toml      # 部署 Gruvbox 彩虹预设 (Linux 默认)
starship preset nerd-font-symbols -o ~/.config/starship.toml    # 切换为极简纯图标预设
starship toggle <module>                                        # 临时关闭或打开指定模块 (如 starship toggle git_status)
```

---

## 9. 开发环境与运行时 (fnm / pnpm)

### 🟢 fnm (Fast Node Manager) — Rust 编写的极速 Node.js 多版本管理
```bash
fnm install --lts          # 下载并安装最新的 Node.js LTS 版本
fnm install 22             # 安装特定大版本 (如 Node 22)
fnm use 22                 # 临时在当前终端切换到 Node 22
fnm default 22             # 将 Node 22 设为系统默认生效版本
fnm ls                     # 列出本地已安装的所有 Node 版本
node -v                    # 验证当前生效版本
```
**项目级版本自动切换**：
在项目根目录创建 `.node-version` 或 `.nvmrc`（如 `echo "20" > .node-version`），`cd` 进入该目录时终端会自动切换对应 Node 版本。

### 📦 pnpm 预置环境
- 系统已自动配置 `PNPM_HOME` 环境变量并加入 PATH。
- 无需手动配置环境变量，安装全局包后即可直接执行对应命令。

---

## 10. 系统性能监控与日常运维 (fastfetch / btop / 运维别名 / SSH切换)

### 💻 fastfetch — 现代化极速系统信息展示看板 (默认 examples/25 样式)
> 基于 C 语言编写的高性能信息展示工具，已默认配置为官方精选的 `examples/25` 双线彩色结构化面板（包含 Hardware、Desktop、Terminal、Development 运行时环境及 Uptime）：

```bash
fastfetch                 # 直接执行，默认加载 ~/.config/fastfetch/config.jsonc (examples/25 预设)
fastfetch -c examples/25  # 显式使用 examples/25 预设
fastfetch --list-presets  # 列出官方内置的所有主题预设列表
```


### 📊 btop — 极客现代系统监控看板
```bash
btop            # 启动实时看板（CPU/内存/磁盘/进程监控）
top             # 已别名到 btop
```
- **常用快捷键**：
  - `m`：切换显示/折叠内存与磁盘面板
  - `p`：切换进程排序方式（按 CPU%、内存% 或 PID）
  - `f`：输入进程名称进行过滤
  - `k`：向选中进程发送 SIGKILL 强制结束
  - `q` / `Esc`：退出

### 🧰 实用运维快捷别名与函数
```bash
# 磁盘与权限
dus                       # 按体积从大到小倒序列出当前目录第一级文件夹占用 (du -d 1 -h | sort -hr)
sr                        # 快速以交互模式登录 root (sudo -i)

# Docker 快捷指令
dk                        # 等同于 sudo docker
dkp                       # 查看所有容器 (sudo docker ps -a)
dki                       # 查看所有镜像 (sudo docker images -a)
dke <容器名/ID> bash      # 快速进入容器交互终端 (sudo docker exec -it)
dks                       # 快速查看容器资源占用快照 (sudo docker stats --no-stream)

# 多 SSH 密钥一键切换 (解决个人/公司多 GitHub/GitLab 密钥冲突)
set-ssh-key               # 查看 ~/.ssh/ 目录下所有可用公钥列表
set-ssh-key my_work_key   # 一键清空并切换到指定的 SSH 私钥
```

---

## 11. 跨机器配置与 Dotfiles 管理 (chezmoi)

> `chezmoi` 是目前最强大的跨平台配置文件 (Dotfiles) 管理利器。
> 它将你的配置文件纳管在一个 Git 仓库中（位于 `~/.local/share/chezmoi`），支持模板化变量、敏感信息加密，并可在多台不同操作系统间一键无缝同步。

```bash
# 1. 首次初始化 (创建本地纳管仓库，或绑定已有远程仓库)
chezmoi init
chezmoi init https://github.com/username/dotfiles.git

# 2. 将现有配置文件纳入 chezmoi 管理
chezmoi add ~/.zshrc
chezmoi add ~/.config/starship.toml

# 3. 编辑已纳管的文件 (自动调用编辑器修改源文件)
chezmoi edit ~/.zshrc

# 4. 查看当前源仓库与实际系统环境的配置差异
chezmoi diff

# 5. 将仓库中的配置应用同步覆盖到系统实际路径
chezmoi apply

# 6. 快捷进入 chezmoi 所在的 Git 根目录
chezmoi cd
# 进入后可直接使用常规 git 提交: git add . && git commit -m "update" && git push

# 7. 在新机器上一键拉取并生效全部个人配置
chezmoi init --apply https://github.com/username/dotfiles.git
```

---

## 12. 魔法历史记录与跨设备同步 (atuin)

> `atuin` 采用高效的 SQLite 数据库替代传统的纯文本 `.zsh_history`，
> 完整记录命令执行的丰富上下文（精确执行时间、执行耗时、退出状态码、所在工作目录与主机名），
> 并支持通过端到端加密（E2EE）在多台机器间安全实时同步命令历史。

```bash
# 1. 核心交互快捷键
Ctrl + R                  # 唤起 Atuin 历史看板（上下箭头浏览，回车执行）
# 在看板中按 Tab 可在搜索模式间切换（模糊匹配 / 前缀匹配 / 正则）
# 按 Ctrl + R 或 Ctrl + O 可在全局历史 / 当前主机 / 当前工作目录筛选范围间快速切换

# 2. 命令行快速检索与过滤
atuin search <query>      # 在终端直接检索包含关键字的历史
atuin search -i <query>   # 启动交互式检索界面
atuin search -c .         # 仅检索在“当前目录”下执行过的历史命令

# 3. 跨设备加密同步 (可选，支持官方免费云端或自建服务器)
atuin register -u <user> -e <email> # 注册同步账号
atuin login -u <user>               # 在其他设备上登录
atuin sync                          # 手动触发多设备历史同步
atuin status                        # 查看同步连接与数据库状态

# 4. 导入已有历史
atuin import auto                   # 自动将现有 ~/.zsh_history 历史导入 Atuin 数据库
```

---

## 13. 终端模拟器快捷技巧 (Ghostty)

若使用官方推荐的 **Ghostty** 终端模拟器（Catppuccin Mocha 主题 + 14pt MesloLGS NF 字体）：

| 操作 / 快捷键 (macOS / Linux) | 功能说明 |
| :--- | :--- |
| `Cmd + D` / `Ctrl + Shift + O` | 水平向右分割当前终端窗格 |
| `Cmd + Shift + D` / `Ctrl + Shift + E` | 垂直向下分割当前终端窗格 |
| `Cmd + W` / `Ctrl + Shift + W` | 关闭当前选中的分屏窗格 |
| `Cmd + T` / `Ctrl + Shift + T` | 新建标签页 |
| `Cmd + 1` ~ `9` / `Alt + 1` ~ `9` | 切换到指定标签页 |
| `Cmd + Shift + ,` / `Ctrl + Shift + ,` | 重新加载 Ghostty 配置文件 |
| 配置文件路径 | macOS: `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`<br>Linux: `~/.config/ghostty/config` |
