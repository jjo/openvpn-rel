V=2.1_rc19
V_JJO=2.1_rc19c-ipv6-0.4.4

JJO_TAG_0=v$(V)
JJO_TAG_1=v$(V_JJO)
JJO_GIT_DIR=$(PWD)/../openvpn

TAR=openvpn-$(V).tar.gz
DIR=openvpn-$(V)
DIR_JJO=openvpn-$(V_JJO)

TARGET_PATCH=out/openvpn-$(V)-$(V_JJO).patch.gz
TARGET_TAR=out/openvpn-$(V_JJO).tar.gz

TARGET=$(TARGET_PATCH) $(TARGET_TAR)
all: $(TARGET)

wrk/$(DIR_JJO): $(JJO_GIT_DIR)
	test -d out || mkdir out
	test -d wrk || mkdir wrk
	tar -C wrk -zxvf $(TAR)
	(cd $(JJO_GIT_DIR) && git diff -r $(JJO_TAG_0) $(JJO_TAG_1)) | patch -d wrk/$(DIR)
	cd wrk/$(DIR) && aclocal && automake && autoconf
	cd wrk && mv $(DIR) $(DIR_JJO)
	tar -C wrk -zxvf $(TAR)

$(TARGET_PATCH): wrk/$(DIR_JJO)
	(cd wrk&& diff -uN $(DIR) $(DIR_JJO)) | gzip > $(TARGET_PATCH)
	echo "Patch over $(TAR) to move from $(V) to $(V_JJO)" > $(TARGET_PATCH).desc

$(TARGET_TAR): wrk/$(DIR_JJO)
	tar -C wrk -zcvf $(TARGET_TAR) $(DIR_JJO)

$(TAR):
	wget http://www.openvpn.net/release/$(TAR)
clean:
	rm -rf wrk out $(TARGET)
