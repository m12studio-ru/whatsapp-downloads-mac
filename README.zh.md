# WhatsApp Downloads

[English](README.md) · [简体中文](README.zh.md) · [हिन्दी](README.hi.md) · [Español](README.es.md) · [العربية](README.ar.md) · [Français](README.fr.md) · [Português](README.pt.md) · [Русский](README.ru.md) · [日本語](README.ja.md) · [Deutsch](README.de.md) · [Bahasa Indonesia](README.id.md) · [Türkçe](README.tr.md)

Mac 版 WhatsApp 会把所有东西一股脑儿丢进 `~/Downloads`，而且没有任何设置可以改。
这个小工具给它单独开一个文件夹，就像 Telegram Desktop 那样。

WhatsApp 存下来的文件，几秒钟后就会出现在 `~/Downloads/WhatsApp` 里。
`~/Downloads` 里的其他东西一概不动。

## 拖拽安装

文件在[最新发布页](https://github.com/m12studio-ru/whatsapp-downloads-mac/releases/latest)。

下载 `WhatsApp Downloads.dmg`，打开后把 **WhatsApp Downloads** 拖进 *Applications*。
然后**从「应用程序」文件夹里**打开它（不要直接从磁盘映像里打开），它会自动在后台完成安装。

这个 App 没有 Apple 开发者证书签名，所以第一次打开会被拦下来，提示*「文件已损坏」*或
*「无法验证」*。两种办法二选一：

- 右键点击 App 选择**打开**；如果弹窗只给了*完成* / *移到废纸篓*，就到
  *系统设置 → 隐私与安全性* 里点**仍要打开**；或者
- 一次性去掉隔离标记：

```sh
xattr -dr com.apple.quarantine "/Applications/WhatsApp Downloads.app"
```

如果你之前用命令行装过，打开这个 App 会把原来的后台任务替换成指向
`/Applications/WhatsApp Downloads.app` 的新任务。

想自己打包磁盘映像：

```sh
./build.sh
```

## 从命令行安装

```sh
git clone https://github.com/m12studio-ru/whatsapp-downloads-mac.git
cd whatsapp-downloads-mac
./install.sh
```

装完之后，macOS 会弹窗，询问是否允许 **WhatsAppDownloads** 访问「下载」文件夹 ——
点 **允许**。如果不小心错过了这个弹窗，可以到
*系统设置 → 隐私与安全性 → 文件和文件夹* 里手动打开。

想验证是否生效：往 `~/Downloads` 里放一个名为 `WhatsApp test.jpg` 的文件试试。

## 卸载

```sh
./uninstall.sh
```

你的文件原地不动，被删掉的只是这个搬运工具本身。

## 它都装了些什么

| 路径 | 说明 |
| --- | --- |
| `~/.local/bin/whatsapp-downloads.sh` | 负责搬文件的脚本，大约 15 行 zsh |
| `~/Applications/WhatsAppDownloads.app` | 一个极小的外壳程序，用来运行该脚本 |
| `~/Library/LaunchAgents/WhatsAppDownloads.plist` | `~/Downloads` 一有变化就把它叫醒 |

拖拽安装的版本只会放一个 `/Applications/WhatsApp Downloads.app`，外加同一个
`~/Library/LaunchAgents/WhatsAppDownloads.plist`。`./uninstall.sh` 两种装法都能清理干净。

为什么要套一层 app？因为 macOS 是按应用来授予文件夹权限的。由 launchd 直接启动的
纯脚本看到的「下载」文件夹是空的，于是什么也不会做，所以脚本得住在一个能持有权限的
app 里面。

它会出现在 *系统设置 → 通用 → 登录项 → 允许在后台运行* 中，名字是
**WhatsAppDownloads**，你随时可以在那里把它关掉。由于它是在你自己的机器上构建并本地
签名的，macOS 会提示开发者身份未经验证。

## 工作方式

- 只搬运文件名以 `WhatsApp ` 开头的文件 —— WhatsApp 就是这么命名的。
- 绝不覆盖：遇到重名会变成 `WhatsApp Image ... (1).jpeg`。
- 对 `.crdownload`、`.part` 和 `.download` 文件先放着不管，等浏览器下载完再说。
- 文件夹和其他所有文件一律不碰。

## 配置

改一改 `whatsapp-downloads.sh` 顶部那三个变量，或者设置环境变量 `WA_SRC`、
`WA_DST` 和 `WA_PREFIX` 即可。如果把 `WA_SRC` 改成 `~/Downloads` 以外的文件夹，
macOS 就会转而申请那个文件夹的访问权限。

## 测试

```sh
./test.sh
```

大约需要 90 秒。它走的是真实的后台链路 —— launchd、app 和权限，而不是直接调用脚本。
测试只会写入名字里带 `cctest` 的文件，跑完就自动删掉。

## 系统要求

macOS 13 或更高版本。无需任何依赖。

## 支持

这是一个小小的个人工具，按现状提供。欢迎提 issue 和 pull request，但不保证一定会回复。

## 许可证

MIT
