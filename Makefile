.DEFAULT_GOAL := build

all: clean build

clean:
	@docker rm squid

build:
	@docker build -t squid .

install:
#	mkdir -p /srv/docker/squid/cache
#	mkdir -p /srv/docker/squid/log
#	chown -R 31:31 /srv/docker/squid
	@docker rm squid
	@docker run --name squid -d --restart=always \
	       	--volume /srv/docker/squid/cache:/var/cache/squid \
		--volume /srv/docker/squid/log:/var/log/squid \
		-p 3128:3128/tcp \
		squid

run:
	@docker rm squid
	@docker run --name squid -i \
	       	--volume /srv/docker/squid/cache:/var/cache/squid \
		--volume /srv/docker/squid/log:/var/log/squid \
		-p 3128:3128/tcp \
		squid 
