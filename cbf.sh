#!/bin/bash

cd $(dirname `readlink -f $0`)

./vendor/bin/phpcbf \
	--standard=/www/phpcs/tango.xml \
	Test.php \
	&& echo && echo 'check ok'
