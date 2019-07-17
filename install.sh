#! /bin/bash

cat << -EOF
#######################################################################
# 当前脚本用于在运行OS X的电脑上安装应用程序
# 原理为：利用homebrew作为OS X的包管理器
#         brew install 安装命令行程序
#         brew cask install 安装GUI程序
#         Happy coding ~ Happy life.
#
# Author: jsycdut
# Github: https://github.com/ZukGit/Mac-Software-Init
#
#
# 注意事项
#
# 1. OS X尽量保持较新版本，否则可能满足不了Homebrew的依赖要求
# 2. 中途若遇见安装非常慢的情况，可用Ctrl+C打断，直接进行下一项的安装
#######################################################################
-EOF

# 全局变量
row_number=0
column_number=0
type=cli
WD=`pwd`

# 安装Homebrew并换TUNA源
install_homebrew() {
  if `command -v brew > /dev/null 2>&1`; then
    echo '👌  Homebrew已安装'
  else
    echo '🍼  正在安装Homebrew'        # curl 下载网络自愿的工具    让ruby执行 curl拉取的代码
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    if [[ $? -eq 0  ]]; then     # [ $? -eq 0  ] 表示上一个命令成功执行  返回值为0表示执行成功
      echo '🍻  Homebrew安装成功'
    else
      echo '🚫  Homebrew安装失败，请检查网络连接...'
      exit 127
    fi
  fi

  echo '👍  为了让brew运行更加顺畅，将使用中国科学技术大学USTC提供的镜像，更新中，请等待...'
  cd "$(brew --repo)"   # repo --repo 命名返回  brew安装路径的home目录
  git remote set-url origin https://mirrors.ustc.edu.cn/brew.git   # 在当前的git路径 重新设置对应的远程分支

  cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"    # brew安装路径的home目录 里的 homebrew-core分支
  git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git

  cd "$(brew --repo)"/Library/Taps/homebrew/homebrew-cask  #  brew安装路径的home目录 里的 homebrew-cask分支
  git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git

  brew update
}

# 检查是否已安装某软件包
check_installation() {
  if [[ $type == "cli" ]]; then
    brew list -l | grep $1 > /dev/null   # brew list -l | grep "xx" 检测shell工具 xx 是否已经安装
  else
    brew cask list -1 | grep $1 > /dev/null    # brew cask list -l | grep "gg" 检测图形工具 gg是否已经安装       
  fi

  if [[ $? -eq 0 ]]; then    # [ $? -eq 0  ] 表示上一个命令成功执行  返回值为0表示执行成功
     return 0
  fi

  return 1    # 返回1 表示 当前软件没有安装 
}

# 使用brew安装软件包
install() {
  check_installation $1         # 把install 接收到的第一个参数 传给 check_installation 执行
  if [[ $? -eq 0 ]]; then              # 如果上一个命令返回0 表示已经安装
    echo "👌 ==>已安装" $1 "，跳过..."
  else
    echo "🔥 ==>正在安装 " $1            #  如果上一条命令返回非0  那么就需要执行安装程序
    if [[ "$type" == "cli" ]]; then      # 依据type 来判断安装类型是 shell工具  还是图形软件  
      brew install $1 > /dev/null          # 通过 brew install xxx  来执行软件的安装
      echo $?
    else
      brew cask install $1 > /dev/null   # 通过 brew cask install 安装图形化软件
    fi

    if [[ $? -eq 0 ]]; then          # 安装成功失败的判断
      echo "🍺 ==>安装成功 " $1
    else
      echo "🚫 ==>安装失败 " $1
    fi
  fi
}

# 显示菜单
show_menu() {
  echo
  read  -p "✨ 请选择要显示的软件包菜单列表类型 [0]命令行 [1]图形化(默认)：" ans  
  echo # 显示 字符串 并预期得到一个字符输入  把这个字符输入保存到 ans 中

  case $ans in   # 判断 ans的值  同 switch功能 
    0) cd $WD && cat cli.txt && type="cli"
    ;;
    1) cd $WD && cat gui.txt && type="gui"
    ;;
    *) cd $WD && cat gui.txt && type="gui"
    ;;
  esac

  echo
}

# 检查AWK是否可用   awk是一个文字处理的程序   对每行依次处理
check_awk() {
  if ! `command -v awk > /dev/null`; then    # command -v xxx 是一个判断软件是否安装的命令
    echo 未检测到AWK，请先安装AWK再执行本程序...
    exit 127
  fi
}

# 利用awk，从cli.txt gui.txt两文件中截取软件包名称
# 可能的输入参数
# (cli.txt,1,2)  (cli.txt,1,5) (cli.txt,1,8) (cli.txt,2,2)  (cli.txt,2,5) (cli.txt,2,8)
# (gui.txt,1,2)  (gui.txt,1,5) (gui.txt,1,8) (gui.txt,2,2)  (gui.txt,2,5) (cli.gui,2,8)
get_package_name() {    
  local file_name=$1       # 文件名称  
  local row=$2             # 第几行
  local col=$3             # 第几列 
  awk -v line=$row -v field=$col '{if(NR==line){print $field}}' $file_name
  # 使用awk 读取文件 $file_name 中第 row 行  第col列的 内容  这里就是程序的名称
  # wget  curl  mysql  aria2   tree  vim node.js   npm  shadowsocks-libev     shell工具
  # qq  wechat telegram-desktop  neteasemusic    wechat  iina typora .... 等等这样的 UI工具
  
}

