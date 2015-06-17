#!/bin/bash

cd $(dirname `readlink -f $0`)

./vendor/bin/phpcbf \
	--standard=WordPress \
	Test.php \
	&& echo && echo 'check ok'
