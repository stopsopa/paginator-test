
doc:
	@(cd docker && /bin/bash docker-compose.sh up)

docs:
	@(cd docker && /bin/bash docker-compose.sh stop)

# first run make doc
vendors:
	/bin/bash php.sh /bin/bash php.sh install-composer
	/bin/bash php.sh php composer.phar install

phpunit:
	/bin/bash php.sh php vendor/bin/phpunit

rmimage:
	docker rmi php:7.2.1-cli-intl-git

cli:
	/bin/bash php.sh bash

coverage: phpunit
	node server.js --port 8899 --dir build/html
	# visit after http://localhost:8899/index.html