# 计算与软件名称编号对应的行和列号码
# 不要破坏cli.txt gui.txt文件排版
# 否则会导致计算行列值失败，进而无法提取出正确的软件包名称   这对应需要安装软件的awk所识别的位置
# 输入 $1 为 1  时  输出:  row_number=1 column_number=2 (1,2)
# 输入 $1 为 2  时  输出:  row_number=1 column_number=5 (1,5)
# 输入 $1 为 3  时  输出:  row_number=1 column_number=8 (1,8)
# 输入 $2 为 1  时  输出:  row_number=2 column_number=2 (2,2)
# 输入 $2 为 2  时  输出:  row_number=2 column_number=5 (2,5)
# 输入 $2 为 3  时  输出:  row_number=2 column_number=8 (1,8)


locate() { 
  local tmp=`expr $1 + 2`
  row_number=`expr $tmp \/ 3`
  tmp=`expr $1 % 3`
  [ $tmp -eq 0 ] && tmp=3         # 如果当前的 tmp 的值为 0 (序号是3的倍数的话) 那么把tmp 设置为3 否则跳过
  column_number=`expr $tmp \* 3 - 1`
}

# 程序入口
echo
echo "🙏  请花5秒时间看一下上述注意事项"
sleep 5s
install_homebrew
while : ; do
  show_menu       # read 从 屏幕输入 得到数据
  read  -p "✍️  请输入您想要安装的软件包的编号（多个软件包请用空格分隔，直接回车则全部安装）" ans
  echo
  # 关于FS，经常awk的都不陌生,awk中有RS,ORS,FS,OFS 4个可以定义分隔符的变量
  # 而shell中的IFS同样也是来定义分隔符
  # IFS=‘\n’  //将字符n作为IFS的换行符。
  # IFS=$"\n" //这里\n确实通过$转化为了换行符，但仅当被解释时（或被执行时）才被转化为换行符。
  # IFS=$'\n' //这才是真正的换行符。  IFS 说明: https://blog.csdn.net/apache0554/article/details/47006609

  IFS=$'\n'
  
  # read 从ans 得到数据
  read -d "" -ra arr <<< "${ans//' '/$'\n'}" # 本脚本中最喜欢的一句代码了
# Read可以带有-a, -d, -e, -n, -p, -r, -t, 和 -s八个选项
# -a arr ：将内容读入到数值 arr 中 

# -d ：表示delimiter，即定界符
#一般情况下是以IFS为参数的间隔，但是通过-d，我们可以定义一直读到出现执行的字符位置
# 例如read –d madfds xxxx   输入xxx为hello m   那么 得到的输出为 “hello”，请注意m前面的空格等会被删除   

# -r ：在参数输入中，我们可以使用’/’表示没有输入完，换行继续输入，
#如果我们需要行最后的’/’作为有效的字符，可以通过-r来进行。此外在输入字符中，
#我们希望/n这类特殊字符生效，也应采用-r选项。
# 屏蔽特殊字符\的转译功能，加了之后作为普通字符处理


  # Shell 数组元素个数${#array[@]} 
  # 处理单纯的回车
  if [[ "${#arr[@]}" -eq 0 ]]; then    ## 如果数组 arr 中的数量为空 说明上面的操作中用户直接输入的回车
    lines=`wc -l "$type"".txt" | awk '{printf $1}'`   #  读取文件的行数
    count=`expr $lines \* 3`                          # 行数 * 3  得到总共需要安装的序列号
    for((i=0; i<$count; i++)); do
      arr[$i]=`expr $i + 1`              # 往 数组arr中添加 值 1.2.3.4.5.6.7.8.9  3的倍数
    done
  fi

  # 数组的所有元素${array[*]}
  for app in ${arr[*]}; do              # 如果arr从用户的输入读取了值的话 那么会执行  到这里 arr就一定有值
    if [ $app -eq $app 2>/dev/null ]; then   # 判断自己和自己相等? 还未理解
      :
    else
      continue  # 自己和自己不相等 就下一个循环 $app 代表的是序号  1.2.3.4.5.6.7
    fi

    locate $app   # 依据序号得到  (1,2) (1,5)(1,8) (2,2) (2,5)(2,8)
    name=`get_package_name "$type"".txt" $row_number $column_number`  # 这里获得程序名称
    [ -z "$name" ] && continue        # 如果获取到的程序名称为空  那么 执行 contiue 继续下一个循环
    install $name                     # 安装程序
  done

  read  -p "📕 是否继续查看菜单列表，Y/y继续，N/n退出 ：" ans
  case $ans in
    Y|y) :
    ;;
    *) break
    ;;
  esac
done

# 更改回Homebrew的官方源
cat << EOF
  目前正在使用中国科学技术大学的Homebrew源，建议没有配置网络代理的同学，
  保持现有状况，不要切回官方源，否则会导致以后安装软件包的下载速度缓慢，
  对于配置了网络代理的同学，也可以选择将源切换回官方的源。
EOF

sleep 1s
read  -p "是否需要将Homebrew的源改回为官方源，[Y/y]确认，直接回车将跳过" ans
case $ans in
  Y|y)
    echo "正在将Homebrew的源切换回官方源..."
    cd "$(brew --repo)"/Library/Taps/homebrew/homebrew-cask
    git remote set-url origin https://github.com/Homebrew/homebrew-cask
    cd "$(brew --repo)"
    git remote set-url origin https://github.com/Homebrew/brew.git
    cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
    git remote set-url origin https://github.com/Homebrew/homebrew-core
    echo "已将Homebrew的源切换回官方源."
  ;;
esac
