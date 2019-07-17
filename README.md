# Mac-Software-Init

## Mac-setup 🍇

![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 简介 🙉

这是一个为你的Mac自动安装软件的Bash脚本，让你抽出时间喝咖啡而不是把时间花费在下载和安装你需要的软件。

本项目有两个分支，master分支用于提供稳定可用的版本，feather分支用于开发新特性，任何改动都会先在feather上进行，然后合并到master上。

本项目目前属于v0.2版，用于为OS X用户，尤其是为重装OS X系统之后的用户配置软件开发以及日常的娱乐环境，主要特点有

1. 涵盖开发以及日常生活的常用软件包
2. 菜单式选择

## 要求

系统版本，至少OS X 10.12起，也就是Sierra，由于brew对老版本的OS X系统支持很差，也直接导致本项目在低于OS 10.12 的OS X系统上可能无法正常运行。

## 缘起 🙈

每一次我的Mac使用了半年左右，我就会重新安装一遍系统，因为有些东西累积的太多了，需要清理一下，一般我都是备份文件之后，就直接重新在线安装OS X，但是面对干干净净的系统，我总是需要花上小半天的时间来配置我需要的工作环境，比如安装一下vim，配置一下vimrc，去下载jetbrains公司的IDE用于开发，安装一下MySQL这种常见的数据库等，一开始觉得配置挺有意思，还很有成就感，但是做了两次之后就再也不想这么干了，因为新鲜感早已过去，剩下的只是消耗时间的重复，所以我写了这么个脚本来自动安装一些常用的软件。

## 注意事项

* 保持系统在一个较新的版本

由于Homebrew对OS X的系统版本有要求，比如要求至少OS X 10.12这种（毕竟现在都出到Mojave，也就是OS X 10.14了），低版本的系统不满足Homebrew的要求，会导致某些软件包无法安装。

* 安装卡住了怎么办

直接Ctrl+C，这样做会打断当前软件包的安装，直接进行下一软件包的安装。

* 源的问题

由于国内直接访问Homebrew的官方源很慢（龟速那种慢），所以本脚本将源换成了中国科学技术大学USTC的源，homebrew-core, homebrew-cask以及源代码仓库全都换了，当然，脚本的最后，提供了将源改回Homebrew的官方源的选项，如果不想使用国内的源，那么可以选择切换为默认的源（如果你没有代理手段，建议还是使用国内的源）

* 代理的问题

本来一开始我是打算先安装shadowsocks-libev，然后配置代理，最后再用Homebrew进行软件包安装的，但是，考虑到不是所有人都有[shadowsocks服务器端](https://github.com/jsycdut/shadowsocks-install-scripts)或者其他手段绕过GFW的，所以就放弃了，该而用国内的源以提高访问速度。但是，如果，你的终端配置了代理，又想使用本安装脚本，那么就需要关闭你的终端代理，然后再使用本脚本，要不然，开着代理去海外绕一圈再回来，就很难受了。

## 使用 🙊

打开您喜欢的终端模拟器，简单执行下面两条命令即可

```bash
git clone https://github.com/jsycdut/mac-setup && cd mac-setup
chmod u+x install.sh &&./install.sh
```

安装软件包的时间，和您的网络情况有关，也和安装目标有关，比如安装包动辄几百MB的CLion，Intellij-IDEA，就需要多花一点时间，请耐心等待，如果等不及，那么，Ctrl+C打断即可跳过当前的安装。

## 软件清单 🐕

软件清单分两个，`cli.txt gui.txt`，cli.txt中，包含了可以使用`brew install`来安装的一些命令行软件工具，比如wget，vim，curl，node.js，npm等，gui.txt中，包含了使用`brew cask install`来安装的图形化界面工具，比如QQ，微信，网易云音乐，Intelij IDEA等。

![app_list](https://raw.githubusercontent.com/jsycdut/photos/master/mac-setup/app-list.png)

```text
#  命令行软件工具清单 cli.txt

1. wget 命令行下载工具         2. curl URL处理工具     3. mysql MySQL数据库
2. aria2 命令行下载工具        5. tree 展示树形目录    6. vim 编辑器之神Vim
3. node.js 网络应用构建框架    8. npm node包管理工具   9. shadowsocks-libev Shadowsocks命令行客户端

#  图形化软件工具清单 gui.txt

1.  qq 腾讯QQ                            2. wechat 微信                       3. telegram-desktop 电报Telegram
4.  neteasemusic 网易云音乐              5. iina 视频播放器                   6. typora Markdown编辑器
7.  google-chrome 谷歌浏览器             8. firefox 火狐浏览器                9. alfred 软件启动工具
10. iterm2 终端模拟器                   11. wireshark 抓包工具Wireshark      12. teamviewer 远程控制工具
13. intellij-idea JVM平台语言IDE        14. pycharm Python开发工具           15. clion C以及C++开发工具
16. datagrip 数据库操作的瑞士军刀       17. webstorm 前端开发利器
```

## 添加自定义的软件清单

直接修改cli.txt以及gui.txt就可以了，不过需要注意规则，因为脚本需要从这两个文本文件来读取软件包的名称，相信你一眼就能看出文本文件的规则，那就是`序号 英文句号 空格 软件包在brew仓库中的名称 软件包的简单介绍 空格 然后后面还有的话安装前面的规则继续写`，注意，每行只写三个软件包，只有最后一行才能少于三个软件包，否则都会导致无法正确解析出与序号对应的软件包名称，也就无法安装了。

## Travis CI✨

本项目已移除Travis CI，因为前期的集成已经验证项目能正常工作了，由于项目中存在很多需要交互的地方，需要用户输入，这不利于CI的时候进行操作。尽管Travis CI很好，但是还是移除了。

## star与fork以及项目维护

如果您喜欢这个项目，可以star或者fork一波（逃 🏃 ， 关于维护，我个人会尽量维护这个项目的，也欢迎大家提PR。

## 使用效果 🐈

在我的MacBook Pro 2015，OS X 10.11.6(系统已经比较旧了)的安装效果如下，这里因为我的系统比较旧，所以安装iTerm2就不满足依赖要求，无法安装，还有安装cli程序比如mysql，node.js，npm等都被brew“拒绝”，所以，希望使用的同学将系统尽量更新到较新的版本，这样安装也会顺利些。

![install-gui](https://raw.githubusercontent.com/jsycdut/photos/master/mac-setup/install-gui.png)
![install-cli](https://raw.githubusercontent.com/jsycdut/photos/master/mac-setup/install-cli.png)
