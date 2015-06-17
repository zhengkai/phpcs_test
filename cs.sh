#!/bin/bash

/www/kt/vendor/squizlabs/php_codesniffer/scripts/phpcs \
	--standard=/www/phpcs/tango.xml \
	Test.php \
	&& echo && echo 'check ok'
