#!/bin/bash

/www/kt/vendor/squizlabs/php_codesniffer/scripts/phpcbf \
	-p \
	--standard=/www/phpcs/tango.xml \
	/www/kt/lib/zenddb.php \
