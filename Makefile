## ../rel/Makefile (this file, part of git://github.com/jjo/openvpn-rel.git)
## ../openvpn/     (git://github.com/jjo/openvpn-ipv6.git)
## ../tests/       (git://github.com/jjo/openvpn-tests.git)
V=2.1_rc20
V_JJO=ipv6-0.4.10
V_JJO_FULL=$(V)-$(V_JJO)

JJO_TAG_0=v$(V)
JJO_TAG_1=v$(V_JJO_FULL)
JJO_GIT_DIR=$(PWD)/../openvpn

TAR=openvpn-$(V).tar.gz
DIR=openvpn-$(V)
DIR_JJO=openvpn-$(V_JJO_FULL)

TARGET_PATCH=out/openvpn-$(V_JJO_FULL).patch.gz
TARGET_TAR=out/openvpn-$(V_JJO_FULL).tar.gz
TARGET_EXE=out/openvpn-$(V_JJO).exe.zip

TARGET=$(TARGET_PATCH) $(TARGET_TAR)

# Main target(s):
all: $(TAR) $(TARGET)
exe: $(TARGET_EXE)

wrk/$(DIR_JJO): $(JJO_GIT_DIR)
	test -d out || mkdir out
	test -d wrk || mkdir wrk
	tar -C wrk -zxvf $(TAR)
	(cd $(JJO_GIT_DIR) && git diff -r $(JJO_TAG_0) $(JJO_TAG_1)) | patch -d wrk/$(DIR) -p1
	cd wrk/$(DIR) && autoreconf -i -v
	cd wrk && mv $(DIR) $(DIR_JJO)
	tar -C wrk -zxvf $(TAR)

$(TARGET_PATCH): wrk/$(DIR_JJO)
	(cd wrk&& diff -x "*~" -uN $(DIR) $(DIR_JJO)) | gzip > $(TARGET_PATCH)
	echo "Patch over $(TAR) to move from $(V) to $(V_JJO_FULL)" > $(TARGET_PATCH).desc

$(TARGET_TAR): wrk/$(DIR_JJO)
	tar -C wrk -zcvf $(TARGET_TAR) $(DIR_JJO)

$(TAR):
	wget http://www.openvpn.net/release/$(TAR)

$(TARGET_EXE): $(JJO_GIT_DIR)/openvpn.exe
	cd wrk && cp -p $(JJO_GIT_DIR)/openvpn.exe . && md5sum openvpn.exe > openvpn.exe.md5sum && gpg -sat openvpn.exe.md5sum 
	zip -j $@ wrk/openvpn.exe wrk/openvpn.exe.md5sum.asc
	ls -l $@

clean:
	rm -rf wrk out $(TARGET)
