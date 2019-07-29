

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


test1


