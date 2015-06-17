#!/bin/bash

/www/kt/vendor/squizlabs/php_codesniffer/scripts/phpcbf \
	--standard=/www/phpcs/tango.xml \
	Test.php \
	&& echo && echo 'check ok'
