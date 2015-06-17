#!/bin/bash

cd $(dirname `readlink -f $0`)

./vendor/bin/phpcs \
	--standard=tango.xml \
	Test.php \
	&& echo && echo 'check ok'
