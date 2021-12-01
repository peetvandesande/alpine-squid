.DEFAULT_GOAL := build

DOCKER_UID = 31
DOCKER_GID = 31
TOP_DIR = /srv/docker/squid
LOG_DIR = $(TOP_DIR)/log
CACHE_DIR = $(TOP_DIR)/cache
CONF_DIR = $(TOP_DIR)/etc

all: clean build install

clean:
	@echo "Removing current image"
	@docker rm squid

build:
	@echo "Building image"
	@docker build -t squid .

install: | $(CACHE_DIR) $(CONF_DIR) $(LOG_DIR)
	@echo "Installing image"
	cp -r etc/* $(CONF_DIR)
	@docker run --name squid -d --restart=always \
	       	--volume /srv/docker/squid/cache:/var/cache/squid \
		--volume /srv/docker/squid/log:/var/log/squid \
		--volume /srv/docker/squid/etc:/etc/squid \
		--network homenet \
		-p 3128:3128/tcp \
		squid

uninstall: clean
	@echo "Uninstalling image"
	rm -rf $(TOP_DIR)

$(CACHE_DIR): | $(TOP_DIR)
	@echo "Creating $(CACHE_DIR)"
	mkdir -p $@
	chown $(DOCKER_UID):$(DOCKER_GID) $@

$(CONF_DIR): | $(TOP_DIR)
	@echo "Creating $(CONF_DIR)"
	mkdir -p $@
	chown $(DOCKER_UID):$(DOCKER_GID) $@

$(LOG_DIR): | $(TOP_DIR)
	@echo "Creating $(LOG_DIR)"
	mkdir -p $@
	chown $(DOCKER_UID):$(DOCKER_GID) $@

$(TOP_DIR):
	@echo "Creating $(TOP_DIR)"
	mkdir -p $@
	chown $(DOCKER_UID):$(DOCKER_GID) $@
	chmod 0750 $@
