HOSTNAME=deployer@meow.town
DEPLOY_TO=/home/deployer/releases
release_name := $(shell date +%Y%m%d%H%M)

deploy: cleanup
	@echo "Successfully deployed release $(release_name)"

cleanup: unpack
	rm releases/$(release_name).tar.gz

unpack: push
	ssh $(HOSTNAME) "cd $(DEPLOY_TO) && tar zxfv $(release_name).tar.gz"
	ssh $(HOSTNAME) "cd $(DEPLOY_TO) && ln -sfh $(release_name) current && rm $(release_name).tar.gz"

push: $(release_name).tar.gz
	scp releases/$(release_name).tar.gz $(HOSTNAME):$(DEPLOY_TO)

$(release_name).tar.gz:
	mkdir -p releases/$(release_name)
	cp -R files/www/ releases/$(release_name)
	cd releases && tar hzcfv $(release_name).tar.gz $(release_name)
