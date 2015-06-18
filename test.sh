#!/bin/bash

VIMCAT="$HOME/.vim/bundle/vimpager/vimpager"

cd $(dirname `readlink -f $0`)

cp demo.php out.php

./vendor/bin/phpcbf \
	--standard=ruleset.xml \
	out.php \
	&& echo && echo 'check ok'

git diff --no-index -- demo.php out.php > out.php.diff

if [ -e $VIMCAT ]; then
	$VIMCAT out.php.diff
else
	git diff --no-index -- demo.php out.php
fi

./vendor/bin/phpcs \
	--standard=ruleset.xml \
	out.php \
	&& echo && echo 'check ok'
