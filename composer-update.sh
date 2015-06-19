#!/bin/bash

# 用 git submodule + 独立 git branch 来提交和保存 composer 的 vendor 目录，
# 以便在生产环境使用 composer 时减少问题

# readme:
# https://gist.github.com/zhengkai/6cc06df2467b22598dae#file-readme-md
#
# code:
# https://gist.github.com/zhengkai/6cc06df2467b22598dae#file-composer-update-sh
#
# author: Zheng Kai (zhengkai@gmail.com)
# 2015-06-12

VENDOR_TMP_DIR='tmp-vendor'
VENDOR_GIT=''
VENDOR_BRANCH='vendor'

VENDOR_CLEAN_DOTFILES=1

cd $(dirname `readlink -f $0`)

if [ ! -d '.git' ]; then
	echo 'ERROR: git not found'
	exit 1
fi

# 确认 vendor 是否已经被正确的设置为 submodule
if [ ! -d 'vendor' ]; then
	if [ -e 'vendor' ]; then
		echo 'ERROR: "/vendor" is not a directory'
		exit 1
	fi
	git submodule init
	git submodule update
fi
if [ ! -f 'vendor/.git' ]; then
	echo 'ERROR: no submodule at "/vendor"'
	exit 1
fi

# vendor default git url
if [ -z "$VENDOR_GIT" ]; then
	VENDOR_GIT=`git config --get remote.origin.url`
fi

echo 'vendor git url: '${VENDOR_GIT}' '${VENDOR_BRANCH}
echo

# check vendor tmp dir exists
if [ ! -d ${VENDOR_TMP_DIR} ]; then
	if [ -e ${VENDOR_TMP_DIR} ]; then
		echo 'ERROR: "/${VENDOR_TMP_DIR}" is not a directory'
		exit 1
	fi
	git clone --single-branch --depth 1 -b ${VENDOR_BRANCH} ${VENDOR_GIT} ${VENDOR_TMP_DIR}
fi

cd ${VENDOR_TMP_DIR}

composer update

git co .
git clean -df
if [ -z "`git branch | grep -x \"\\*\\ ${VENDOR_BRANCH}\"`" ]; then
	echo git checkout ${VENDOR_BRANCH}
	git checkout ${VENDOR_BRANCH}
fi
git pull --rebase

cp ../mod-composer.json ./composer.json

echo
echo '                   'run composer update
echo

# composer update

if [ -d vendor ]; then
	cp -R vendor/* ./
fi

find -depth -name '.git' -type d -not -path './.git*' -not -path './vendor/*' -exec rm -rf {} \;
if [[ "$VENDOR_CLEAN_DOTFILES" -ne 0 ]]; then
	find -name '.*' -type f -not -path './.git*' -not -path './vendor/*' -exec rm {} \;
fi
find -depth -empty -type d -not -path './.git*' -exec rm -r {} \;

DATE=`date --date='TZ="Asia/Shanghai" now' +'%Y-%m-%d %H:%M:%S'`
echo ${DATE}

# # for debug
# echo $DATE > datetime.txt

DO_COMMIT=1

CHANGE=`git status --porcelain 2>&1 | wc -l`
if [ "$CHANGE" -lt 1 ]; then
	echo
	echo '                   'no change, exit
	echo
	exit
fi

echo
echo '                   'git commit
echo

# 如果 composer 没有创建过初始的 vendor 目录，
# 会在第一次运行的时候会以随机hash的形式为 autoload class 起名。
# 这里是在检查，如果只是 autoload class 名称有变化，则还原，
# 以避免无意义的 commit

CHECK_AUTOLOAD_ONLY=`git status --porcelain 2>&1 \
	| grep -v '^\ M\ autoload\.php$' \
	| grep -v '^\ M\ composer/autoload_real\.php$' \
	`
if [ -z "$CHECK_AUTOLOAD_ONLY" ] && [ "$CHANGE" -eq 2  ]; then
	echo
	echo '           only autoload class name changed, restore'
	echo
	git checkout .
	cp autoload.php               vendor/autoload.php
	cp composer/autoload_real.php vendor/composer/autoload_real.php
	exit
fi

exit

git add .
git commit -m "$DATE"
git push

COMMIT=`git log -n 1 --format=%H`

cd ../vendor/
echo
echo '                   'git checkout "$COMMIT"
echo
git fetch
git checkout "$COMMIT"
