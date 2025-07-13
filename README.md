# python_mc_launcher
# Python MC Pro Launcher - v9 Renaissance

![启动器主界面截图]([[https://github.com/xxccdl/python_mc_launcher/tree/main/image.png])

**一个使用 Python 和 CustomTkinter 构建的现代化、功能丰富的 Minecraft: Java 版启动器。**

本项目旨在提供一个媲美 PCL2、HMCL 等主流启动器的优秀游戏体验，同时保持代码的简洁、开源和易于扩展。它集成了版本管理、Mod 管理、账户系统和自动环境配置等核心功能，是所有 Python 爱好者和 Minecraft 玩家的理想选择。

---

## ✨ 核心功能

*   **🚀 现代化图形界面**: 基于 `CustomTkinter` 构建，支持亮色/暗色模式自适应，界面美观流畅。
*   **📦 智能版本管理**:
    *   自动扫描并列出已安装的游戏版本。
    *   一键安装 Minecraft 官方最新版或任意历史版本。
    *   无缝集成 **Forge** 和 **Fabric** 加载器安装，自动适配不同 Minecraft 版本。
*   **🧩 Mod 生态集成**:
    *   内置 **Mod 市场** 入口，可直接跳转到 CurseForge 等平台浏览和下载 Mod。
    *   提供“打开 Mods 目录”的快捷按钮，方便管理 Mod 文件。
*   **⚙️ 强大的环境配置**:
    *   **Java 自动管理**: 自动检测或引导用户安装合适的 Java 运行环境。
    *   **高级设置**: 支持自定义内存分配（-Xmx）、JVM 参数等，满足高阶玩家需求。
*   **👤 多账户系统**:
    *   支持离线模式下的多账户切换。
    *   轻松添加、删除和管理多个玩家档案。
*   **📊 实时日志监控**: 在独立窗口中实时显示游戏日志，方便开发者和玩家排查问题。
*   **💾 轻量化与开源**: 完全使用 Python 编写，代码开源，方便二次开发与学习。

---

## 🛠️ 技术栈

*   **主语言**: Python 3
*   **图形界面**: [CustomTkinter](https://github.com/TomSchimansky/CustomTkinter ) - 一个基于 Tkinter 的现代化 UI 库。
*   **MC 核心交互**: [minecraft-launcher-lib](https://github.com/Minecraft-Technik-Wiki/minecraft-launcher-lib ) - 处理 Minecraft 版本下载、安装、启动等核心逻辑。
*   **网络请求**: [Requests](https://requests.readthedocs.io/en/latest/ ) - 用于从网络 API 获取版本信息等。
*   **打包与安装**: 使用 `PyInstaller` (用于打包) 和 `批处理脚本` (用于制作 Windows 安装程序)。

---

## 📥 安装与使用

我们为 Windows 用户提供了便捷的一键安装程序。

### Windows 用户 (推荐)

1.  **下载安装包**:
    *   前往本项目的 [**Releases**]([请在这里粘贴您的GitHub Releases页面的URL]) 页面。
    *   下载最新的 `Python_MC_Pro_Launcher_Installer.zip` 文件。

2.  **解压并安装**:
    *   将下载的 `.zip` 文件解压，你会得到 `install.bat` 和 `data.zip` 两个文件。
    *   **非常重要**: 右键点击 `install.bat` 文件，选择“**以管理员身份运行**”。
    *   根据安装向导的提示完成安装。程序会自动检查并配置所需环境。

3.  **启动游戏**:
    *   安装完成后，桌面上会生成一个名为 “Python MC Pro Launcher” 的快捷方式。
    *   双击快捷方式即可启动！

> **注意**: 启动器首次运行时，版本列表可能为空。请使用“安装新版本”功能来下载您喜欢的 Minecraft 版本。
