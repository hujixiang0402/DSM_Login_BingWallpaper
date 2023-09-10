#如需收集每日美图去掉下面注释设置保存文件夹路径
savepath="/volume1/WallPaper/img" #改成自己本地的地址如果不需要则注释
#在FileStation里面右键文件夹属性可以看到路径
pic=$(wget -t 5 --no-check-certificate -qO- "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=zh-CN")
#API图片库根据自己所需的图片库进行配置，这里默认使用的是网上的bing （必应图库API）
#随机天数，随机选中7天内壁纸的图片"+$[RANDOM%7]+" idx = 0-6 天内的图片
# pic=$(wget -t 5 --no-check-certificate -qO- "https://www.bing.com/HPImageArchive.aspx?format=js&idx="+$[RANDOM%7]+"&n=1")

echo $pic|grep -q enddate||exit
link=$(echo https://www.bing.com$(echo $pic|sed 's/.\+"url"[:" ]\+//g'|sed 's/".\+//g'))
date=$(echo $pic|sed 's/.\+enddate[": ]\+//g'|grep -Eo 2[0-9]{7}|head -1)
tmpfile=/tmp/$date"_bing.jpg"
wget -t 5 --no-check-certificate $link -qO $tmpfile
[ -s $tmpfile ]||exit
rm -rf /usr/syno/etc/login_background*.jpg
cp -f $tmpfile /usr/syno/etc/login_background.jpg &>/dev/null
#注意，以下命令在DSM7.0中已弃用，文件已无法找到。丢弃。
#cp -f $tmpfile /usr/syno/etc/login_background_hd.jpg &>/dev/null
#替换群晖DSM7.0的第一张默认登陆壁纸，路径如下注意备份。
cp -f $tmpfile /usr/syno/synoman/webman/resources/images/1x/default_login_background/dsm7_01.jpg &>/dev/null
cp -f $tmpfile /usr/syno/synoman/webman/resources/images/1x/default_wallpaper/dsm7_01.jpg &>/dev/null
#替换群晖DSM7.0的第一张默认登陆壁纸，路径如下注意备份。
cp -f $tmpfile /usr/syno/synoman/webman/resources/images/2x/default_login_background/dsm7_01.jpg &>/dev/null
#主页壁纸第一张
cp -f $tmpfile /usr/syno/synoman/webman/resources/images/2x/default_wallpaper/dsm7_01.jpg &>/dev/null
title=$(echo $pic|sed 's/.\+"title":"//g'|sed 's/".\+//g')
copyright=$(echo $pic|sed 's/.\+"copyright[:" ]\+//g'|sed 's/".\+//g')
word=$(echo $copyright|sed 's/(.\+//g')
if [ ! -n "$title" ];then
cninfo=$(echo $copyright|sed 's/，/"/g'|sed 's/,/"/g'|sed 's/(/"/g'|sed 's/ //g'|sed 's/\//_/g'|sed 's/)//g')
title=$(echo $cninfo|cut -d'"' -f1)
word=$(echo $cninfo|cut -d'"' -f2)
fi
sed -i s/login_background_customize=.*//g /etc/synoinfo.conf
echo "login_background_customize="yes"">>/etc/synoinfo.conf
#sed -i s/login_welcome_title=.*//g /etc/synoinfo.conf
#echo "login_welcome_title="$title"">>/etc/synoinfo.conf
sed -i s/login_welcome_msg=.*//g /etc/synoinfo.conf
#将背景图片信息仅显示 地点 传送至登录页面的欢迎消息对话框中。
#echo "login_welcome_msg="$word"">>/etc/synoinfo.conf
#将背景图片信息仅显示 标题 传送至登录页面的欢迎消息对话框中。
# echo "login_welcome_msg="$title"">>/etc/synoinfo.conf
#将背景图片信息以 标题-地点 From bing.ioliu.cn 传送至登录页面的欢迎消息对话框中。
echo "login_welcome_msg="$title""-""$word"">>/etc/synoinfo.conf
if (echo $savepath|grep -q '/') then
# cp -f $tmpfile $savepath/$date@$title-$word.jpg #这段无效不知道为什么保存不了文件
cp -f $tmpfile $savepath
fi
rm -rf /tmp/*_bing.jpg
