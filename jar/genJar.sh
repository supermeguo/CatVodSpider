#!/bin/bash

# 删除 custom_spider.jar
rm -f "$(dirname "$0")/custom_spider.jar"

# 删除 Smali_classes 目录及其子文件夹
rm -rf "$(dirname "$0")/Smali_classes"

# 使用 baksmali 反编译 dex 文件到 Smali_classes 目录
java -jar "$(dirname "$0")/3rd/baksmali-2.5.2.jar" d "$(dirname "$0")/../app/build/intermediates/dex/release/minifyReleaseWithR8/classes.dex" -o "$(dirname "$0")/Smali_classes"

# 删除 spider.jar 中的 com/github/catvod/spider、parser 和 js 目录
rm -rf "$(dirname "$0")/spider.jar/smali/com/github/catvod/spider"
rm -rf "$(dirname "$0")/spider.jar/smali/com/github/catvod/parser"
rm -rf "$(dirname "$0")/spider.jar/smali/com/github/catvod/js"

# 如果目录不存在，创建 catvod 目录
mkdir -p "$(dirname "$0")/spider.jar/smali/com/github/catvod"

# 移动 Smali_classes 下的 spider、parser、js 目录到 spider.jar
mv "$(dirname "$0")/Smali_classes/com/github/catvod/spider" "$(dirname "$0")/spider.jar/smali/com/github/catvod/"
mv "$(dirname "$0")/Smali_classes/com/github/catvod/parser" "$(dirname "$0")/spider.jar/smali/com/github/catvod/"
mv "$(dirname "$0")/Smali_classes/com/github/catvod/js" "$(dirname "$0")/spider.jar/smali/com/github/catvod/"

# 使用 apktool 重新打包 spider.jar
java -jar "$(dirname "$0")/3rd/apktool_2.4.1.jar" b "$(dirname "$0")/spider.jar" -c

# 将 dex.jar 移动到 custom_spider.jar
mv "$(dirname "$0")/spider.jar/dist/dex.jar" "$(dirname "$0")/custom_spider.jar"

# 计算 custom_spider.jar 的 MD5 值，并保存到 custom_spider.jar.md5
md5 -q "$(dirname "$0")/custom_spider.jar" > "$(dirname "$0")/custom_spider.jar.md5"

# 删除 spider.jar 中的 build、smali 和 dist 目录
rm -rf "$(dirname "$0")/spider.jar/build"
rm -rf "$(dirname "$0")/spider.jar/smali"
rm -rf "$(dirname "$0")/spider.jar/dist"

# 删除 Smali_classes 目录
rm -rf "$(dirname "$0")/Smali_classes"
