#!/bin/bash

cd $(dirname `readlink -f $0`)

cp Test.php TmpTest.php

./vendor/bin/phpcbf \
	--standard=/www/phpcs/tango.xml \
	TmpTest.php \
	&& echo && echo 'check ok'

colordiff -u Test.php TmpTest.php | less -R
