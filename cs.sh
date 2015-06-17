#!/bin/bash

cd $(dirname `readlink -f $0`)

cp Test.php TmpTest.php

./vendor/bin/phpcs \
	--standard=tango.xml \
	TmpTest.php \
	&& echo && echo 'check ok'
