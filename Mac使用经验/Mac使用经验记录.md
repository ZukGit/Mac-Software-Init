# Mac隐藏代码功能

## Finder文件夹

### 显示路径
```
Command + Shift + .（句号） //显示隐藏文件



Shift + Command + G     //  在Find中 打开前往文件夹弹框

Shift + Command + H   // 打开当前用户Home目录
Shift + Command + K   // 打开网络(打开网络路由硬盘)
Shift + Command + A     //  在Finder中快速打开我的程序路径
Shift + Command + C     //  在Finder中快速打开我的电脑 盘符路径
Shift + Command + D     //  在Finder中快速打开我的桌面路径
Shift + Command + N  	// 新建文件夹
Option  +  Command  + N	       // 新建智能文件夹
选中  +  Space空格    // 显示简介


Command +  delete              // 删除选中项


Command +  ↑    // Finder中回到上一个父文件夹路径
Command + 【    // Finder中历史记录往前   子目录
Command +  】    // Finder中历史记录往后  父目录


Command + c   // 复制
Command + option + v  // 黏贴


隐藏代码:

defaults write com.apple.finder _FXShowPosixPathInTitle -bool TRUE;killall Finder   //打开Finder显示路径
defaults delete com.apple.finder _FXShowPosixPathInTitle;killall Finder  //恢复默认Finder显示



```


### 隐藏|显示   系统隐藏文件夹
```

defaults write com.apple.finder AppleShowAllFiles -bool true     //显示
defaults write com.apple.finder AppleShowAllFiles -bool false    // 隐藏

killall Finder    //  重启Finder生效
```
### Finder 中总是显示文件名的后缀

```
再也不会因为后缀名被隐藏而造成烦恼了

defaults write NSGlobalDomain AppleShowAllExtensions -bool true



```

### 显示~/Library/ 目录
```

这个目录默认是隐藏的，我们可以在不显示所有隐藏文件的前提下单独显示它：

chflags nohidden ~/Library


```




## Settings设置


### 安全设置-允许安装三方APP
```
sudo spctl --master-disable    // 打开Mac安全设置下  允许安装所有应用的隐藏选项 安装非APP Store的软件
defaults write com.apple.LaunchServices LSQuarantine -bool false




```

### 声音设置
```
=======开机声音duang
sudo nvram SystemAudioVolume=%80         // 关闭开机声音
sudo nvram -d SystemAudioVolume         // 打开开机声音


sudo nvram BootAudio=%00       // 关闭启动音
sudo nvram BootAudio=%01       // 恢复启动音

brew  cask install background-music  // 下载 background-music 设置声音 调到最低 开机就不会有声音


```


### 显示电量百分比
```

显示电量百分比
defaults write com.apple.menuextra.battery ShowPercent -string "YES"



```



## Launch显示板

```
======= 删除Launch显示问号顽固图标
defaults write com.apple.dock ResetLaunchPad -bool true    //删除在Launch中已经显示问号的删除不掉的顽固图标
killall Dock                                              //删除在Launch中已经显示问号的删除不掉的顽固图标
killall SystemUIServer                                   //重启系统UI 顽固图标消失


```

## Dock栏

```
======= 添加空白分割区域到Dock栏
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'; killall Dock

=======添加最新使用应用栏到Dock栏
defaults write com.apple.dock persistent-others -array-add '{"tile-data" = {"list-type" = 1;}; "tile-type" = "recents-tile";}'; killall Dock




```

## Tool工具


### 截图设置
```
Shift + Command + 3   // 全屏截屏

Shift + Command + 4   // 手动截屏

defaults write com.apple.screencapture location ~/Desktop      // 把屏幕截图保存的位置   shift+command+3  或者 shift+command+4 截图
defaults write com.apple.screencapture type jpg               // 设置截图格式为 jpg
defaults write com.apple.screencapture type png               // 设置截图格式为 png



```

## 键盘问题

### F1-F12与Fn调换问题
```

默认情况下，键盘上的 F1-F12 是特殊键，偏向娱乐，比如 F1、F2 调整亮度，F11、F12 调整声音等。
其实 F1-F12 可以用作快捷键，但需要配合键盘左下角的 Fn 键一起按下
此隐藏设置代码的作用是让 F1 键成为真正的 F1，如果调节亮度才需要 Fn + F1:


defaults write -globalDomain com.apple.keyboard.fnState -int 1  // 默认打开Fn
defaults write -globalDomain com.apple.keyboard.fnState -int 0  // 恢复默认




```


### 完全键盘控制
```
开启之后在弹出系统弹窗时可点击 Tab 键在多按钮直接切换，点击空格选中当前选项

defaults write NSGlobalDomain AppleKeyboardUIMode -int 3


```

## 触控板

### 触控板轻触点击
```
再也不用咔擦咔擦狂戳触摸板了，轻轻触摸就起到了点击的作用，非常优雅：

defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1


```


### 开启三指拖动
```
开启这个功能后，我们可以用三个手指拖动非全屏窗口，改变他们的位置。主要靠这两行命令实现：

defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true



```


# 实用问题


## iterm2-SHELL头缀只显示PC名称不显示路径 && 自定义别名问题
```

PS1='%d%'
https://www.jianshu.com/p/bf488bf22cba

ITERM2 恢复默认设置
defaults delete com.googlecode.iterm2




Iterm2-Preference--Profile--Send Text At Start 
=====
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad
export PS1='%d$'
alias cls='clear'
alias cdd='cd $HOME/Desktop/'
alias gits='git status'
export PATH="$HOME/Desktop/zbin/mac_zbin:$PATH"
clear



```




## Finder下右键无法快速进入到shell
```
右击文件 --- 服务  --- 在此文件启动 iterm2

```



## Finder下没有文件夹标签

```
添加到侧边栏中解决

```


## 在Mac下使用notepad++的问题
```

使用   ultraedit 作为 Mac的 编辑器
https://www.ultraedit.com/downloads/uex.html
https://www.cr173.com/mac/213230.html

1、下载官方UltraEdit 18.00.0.22版本并安装；
2、运行一次UltraEdit，关闭；
3、控制台运行如下代码(其实就是修改skProtectionPlus::IsActivated函数)：

printf '\x31\xC0\xFF\xC0\xC3\x90' | dd seek=$((0x76DC40)) conv=notrunc bs=1 of=/Applications/UltraEdit.app/Contents/MacOS/UltraEdit





```

## 在Mac上使用Markdown的问题
```
使用MacDown作为 Mac的 Markdown编辑器




```




