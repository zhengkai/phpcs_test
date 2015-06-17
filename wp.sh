#!/bin/bash

cd $(dirname `readlink -f $0`)

./vendor/bin/phpcs \
	--standard=WordPress \
	Test.php \
	&& echo && echo 'check ok'
