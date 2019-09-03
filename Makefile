vpath % ./var

DEVICE=/dev/null
IMAGE_NAME=mint

cache:
	mkdir var/cache

log:
	mkdir var/log

core_template:
	PACKER_CACHE_DIR=var/cache packer build -var-file=default.json core_template.json | tee var/log/core_template.log

install_packages:
	PACKER_CACHE_DIR=var/cache packer build -var='previous_step=core_template' -var-file=default.json install_packages.json | tee -a var/log/install_packages.log

$(IMAGE_NAME).img:
	tar -xf var/install_packages/*.ova --directory var/cache
	qemu-img convert -f vmdk -O raw var/cache/*.vmdk var/$(IMAGE_NAME).img

build: cache log core_template install_packages $(IMAGE_NAME).img

write: build
	dd bs=32M if=var/mint.img of=$(DEVICE)

clean:
	rm -f var/*.img
	rm -Rf var/cache
	rm -Rf var/log
	rm -Rf var/core_template
	rm -Rf var/install_packages

.PHONY: build write clean
