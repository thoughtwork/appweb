#
#   appweb-vxworks-static.mk -- Makefile to build Embedthis Appweb for vxworks
#

NAME                  := appweb
VERSION               := 5.0.0-rc0
PROFILE               ?= static
ARCH                  ?= $(shell echo $(WIND_HOST_TYPE) | sed 's/-.*//')
CPU                   ?= $(subst X86,PENTIUM,$(shell echo $(ARCH) | tr a-z A-Z))
OS                    ?= vxworks
CC                    ?= cc$(subst x86,pentium,$(ARCH))
LD                    ?= ld
CONFIG                ?= $(OS)-$(ARCH)-$(PROFILE)
LBIN                  ?= $(CONFIG)/bin
PATH                  := $(LBIN):$(PATH)

ME_COM_CGI            ?= 1
ME_COM_DIR            ?= 1
ME_COM_EJS            ?= 0
ME_COM_ESP            ?= 1
ME_COM_EST            ?= 1
ME_COM_HTTP           ?= 1
ME_COM_MATRIXSSL      ?= 0
ME_COM_MDB            ?= 1
ME_COM_NANOSSL        ?= 0
ME_COM_OPENSSL        ?= 0
ME_COM_PCRE           ?= 1
ME_COM_PHP            ?= 0
ME_COM_SQLITE         ?= 0
ME_COM_SSL            ?= 1
ME_COM_WINSDK         ?= 1
ME_COM_ZLIB           ?= 0

ifeq ($(ME_COM_EST),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_NANOSSL),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_OPENSSL),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_EJS),1)
    ME_COM_ZLIB := 1
endif
ifeq ($(ME_COM_ESP),1)
    ME_COM_MDB := 1
endif

ME_COM_CGI_PATH       ?= src/modules/cgiHandler.c
ME_COM_COMPILER_PATH  ?= cc$(subst x86,pentium,$(ARCH))
ME_COM_DIR_PATH       ?= src/dirHandler.c
ME_COM_LIB_PATH       ?= ar
ME_COM_LINK_PATH      ?= ld
ME_COM_MATRIXSSL_PATH ?= /usr/src/matrixssl
ME_COM_NANOSSL_PATH   ?= /usr/src/nanossl
ME_COM_OPENSSL_PATH   ?= /usr/src/openssl
ME_COM_PHP_PATH       ?= /usr/src/php
ME_COM_VXWORKS_PATH   ?= $(WIND_BASE)

export WIND_HOME      ?= $(WIND_BASE)/..
export PATH           := $(WIND_GNU_PATH)/$(WIND_HOST_TYPE)/bin:$(PATH)

CFLAGS                += -fno-builtin -fno-defer-pop -fvolatile -w
DFLAGS                += -DVXWORKS -DRW_MULTI_THREAD -D_GNU_TOOL -DCPU=PENTIUM $(patsubst %,-D%,$(filter ME_%,$(MAKEFLAGS))) -DME_COM_CGI=$(ME_COM_CGI) -DME_COM_DIR=$(ME_COM_DIR) -DME_COM_EJS=$(ME_COM_EJS) -DME_COM_ESP=$(ME_COM_ESP) -DME_COM_EST=$(ME_COM_EST) -DME_COM_HTTP=$(ME_COM_HTTP) -DME_COM_MATRIXSSL=$(ME_COM_MATRIXSSL) -DME_COM_MDB=$(ME_COM_MDB) -DME_COM_NANOSSL=$(ME_COM_NANOSSL) -DME_COM_OPENSSL=$(ME_COM_OPENSSL) -DME_COM_PCRE=$(ME_COM_PCRE) -DME_COM_PHP=$(ME_COM_PHP) -DME_COM_SQLITE=$(ME_COM_SQLITE) -DME_COM_SSL=$(ME_COM_SSL) -DME_COM_WINSDK=$(ME_COM_WINSDK) -DME_COM_ZLIB=$(ME_COM_ZLIB) 
IFLAGS                += "-I$(CONFIG)/inc -I$(WIND_BASE)/target/h -I$(WIND_BASE)/target/h/wrn/coreip"
LDFLAGS               += '-Wl,-r'
LIBPATHS              += -L$(CONFIG)/bin
LIBS                  += -lgcc

DEBUG                 ?= debug
CFLAGS-debug          ?= -g
DFLAGS-debug          ?= -DME_DEBUG
LDFLAGS-debug         ?= -g
DFLAGS-release        ?= 
CFLAGS-release        ?= -O2
LDFLAGS-release       ?= 
CFLAGS                += $(CFLAGS-$(DEBUG))
DFLAGS                += $(DFLAGS-$(DEBUG))
LDFLAGS               += $(LDFLAGS-$(DEBUG))

ME_ROOT_PREFIX        ?= deploy
ME_BASE_PREFIX        ?= $(ME_ROOT_PREFIX)
ME_DATA_PREFIX        ?= $(ME_VAPP_PREFIX)
ME_STATE_PREFIX       ?= $(ME_VAPP_PREFIX)
ME_BIN_PREFIX         ?= $(ME_VAPP_PREFIX)
ME_INC_PREFIX         ?= $(ME_VAPP_PREFIX)/inc
ME_LIB_PREFIX         ?= $(ME_VAPP_PREFIX)
ME_MAN_PREFIX         ?= $(ME_VAPP_PREFIX)
ME_SBIN_PREFIX        ?= $(ME_VAPP_PREFIX)
ME_ETC_PREFIX         ?= $(ME_VAPP_PREFIX)
ME_WEB_PREFIX         ?= $(ME_VAPP_PREFIX)/web
ME_LOG_PREFIX         ?= $(ME_VAPP_PREFIX)
ME_SPOOL_PREFIX       ?= $(ME_VAPP_PREFIX)
ME_CACHE_PREFIX       ?= $(ME_VAPP_PREFIX)
ME_APP_PREFIX         ?= $(ME_BASE_PREFIX)
ME_VAPP_PREFIX        ?= $(ME_APP_PREFIX)
ME_SRC_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/src/$(NAME)-$(VERSION)


TARGETS               += $(CONFIG)/bin/appweb.out
TARGETS               += $(CONFIG)/bin/authpass.out
ifeq ($(ME_COM_CGI),1)
    TARGETS           += $(CONFIG)/bin/cgiProgram.out
endif
ifeq ($(ME_COM_EJS),1)
    TARGETS           += $(CONFIG)/bin/ejs.mod
endif
ifeq ($(ME_COM_EJS),1)
    TARGETS           += $(CONFIG)/bin/ejs.out
endif
ifeq ($(ME_COM_ESP),1)
    TARGETS           += $(CONFIG)/esp
endif
ifeq ($(ME_COM_ESP),1)
    TARGETS           += $(CONFIG)/bin/esp.conf
endif
ifeq ($(ME_COM_ESP),1)
    TARGETS           += $(CONFIG)/bin/esp.out
endif
TARGETS               += $(CONFIG)/bin/ca.crt
ifeq ($(ME_COM_HTTP),1)
    TARGETS           += $(CONFIG)/bin/http.out
endif
ifeq ($(ME_COM_SQLITE),1)
    TARGETS           += $(CONFIG)/bin/libsql.a
endif
TARGETS               += $(CONFIG)/bin/appman.out
TARGETS               += src/server/cache
ifeq ($(ME_COM_SQLITE),1)
    TARGETS           += $(CONFIG)/bin/sqlite.out
endif
ifeq ($(ME_COM_CGI),1)
    TARGETS           += test/web/auth/basic/basic.cgi
endif
ifeq ($(ME_COM_CGI),1)
    TARGETS           += test/web/caching/cache.cgi
endif
ifeq ($(ME_COM_CGI),1)
    TARGETS           += test/cgi-bin/cgiProgram.out
endif
ifeq ($(ME_COM_CGI),1)
    TARGETS           += test/cgi-bin/testScript
endif

unexport CDPATH

ifndef SHOW
.SILENT:
endif

all build compile: prep $(TARGETS)

.PHONY: prep

prep:
	@echo "      [Info] Use "make SHOW=1" to trace executed commands."
	@if [ "$(CONFIG)" = "" ] ; then echo WARNING: CONFIG not set ; exit 255 ; fi
	@if [ "$(ME_APP_PREFIX)" = "" ] ; then echo WARNING: ME_APP_PREFIX not set ; exit 255 ; fi
	@if [ "$(WIND_BASE)" = "" ] ; then echo WARNING: WIND_BASE not set. Run wrenv.sh. ; exit 255 ; fi
	@if [ "$(WIND_HOST_TYPE)" = "" ] ; then echo WARNING: WIND_HOST_TYPE not set. Run wrenv.sh. ; exit 255 ; fi
	@if [ "$(WIND_GNU_PATH)" = "" ] ; then echo WARNING: WIND_GNU_PATH not set. Run wrenv.sh. ; exit 255 ; fi
	@[ ! -x $(CONFIG)/bin ] && mkdir -p $(CONFIG)/bin; true
	@[ ! -x $(CONFIG)/inc ] && mkdir -p $(CONFIG)/inc; true
	@[ ! -x $(CONFIG)/obj ] && mkdir -p $(CONFIG)/obj; true
	@[ ! -f $(CONFIG)/inc/osdep.h ] && cp src/paks/osdep/osdep.h $(CONFIG)/inc/osdep.h ; true
	@if ! diff $(CONFIG)/inc/osdep.h src/paks/osdep/osdep.h >/dev/null ; then\
		cp src/paks/osdep/osdep.h $(CONFIG)/inc/osdep.h  ; \
	fi; true
	@[ ! -f $(CONFIG)/inc/me.h ] && cp projects/appweb-vxworks-static-me.h $(CONFIG)/inc/me.h ; true
	@if ! diff $(CONFIG)/inc/me.h projects/appweb-vxworks-static-me.h >/dev/null ; then\
		cp projects/appweb-vxworks-static-me.h $(CONFIG)/inc/me.h  ; \
	fi; true
	@if [ -f "$(CONFIG)/.makeflags" ] ; then \
		if [ "$(MAKEFLAGS)" != " ` cat $(CONFIG)/.makeflags`" ] ; then \
			echo "   [Warning] Make flags have changed since the last build: "`cat $(CONFIG)/.makeflags`"" ; \
		fi ; \
	fi
	@echo $(MAKEFLAGS) >$(CONFIG)/.makeflags

clean:
	rm -f "$(CONFIG)/obj/appweb.o"
	rm -f "$(CONFIG)/obj/authpass.o"
	rm -f "$(CONFIG)/obj/cgiHandler.o"
	rm -f "$(CONFIG)/obj/cgiProgram.o"
	rm -f "$(CONFIG)/obj/config.o"
	rm -f "$(CONFIG)/obj/convenience.o"
	rm -f "$(CONFIG)/obj/dirHandler.o"
	rm -f "$(CONFIG)/obj/ejs.o"
	rm -f "$(CONFIG)/obj/ejsHandler.o"
	rm -f "$(CONFIG)/obj/ejsLib.o"
	rm -f "$(CONFIG)/obj/ejsc.o"
	rm -f "$(CONFIG)/obj/esp.o"
	rm -f "$(CONFIG)/obj/espLib.o"
	rm -f "$(CONFIG)/obj/estLib.o"
	rm -f "$(CONFIG)/obj/fileHandler.o"
	rm -f "$(CONFIG)/obj/http.o"
	rm -f "$(CONFIG)/obj/httpLib.o"
	rm -f "$(CONFIG)/obj/log.o"
	rm -f "$(CONFIG)/obj/makerom.o"
	rm -f "$(CONFIG)/obj/manager.o"
	rm -f "$(CONFIG)/obj/mprLib.o"
	rm -f "$(CONFIG)/obj/mprSsl.o"
	rm -f "$(CONFIG)/obj/pcre.o"
	rm -f "$(CONFIG)/obj/phpHandler.o"
	rm -f "$(CONFIG)/obj/server.o"
	rm -f "$(CONFIG)/obj/slink.o"
	rm -f "$(CONFIG)/obj/sqlite.o"
	rm -f "$(CONFIG)/obj/sqlite3.o"
	rm -f "$(CONFIG)/obj/sslModule.o"
	rm -f "$(CONFIG)/obj/testAppweb.o"
	rm -f "$(CONFIG)/obj/testHttp.o"
	rm -f "$(CONFIG)/obj/zlib.o"
	rm -f "$(CONFIG)/bin/appweb.out"
	rm -f "$(CONFIG)/bin/authpass.out"
	rm -f "$(CONFIG)/bin/cgiProgram.out"
	rm -f "$(CONFIG)/bin/ejsc.out"
	rm -f "$(CONFIG)/bin/ejs.out"
	rm -f "$(CONFIG)/bin/esp.conf"
	rm -f "$(CONFIG)/bin/esp.out"
	rm -f "$(CONFIG)/bin/ca.crt"
	rm -f "$(CONFIG)/bin/http.out"
	rm -f "$(CONFIG)/bin/libappweb.a"
	rm -f "$(CONFIG)/bin/libejs.a"
	rm -f "$(CONFIG)/bin/libest.a"
	rm -f "$(CONFIG)/bin/libhttp.a"
	rm -f "$(CONFIG)/bin/libmod_cgi.a"
	rm -f "$(CONFIG)/bin/libmod_ejs.a"
	rm -f "$(CONFIG)/bin/libmod_esp.a"
	rm -f "$(CONFIG)/bin/libmod_php.a"
	rm -f "$(CONFIG)/bin/libmod_ssl.a"
	rm -f "$(CONFIG)/bin/libmpr.a"
	rm -f "$(CONFIG)/bin/libmprssl.a"
	rm -f "$(CONFIG)/bin/libpcre.a"
	rm -f "$(CONFIG)/bin/libslink.a"
	rm -f "$(CONFIG)/bin/libsql.a"
	rm -f "$(CONFIG)/bin/libzlib.a"
	rm -f "$(CONFIG)/bin/makerom.out"
	rm -f "$(CONFIG)/bin/appman.out"
	rm -f "$(CONFIG)/bin/sqlite.out"
	rm -f "$(CONFIG)/bin/testAppweb.out"

clobber: clean
	rm -fr ./$(CONFIG)


#
#   mpr.h
#
$(CONFIG)/inc/mpr.h: $(DEPS_1)
	@echo '      [Copy] $(CONFIG)/inc/mpr.h'
	mkdir -p "$(CONFIG)/inc"
	cp src/paks/mpr/mpr.h $(CONFIG)/inc/mpr.h

#
#   me.h
#
$(CONFIG)/inc/me.h: $(DEPS_2)
	@echo '      [Copy] $(CONFIG)/inc/me.h'

#
#   osdep.h
#
$(CONFIG)/inc/osdep.h: $(DEPS_3)
	@echo '      [Copy] $(CONFIG)/inc/osdep.h'
	mkdir -p "$(CONFIG)/inc"
	cp src/paks/osdep/osdep.h $(CONFIG)/inc/osdep.h

#
#   mprLib.o
#
DEPS_4 += $(CONFIG)/inc/me.h
DEPS_4 += $(CONFIG)/inc/mpr.h
DEPS_4 += $(CONFIG)/inc/osdep.h

$(CONFIG)/obj/mprLib.o: \
    src/paks/mpr/mprLib.c $(DEPS_4)
	@echo '   [Compile] $(CONFIG)/obj/mprLib.o'
	$(CC) -c -o $(CONFIG)/obj/mprLib.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/mpr/mprLib.c

#
#   libmpr
#
DEPS_5 += $(CONFIG)/inc/mpr.h
DEPS_5 += $(CONFIG)/inc/me.h
DEPS_5 += $(CONFIG)/inc/osdep.h
DEPS_5 += $(CONFIG)/obj/mprLib.o

$(CONFIG)/bin/libmpr.a: $(DEPS_5)
	@echo '      [Link] $(CONFIG)/bin/libmpr.a'
	ar -cr $(CONFIG)/bin/libmpr.a "$(CONFIG)/obj/mprLib.o"

#
#   pcre.h
#
$(CONFIG)/inc/pcre.h: $(DEPS_6)
	@echo '      [Copy] $(CONFIG)/inc/pcre.h'
	mkdir -p "$(CONFIG)/inc"
	cp src/paks/pcre/pcre.h $(CONFIG)/inc/pcre.h

#
#   pcre.o
#
DEPS_7 += $(CONFIG)/inc/me.h
DEPS_7 += $(CONFIG)/inc/pcre.h

$(CONFIG)/obj/pcre.o: \
    src/paks/pcre/pcre.c $(DEPS_7)
	@echo '   [Compile] $(CONFIG)/obj/pcre.o'
	$(CC) -c -o $(CONFIG)/obj/pcre.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/pcre/pcre.c

ifeq ($(ME_COM_PCRE),1)
#
#   libpcre
#
DEPS_8 += $(CONFIG)/inc/pcre.h
DEPS_8 += $(CONFIG)/inc/me.h
DEPS_8 += $(CONFIG)/obj/pcre.o

$(CONFIG)/bin/libpcre.a: $(DEPS_8)
	@echo '      [Link] $(CONFIG)/bin/libpcre.a'
	ar -cr $(CONFIG)/bin/libpcre.a "$(CONFIG)/obj/pcre.o"
endif

#
#   http.h
#
$(CONFIG)/inc/http.h: $(DEPS_9)
	@echo '      [Copy] $(CONFIG)/inc/http.h'
	mkdir -p "$(CONFIG)/inc"
	cp src/paks/http/http.h $(CONFIG)/inc/http.h

#
#   httpLib.o
#
DEPS_10 += $(CONFIG)/inc/me.h
DEPS_10 += $(CONFIG)/inc/http.h
DEPS_10 += $(CONFIG)/inc/mpr.h

$(CONFIG)/obj/httpLib.o: \
    src/paks/http/httpLib.c $(DEPS_10)
	@echo '   [Compile] $(CONFIG)/obj/httpLib.o'
	$(CC) -c -o $(CONFIG)/obj/httpLib.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/http/httpLib.c

ifeq ($(ME_COM_HTTP),1)
#
#   libhttp
#
DEPS_11 += $(CONFIG)/inc/mpr.h
DEPS_11 += $(CONFIG)/inc/me.h
DEPS_11 += $(CONFIG)/inc/osdep.h
DEPS_11 += $(CONFIG)/obj/mprLib.o
DEPS_11 += $(CONFIG)/bin/libmpr.a
DEPS_11 += $(CONFIG)/inc/pcre.h
DEPS_11 += $(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_11 += $(CONFIG)/bin/libpcre.a
endif
DEPS_11 += $(CONFIG)/inc/http.h
DEPS_11 += $(CONFIG)/obj/httpLib.o

$(CONFIG)/bin/libhttp.a: $(DEPS_11)
	@echo '      [Link] $(CONFIG)/bin/libhttp.a'
	ar -cr $(CONFIG)/bin/libhttp.a "$(CONFIG)/obj/httpLib.o"
endif

#
#   appweb.h
#
$(CONFIG)/inc/appweb.h: $(DEPS_12)
	@echo '      [Copy] $(CONFIG)/inc/appweb.h'
	mkdir -p "$(CONFIG)/inc"
	cp src/appweb.h $(CONFIG)/inc/appweb.h

#
#   customize.h
#
$(CONFIG)/inc/customize.h: $(DEPS_13)
	@echo '      [Copy] $(CONFIG)/inc/customize.h'
	mkdir -p "$(CONFIG)/inc"
	cp src/customize.h $(CONFIG)/inc/customize.h

#
#   config.o
#
DEPS_14 += $(CONFIG)/inc/me.h
DEPS_14 += $(CONFIG)/inc/appweb.h
DEPS_14 += $(CONFIG)/inc/pcre.h
DEPS_14 += $(CONFIG)/inc/mpr.h
DEPS_14 += $(CONFIG)/inc/http.h
DEPS_14 += $(CONFIG)/inc/customize.h

$(CONFIG)/obj/config.o: \
    src/config.c $(DEPS_14)
	@echo '   [Compile] $(CONFIG)/obj/config.o'
	$(CC) -c -o $(CONFIG)/obj/config.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/config.c

#
#   convenience.o
#
DEPS_15 += $(CONFIG)/inc/me.h
DEPS_15 += $(CONFIG)/inc/appweb.h

$(CONFIG)/obj/convenience.o: \
    src/convenience.c $(DEPS_15)
	@echo '   [Compile] $(CONFIG)/obj/convenience.o'
	$(CC) -c -o $(CONFIG)/obj/convenience.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/convenience.c

#
#   dirHandler.o
#
DEPS_16 += $(CONFIG)/inc/me.h
DEPS_16 += $(CONFIG)/inc/appweb.h

$(CONFIG)/obj/dirHandler.o: \
    src/dirHandler.c $(DEPS_16)
	@echo '   [Compile] $(CONFIG)/obj/dirHandler.o'
	$(CC) -c -o $(CONFIG)/obj/dirHandler.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/dirHandler.c

#
#   fileHandler.o
#
DEPS_17 += $(CONFIG)/inc/me.h
DEPS_17 += $(CONFIG)/inc/appweb.h

$(CONFIG)/obj/fileHandler.o: \
    src/fileHandler.c $(DEPS_17)
	@echo '   [Compile] $(CONFIG)/obj/fileHandler.o'
	$(CC) -c -o $(CONFIG)/obj/fileHandler.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/fileHandler.c

#
#   log.o
#
DEPS_18 += $(CONFIG)/inc/me.h
DEPS_18 += $(CONFIG)/inc/appweb.h

$(CONFIG)/obj/log.o: \
    src/log.c $(DEPS_18)
	@echo '   [Compile] $(CONFIG)/obj/log.o'
	$(CC) -c -o $(CONFIG)/obj/log.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/log.c

#
#   server.o
#
DEPS_19 += $(CONFIG)/inc/me.h
DEPS_19 += $(CONFIG)/inc/appweb.h

$(CONFIG)/obj/server.o: \
    src/server.c $(DEPS_19)
	@echo '   [Compile] $(CONFIG)/obj/server.o'
	$(CC) -c -o $(CONFIG)/obj/server.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/server.c

#
#   libappweb
#
DEPS_20 += $(CONFIG)/inc/mpr.h
DEPS_20 += $(CONFIG)/inc/me.h
DEPS_20 += $(CONFIG)/inc/osdep.h
DEPS_20 += $(CONFIG)/obj/mprLib.o
DEPS_20 += $(CONFIG)/bin/libmpr.a
DEPS_20 += $(CONFIG)/inc/pcre.h
DEPS_20 += $(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_20 += $(CONFIG)/bin/libpcre.a
endif
DEPS_20 += $(CONFIG)/inc/http.h
DEPS_20 += $(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_20 += $(CONFIG)/bin/libhttp.a
endif
DEPS_20 += $(CONFIG)/inc/appweb.h
DEPS_20 += $(CONFIG)/inc/customize.h
DEPS_20 += $(CONFIG)/obj/config.o
DEPS_20 += $(CONFIG)/obj/convenience.o
DEPS_20 += $(CONFIG)/obj/dirHandler.o
DEPS_20 += $(CONFIG)/obj/fileHandler.o
DEPS_20 += $(CONFIG)/obj/log.o
DEPS_20 += $(CONFIG)/obj/server.o

$(CONFIG)/bin/libappweb.a: $(DEPS_20)
	@echo '      [Link] $(CONFIG)/bin/libappweb.a'
	ar -cr $(CONFIG)/bin/libappweb.a "$(CONFIG)/obj/config.o" "$(CONFIG)/obj/convenience.o" "$(CONFIG)/obj/dirHandler.o" "$(CONFIG)/obj/fileHandler.o" "$(CONFIG)/obj/log.o" "$(CONFIG)/obj/server.o"

#
#   slink.c
#
src/slink.c: $(DEPS_21)
	( \
	cd src; \
	[ ! -f slink.c ] && cp slink.empty slink.c ; true ; \
	)

#
#   esp.h
#
$(CONFIG)/inc/esp.h: $(DEPS_22)
	@echo '      [Copy] $(CONFIG)/inc/esp.h'
	mkdir -p "$(CONFIG)/inc"
	cp src/paks/esp/esp.h $(CONFIG)/inc/esp.h

#
#   espLib.o
#
DEPS_23 += $(CONFIG)/inc/me.h
DEPS_23 += $(CONFIG)/inc/esp.h
DEPS_23 += $(CONFIG)/inc/pcre.h
DEPS_23 += $(CONFIG)/inc/http.h
DEPS_23 += $(CONFIG)/inc/osdep.h
DEPS_23 += $(CONFIG)/inc/appweb.h

$(CONFIG)/obj/espLib.o: \
    src/paks/esp/espLib.c $(DEPS_23)
	@echo '   [Compile] $(CONFIG)/obj/espLib.o'
	$(CC) -c -o $(CONFIG)/obj/espLib.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/esp/espLib.c

ifeq ($(ME_COM_ESP),1)
#
#   libmod_esp
#
DEPS_24 += $(CONFIG)/inc/mpr.h
DEPS_24 += $(CONFIG)/inc/me.h
DEPS_24 += $(CONFIG)/inc/osdep.h
DEPS_24 += $(CONFIG)/obj/mprLib.o
DEPS_24 += $(CONFIG)/bin/libmpr.a
DEPS_24 += $(CONFIG)/inc/pcre.h
DEPS_24 += $(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_24 += $(CONFIG)/bin/libpcre.a
endif
DEPS_24 += $(CONFIG)/inc/http.h
DEPS_24 += $(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_24 += $(CONFIG)/bin/libhttp.a
endif
DEPS_24 += $(CONFIG)/inc/appweb.h
DEPS_24 += $(CONFIG)/inc/customize.h
DEPS_24 += $(CONFIG)/obj/config.o
DEPS_24 += $(CONFIG)/obj/convenience.o
DEPS_24 += $(CONFIG)/obj/dirHandler.o
DEPS_24 += $(CONFIG)/obj/fileHandler.o
DEPS_24 += $(CONFIG)/obj/log.o
DEPS_24 += $(CONFIG)/obj/server.o
DEPS_24 += $(CONFIG)/bin/libappweb.a
DEPS_24 += $(CONFIG)/inc/esp.h
DEPS_24 += $(CONFIG)/obj/espLib.o

$(CONFIG)/bin/libmod_esp.a: $(DEPS_24)
	@echo '      [Link] $(CONFIG)/bin/libmod_esp.a'
	ar -cr $(CONFIG)/bin/libmod_esp.a "$(CONFIG)/obj/espLib.o"
endif

#
#   slink.o
#
DEPS_25 += $(CONFIG)/inc/me.h
DEPS_25 += $(CONFIG)/inc/mpr.h
DEPS_25 += $(CONFIG)/inc/esp.h

$(CONFIG)/obj/slink.o: \
    src/slink.c $(DEPS_25)
	@echo '   [Compile] $(CONFIG)/obj/slink.o'
	$(CC) -c -o $(CONFIG)/obj/slink.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/slink.c

#
#   libslink
#
DEPS_26 += src/slink.c
DEPS_26 += $(CONFIG)/inc/mpr.h
DEPS_26 += $(CONFIG)/inc/me.h
DEPS_26 += $(CONFIG)/inc/osdep.h
DEPS_26 += $(CONFIG)/obj/mprLib.o
DEPS_26 += $(CONFIG)/bin/libmpr.a
DEPS_26 += $(CONFIG)/inc/pcre.h
DEPS_26 += $(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_26 += $(CONFIG)/bin/libpcre.a
endif
DEPS_26 += $(CONFIG)/inc/http.h
DEPS_26 += $(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_26 += $(CONFIG)/bin/libhttp.a
endif
DEPS_26 += $(CONFIG)/inc/appweb.h
DEPS_26 += $(CONFIG)/inc/customize.h
DEPS_26 += $(CONFIG)/obj/config.o
DEPS_26 += $(CONFIG)/obj/convenience.o
DEPS_26 += $(CONFIG)/obj/dirHandler.o
DEPS_26 += $(CONFIG)/obj/fileHandler.o
DEPS_26 += $(CONFIG)/obj/log.o
DEPS_26 += $(CONFIG)/obj/server.o
DEPS_26 += $(CONFIG)/bin/libappweb.a
DEPS_26 += $(CONFIG)/inc/esp.h
DEPS_26 += $(CONFIG)/obj/espLib.o
ifeq ($(ME_COM_ESP),1)
    DEPS_26 += $(CONFIG)/bin/libmod_esp.a
endif
DEPS_26 += $(CONFIG)/obj/slink.o

$(CONFIG)/bin/libslink.a: $(DEPS_26)
	@echo '      [Link] $(CONFIG)/bin/libslink.a'
	ar -cr $(CONFIG)/bin/libslink.a "$(CONFIG)/obj/slink.o"

#
#   est.h
#
$(CONFIG)/inc/est.h: $(DEPS_27)
	@echo '      [Copy] $(CONFIG)/inc/est.h'
	mkdir -p "$(CONFIG)/inc"
	cp src/paks/est/est.h $(CONFIG)/inc/est.h

#
#   estLib.o
#
DEPS_28 += $(CONFIG)/inc/me.h
DEPS_28 += $(CONFIG)/inc/est.h
DEPS_28 += $(CONFIG)/inc/osdep.h

$(CONFIG)/obj/estLib.o: \
    src/paks/est/estLib.c $(DEPS_28)
	@echo '   [Compile] $(CONFIG)/obj/estLib.o'
	$(CC) -c -o $(CONFIG)/obj/estLib.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/est/estLib.c

ifeq ($(ME_COM_EST),1)
#
#   libest
#
DEPS_29 += $(CONFIG)/inc/est.h
DEPS_29 += $(CONFIG)/inc/me.h
DEPS_29 += $(CONFIG)/inc/osdep.h
DEPS_29 += $(CONFIG)/obj/estLib.o

$(CONFIG)/bin/libest.a: $(DEPS_29)
	@echo '      [Link] $(CONFIG)/bin/libest.a'
	ar -cr $(CONFIG)/bin/libest.a "$(CONFIG)/obj/estLib.o"
endif

#
#   mprSsl.o
#
DEPS_30 += $(CONFIG)/inc/me.h
DEPS_30 += $(CONFIG)/inc/mpr.h
DEPS_30 += $(CONFIG)/inc/est.h

$(CONFIG)/obj/mprSsl.o: \
    src/paks/mpr/mprSsl.c $(DEPS_30)
	@echo '   [Compile] $(CONFIG)/obj/mprSsl.o'
	$(CC) -c -o $(CONFIG)/obj/mprSsl.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/paks/mpr/mprSsl.c

#
#   libmprssl
#
DEPS_31 += $(CONFIG)/inc/mpr.h
DEPS_31 += $(CONFIG)/inc/me.h
DEPS_31 += $(CONFIG)/inc/osdep.h
DEPS_31 += $(CONFIG)/obj/mprLib.o
DEPS_31 += $(CONFIG)/bin/libmpr.a
DEPS_31 += $(CONFIG)/inc/est.h
DEPS_31 += $(CONFIG)/obj/estLib.o
ifeq ($(ME_COM_EST),1)
    DEPS_31 += $(CONFIG)/bin/libest.a
endif
DEPS_31 += $(CONFIG)/obj/mprSsl.o

$(CONFIG)/bin/libmprssl.a: $(DEPS_31)
	@echo '      [Link] $(CONFIG)/bin/libmprssl.a'
	ar -cr $(CONFIG)/bin/libmprssl.a "$(CONFIG)/obj/mprSsl.o"

#
#   sslModule.o
#
DEPS_32 += $(CONFIG)/inc/me.h
DEPS_32 += $(CONFIG)/inc/appweb.h

$(CONFIG)/obj/sslModule.o: \
    src/modules/sslModule.c $(DEPS_32)
	@echo '   [Compile] $(CONFIG)/obj/sslModule.o'
	$(CC) -c -o $(CONFIG)/obj/sslModule.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/modules/sslModule.c

ifeq ($(ME_COM_SSL),1)
#
#   libmod_ssl
#
DEPS_33 += $(CONFIG)/inc/mpr.h
DEPS_33 += $(CONFIG)/inc/me.h
DEPS_33 += $(CONFIG)/inc/osdep.h
DEPS_33 += $(CONFIG)/obj/mprLib.o
DEPS_33 += $(CONFIG)/bin/libmpr.a
DEPS_33 += $(CONFIG)/inc/pcre.h
DEPS_33 += $(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_33 += $(CONFIG)/bin/libpcre.a
endif
DEPS_33 += $(CONFIG)/inc/http.h
DEPS_33 += $(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_33 += $(CONFIG)/bin/libhttp.a
endif
DEPS_33 += $(CONFIG)/inc/appweb.h
DEPS_33 += $(CONFIG)/inc/customize.h
DEPS_33 += $(CONFIG)/obj/config.o
DEPS_33 += $(CONFIG)/obj/convenience.o
DEPS_33 += $(CONFIG)/obj/dirHandler.o
DEPS_33 += $(CONFIG)/obj/fileHandler.o
DEPS_33 += $(CONFIG)/obj/log.o
DEPS_33 += $(CONFIG)/obj/server.o
DEPS_33 += $(CONFIG)/bin/libappweb.a
DEPS_33 += $(CONFIG)/inc/est.h
DEPS_33 += $(CONFIG)/obj/estLib.o
ifeq ($(ME_COM_EST),1)
    DEPS_33 += $(CONFIG)/bin/libest.a
endif
DEPS_33 += $(CONFIG)/obj/mprSsl.o
DEPS_33 += $(CONFIG)/bin/libmprssl.a
DEPS_33 += $(CONFIG)/obj/sslModule.o

$(CONFIG)/bin/libmod_ssl.a: $(DEPS_33)
	@echo '      [Link] $(CONFIG)/bin/libmod_ssl.a'
	ar -cr $(CONFIG)/bin/libmod_ssl.a "$(CONFIG)/obj/sslModule.o"
endif

#
#   zlib.h
#
$(CONFIG)/inc/zlib.h: $(DEPS_34)
	@echo '      [Copy] $(CONFIG)/inc/zlib.h'
	mkdir -p "$(CONFIG)/inc"
	cp src/paks/zlib/zlib.h $(CONFIG)/inc/zlib.h

#
#   zlib.o
#
DEPS_35 += $(CONFIG)/inc/me.h
DEPS_35 += $(CONFIG)/inc/zlib.h

$(CONFIG)/obj/zlib.o: \
    src/paks/zlib/zlib.c $(DEPS_35)
	@echo '   [Compile] $(CONFIG)/obj/zlib.o'
	$(CC) -c -o $(CONFIG)/obj/zlib.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/zlib/zlib.c

ifeq ($(ME_COM_ZLIB),1)
#
#   libzlib
#
DEPS_36 += $(CONFIG)/inc/zlib.h
DEPS_36 += $(CONFIG)/inc/me.h
DEPS_36 += $(CONFIG)/obj/zlib.o

$(CONFIG)/bin/libzlib.a: $(DEPS_36)
	@echo '      [Link] $(CONFIG)/bin/libzlib.a'
	ar -cr $(CONFIG)/bin/libzlib.a "$(CONFIG)/obj/zlib.o"
endif

#
#   ejs.h
#
$(CONFIG)/inc/ejs.h: $(DEPS_37)
	@echo '      [Copy] $(CONFIG)/inc/ejs.h'
	mkdir -p "$(CONFIG)/inc"
	cp src/paks/ejs/ejs.h $(CONFIG)/inc/ejs.h

#
#   ejs.slots.h
#
$(CONFIG)/inc/ejs.slots.h: $(DEPS_38)
	@echo '      [Copy] $(CONFIG)/inc/ejs.slots.h'
	mkdir -p "$(CONFIG)/inc"
	cp src/paks/ejs/ejs.slots.h $(CONFIG)/inc/ejs.slots.h

#
#   ejsByteGoto.h
#
$(CONFIG)/inc/ejsByteGoto.h: $(DEPS_39)
	@echo '      [Copy] $(CONFIG)/inc/ejsByteGoto.h'
	mkdir -p "$(CONFIG)/inc"
	cp src/paks/ejs/ejsByteGoto.h $(CONFIG)/inc/ejsByteGoto.h

#
#   ejsLib.o
#
DEPS_40 += $(CONFIG)/inc/me.h
DEPS_40 += $(CONFIG)/inc/ejs.h
DEPS_40 += $(CONFIG)/inc/mpr.h
DEPS_40 += $(CONFIG)/inc/pcre.h
DEPS_40 += $(CONFIG)/inc/osdep.h
DEPS_40 += $(CONFIG)/inc/http.h
DEPS_40 += $(CONFIG)/inc/ejs.slots.h
DEPS_40 += $(CONFIG)/inc/zlib.h

$(CONFIG)/obj/ejsLib.o: \
    src/paks/ejs/ejsLib.c $(DEPS_40)
	@echo '   [Compile] $(CONFIG)/obj/ejsLib.o'
	$(CC) -c -o $(CONFIG)/obj/ejsLib.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/ejs/ejsLib.c

ifeq ($(ME_COM_EJS),1)
#
#   libejs
#
DEPS_41 += $(CONFIG)/inc/mpr.h
DEPS_41 += $(CONFIG)/inc/me.h
DEPS_41 += $(CONFIG)/inc/osdep.h
DEPS_41 += $(CONFIG)/obj/mprLib.o
DEPS_41 += $(CONFIG)/bin/libmpr.a
DEPS_41 += $(CONFIG)/inc/pcre.h
DEPS_41 += $(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_41 += $(CONFIG)/bin/libpcre.a
endif
DEPS_41 += $(CONFIG)/inc/http.h
DEPS_41 += $(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_41 += $(CONFIG)/bin/libhttp.a
endif
DEPS_41 += $(CONFIG)/inc/zlib.h
DEPS_41 += $(CONFIG)/obj/zlib.o
ifeq ($(ME_COM_ZLIB),1)
    DEPS_41 += $(CONFIG)/bin/libzlib.a
endif
DEPS_41 += $(CONFIG)/inc/ejs.h
DEPS_41 += $(CONFIG)/inc/ejs.slots.h
DEPS_41 += $(CONFIG)/inc/ejsByteGoto.h
DEPS_41 += $(CONFIG)/obj/ejsLib.o

$(CONFIG)/bin/libejs.a: $(DEPS_41)
	@echo '      [Link] $(CONFIG)/bin/libejs.a'
	ar -cr $(CONFIG)/bin/libejs.a "$(CONFIG)/obj/ejsLib.o"
endif

#
#   ejsHandler.o
#
DEPS_42 += $(CONFIG)/inc/me.h
DEPS_42 += $(CONFIG)/inc/appweb.h

$(CONFIG)/obj/ejsHandler.o: \
    src/modules/ejsHandler.c $(DEPS_42)
	@echo '   [Compile] $(CONFIG)/obj/ejsHandler.o'
	$(CC) -c -o $(CONFIG)/obj/ejsHandler.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/modules/ejsHandler.c

ifeq ($(ME_COM_EJS),1)
#
#   libmod_ejs
#
DEPS_43 += $(CONFIG)/inc/mpr.h
DEPS_43 += $(CONFIG)/inc/me.h
DEPS_43 += $(CONFIG)/inc/osdep.h
DEPS_43 += $(CONFIG)/obj/mprLib.o
DEPS_43 += $(CONFIG)/bin/libmpr.a
DEPS_43 += $(CONFIG)/inc/pcre.h
DEPS_43 += $(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_43 += $(CONFIG)/bin/libpcre.a
endif
DEPS_43 += $(CONFIG)/inc/http.h
DEPS_43 += $(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_43 += $(CONFIG)/bin/libhttp.a
endif
DEPS_43 += $(CONFIG)/inc/appweb.h
DEPS_43 += $(CONFIG)/inc/customize.h
DEPS_43 += $(CONFIG)/obj/config.o
DEPS_43 += $(CONFIG)/obj/convenience.o
DEPS_43 += $(CONFIG)/obj/dirHandler.o
DEPS_43 += $(CONFIG)/obj/fileHandler.o
DEPS_43 += $(CONFIG)/obj/log.o
DEPS_43 += $(CONFIG)/obj/server.o
DEPS_43 += $(CONFIG)/bin/libappweb.a
DEPS_43 += $(CONFIG)/inc/zlib.h
DEPS_43 += $(CONFIG)/obj/zlib.o
ifeq ($(ME_COM_ZLIB),1)
    DEPS_43 += $(CONFIG)/bin/libzlib.a
endif
DEPS_43 += $(CONFIG)/inc/ejs.h
DEPS_43 += $(CONFIG)/inc/ejs.slots.h
DEPS_43 += $(CONFIG)/inc/ejsByteGoto.h
DEPS_43 += $(CONFIG)/obj/ejsLib.o
DEPS_43 += $(CONFIG)/bin/libejs.a
DEPS_43 += $(CONFIG)/obj/ejsHandler.o

$(CONFIG)/bin/libmod_ejs.a: $(DEPS_43)
	@echo '      [Link] $(CONFIG)/bin/libmod_ejs.a'
	ar -cr $(CONFIG)/bin/libmod_ejs.a "$(CONFIG)/obj/ejsHandler.o"
endif

#
#   phpHandler.o
#
DEPS_44 += $(CONFIG)/inc/me.h
DEPS_44 += $(CONFIG)/inc/appweb.h

$(CONFIG)/obj/phpHandler.o: \
    src/modules/phpHandler.c $(DEPS_44)
	@echo '   [Compile] $(CONFIG)/obj/phpHandler.o'
	$(CC) -c -o $(CONFIG)/obj/phpHandler.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" "-I$(BIT_PACK_PHP_PATH)" "-I$(BIT_PACK_PHP_PATH)/main" "-I$(BIT_PACK_PHP_PATH)/Zend" "-I$(BIT_PACK_PHP_PATH)/TSRM" src/modules/phpHandler.c

ifeq ($(ME_COM_PHP),1)
#
#   libmod_php
#
DEPS_45 += $(CONFIG)/inc/mpr.h
DEPS_45 += $(CONFIG)/inc/me.h
DEPS_45 += $(CONFIG)/inc/osdep.h
DEPS_45 += $(CONFIG)/obj/mprLib.o
DEPS_45 += $(CONFIG)/bin/libmpr.a
DEPS_45 += $(CONFIG)/inc/pcre.h
DEPS_45 += $(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_45 += $(CONFIG)/bin/libpcre.a
endif
DEPS_45 += $(CONFIG)/inc/http.h
DEPS_45 += $(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_45 += $(CONFIG)/bin/libhttp.a
endif
DEPS_45 += $(CONFIG)/inc/appweb.h
DEPS_45 += $(CONFIG)/inc/customize.h
DEPS_45 += $(CONFIG)/obj/config.o
DEPS_45 += $(CONFIG)/obj/convenience.o
DEPS_45 += $(CONFIG)/obj/dirHandler.o
DEPS_45 += $(CONFIG)/obj/fileHandler.o
DEPS_45 += $(CONFIG)/obj/log.o
DEPS_45 += $(CONFIG)/obj/server.o
DEPS_45 += $(CONFIG)/bin/libappweb.a
DEPS_45 += $(CONFIG)/obj/phpHandler.o

$(CONFIG)/bin/libmod_php.a: $(DEPS_45)
	@echo '      [Link] $(CONFIG)/bin/libmod_php.a'
	ar -cr $(CONFIG)/bin/libmod_php.a "$(CONFIG)/obj/phpHandler.o"
endif

#
#   cgiHandler.o
#
DEPS_46 += $(CONFIG)/inc/me.h
DEPS_46 += $(CONFIG)/inc/appweb.h

$(CONFIG)/obj/cgiHandler.o: \
    src/modules/cgiHandler.c $(DEPS_46)
	@echo '   [Compile] $(CONFIG)/obj/cgiHandler.o'
	$(CC) -c -o $(CONFIG)/obj/cgiHandler.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/modules/cgiHandler.c

ifeq ($(ME_COM_CGI),1)
#
#   libmod_cgi
#
DEPS_47 += $(CONFIG)/inc/mpr.h
DEPS_47 += $(CONFIG)/inc/me.h
DEPS_47 += $(CONFIG)/inc/osdep.h
DEPS_47 += $(CONFIG)/obj/mprLib.o
DEPS_47 += $(CONFIG)/bin/libmpr.a
DEPS_47 += $(CONFIG)/inc/pcre.h
DEPS_47 += $(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_47 += $(CONFIG)/bin/libpcre.a
endif
DEPS_47 += $(CONFIG)/inc/http.h
DEPS_47 += $(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_47 += $(CONFIG)/bin/libhttp.a
endif
DEPS_47 += $(CONFIG)/inc/appweb.h
DEPS_47 += $(CONFIG)/inc/customize.h
DEPS_47 += $(CONFIG)/obj/config.o
DEPS_47 += $(CONFIG)/obj/convenience.o
DEPS_47 += $(CONFIG)/obj/dirHandler.o
DEPS_47 += $(CONFIG)/obj/fileHandler.o
DEPS_47 += $(CONFIG)/obj/log.o
DEPS_47 += $(CONFIG)/obj/server.o
DEPS_47 += $(CONFIG)/bin/libappweb.a
DEPS_47 += $(CONFIG)/obj/cgiHandler.o

$(CONFIG)/bin/libmod_cgi.a: $(DEPS_47)
	@echo '      [Link] $(CONFIG)/bin/libmod_cgi.a'
	ar -cr $(CONFIG)/bin/libmod_cgi.a "$(CONFIG)/obj/cgiHandler.o"
endif

#
#   appweb.o
#
DEPS_48 += $(CONFIG)/inc/me.h
DEPS_48 += $(CONFIG)/inc/appweb.h

$(CONFIG)/obj/appweb.o: \
    src/server/appweb.c $(DEPS_48)
	@echo '   [Compile] $(CONFIG)/obj/appweb.o'
	$(CC) -c -o $(CONFIG)/obj/appweb.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" "-I$(BIT_PACK_PHP_PATH)" "-I$(BIT_PACK_PHP_PATH)/main" "-I$(BIT_PACK_PHP_PATH)/Zend" "-I$(BIT_PACK_PHP_PATH)/TSRM" src/server/appweb.c

#
#   appweb
#
DEPS_49 += $(CONFIG)/inc/mpr.h
DEPS_49 += $(CONFIG)/inc/me.h
DEPS_49 += $(CONFIG)/inc/osdep.h
DEPS_49 += $(CONFIG)/obj/mprLib.o
DEPS_49 += $(CONFIG)/bin/libmpr.a
DEPS_49 += $(CONFIG)/inc/pcre.h
DEPS_49 += $(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_49 += $(CONFIG)/bin/libpcre.a
endif
DEPS_49 += $(CONFIG)/inc/http.h
DEPS_49 += $(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_49 += $(CONFIG)/bin/libhttp.a
endif
DEPS_49 += $(CONFIG)/inc/appweb.h
DEPS_49 += $(CONFIG)/inc/customize.h
DEPS_49 += $(CONFIG)/obj/config.o
DEPS_49 += $(CONFIG)/obj/convenience.o
DEPS_49 += $(CONFIG)/obj/dirHandler.o
DEPS_49 += $(CONFIG)/obj/fileHandler.o
DEPS_49 += $(CONFIG)/obj/log.o
DEPS_49 += $(CONFIG)/obj/server.o
DEPS_49 += $(CONFIG)/bin/libappweb.a
DEPS_49 += src/slink.c
DEPS_49 += $(CONFIG)/inc/esp.h
DEPS_49 += $(CONFIG)/obj/espLib.o
ifeq ($(ME_COM_ESP),1)
    DEPS_49 += $(CONFIG)/bin/libmod_esp.a
endif
DEPS_49 += $(CONFIG)/obj/slink.o
DEPS_49 += $(CONFIG)/bin/libslink.a
DEPS_49 += $(CONFIG)/inc/est.h
DEPS_49 += $(CONFIG)/obj/estLib.o
ifeq ($(ME_COM_EST),1)
    DEPS_49 += $(CONFIG)/bin/libest.a
endif
DEPS_49 += $(CONFIG)/obj/mprSsl.o
DEPS_49 += $(CONFIG)/bin/libmprssl.a
DEPS_49 += $(CONFIG)/obj/sslModule.o
ifeq ($(ME_COM_SSL),1)
    DEPS_49 += $(CONFIG)/bin/libmod_ssl.a
endif
DEPS_49 += $(CONFIG)/inc/zlib.h
DEPS_49 += $(CONFIG)/obj/zlib.o
ifeq ($(ME_COM_ZLIB),1)
    DEPS_49 += $(CONFIG)/bin/libzlib.a
endif
DEPS_49 += $(CONFIG)/inc/ejs.h
DEPS_49 += $(CONFIG)/inc/ejs.slots.h
DEPS_49 += $(CONFIG)/inc/ejsByteGoto.h
DEPS_49 += $(CONFIG)/obj/ejsLib.o
ifeq ($(ME_COM_EJS),1)
    DEPS_49 += $(CONFIG)/bin/libejs.a
endif
DEPS_49 += $(CONFIG)/obj/ejsHandler.o
ifeq ($(ME_COM_EJS),1)
    DEPS_49 += $(CONFIG)/bin/libmod_ejs.a
endif
DEPS_49 += $(CONFIG)/obj/phpHandler.o
ifeq ($(ME_COM_PHP),1)
    DEPS_49 += $(CONFIG)/bin/libmod_php.a
endif
DEPS_49 += $(CONFIG)/obj/cgiHandler.o
ifeq ($(ME_COM_CGI),1)
    DEPS_49 += $(CONFIG)/bin/libmod_cgi.a
endif
DEPS_49 += $(CONFIG)/obj/appweb.o

LIBS_49 += -lappweb
ifeq ($(ME_COM_HTTP),1)
    LIBS_49 += -lhttp
endif
LIBS_49 += -lmpr
ifeq ($(ME_COM_PCRE),1)
    LIBS_49 += -lpcre
endif
LIBS_49 += -lslink
ifeq ($(ME_COM_ESP),1)
    LIBS_49 += -lmod_esp
endif
ifeq ($(ME_COM_SQLITE),1)
    LIBS_49 += -lsql
endif
ifeq ($(ME_COM_SSL),1)
    LIBS_49 += -lmod_ssl
endif
LIBS_49 += -lmprssl
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_49 += -lssl
    LIBPATHS_49 += -L$(ME_COM_OPENSSL_PATH)
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_49 += -lcrypto
    LIBPATHS_49 += -L$(ME_COM_OPENSSL_PATH)
endif
ifeq ($(ME_COM_EST),1)
    LIBS_49 += -lest
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_49 += -lmatrixssl
    LIBPATHS_49 += -L$(ME_COM_MATRIXSSL_PATH)
endif
ifeq ($(ME_COM_NANOSSL),1)
    LIBS_49 += -lssls
    LIBPATHS_49 += -L$(ME_COM_NANOSSL_PATH)/bin
endif
ifeq ($(ME_COM_EJS),1)
    LIBS_49 += -lmod_ejs
endif
ifeq ($(ME_COM_EJS),1)
    LIBS_49 += -lejs
endif
ifeq ($(ME_COM_ZLIB),1)
    LIBS_49 += -lzlib
endif
ifeq ($(ME_COM_PHP),1)
    LIBS_49 += -lmod_php
endif
ifeq ($(ME_COM_PHP),1)
    LIBS_49 += -lphp5
    LIBPATHS_49 += -L$(BIT_PACK_PHP_PATH)/libs
endif
ifeq ($(ME_COM_CGI),1)
    LIBS_49 += -lmod_cgi
endif

$(CONFIG)/bin/appweb.out: $(DEPS_49)
	@echo '      [Link] $(CONFIG)/bin/appweb.out'
	$(CC) -o $(CONFIG)/bin/appweb.out $(LDFLAGS) $(LIBPATHS)     "$(CONFIG)/obj/appweb.o" $(LIBPATHS_49) $(LIBS_49) $(LIBS_49) $(LIBS) -Wl,-r 

#
#   authpass.o
#
DEPS_50 += $(CONFIG)/inc/me.h
DEPS_50 += $(CONFIG)/inc/appweb.h

$(CONFIG)/obj/authpass.o: \
    src/utils/authpass.c $(DEPS_50)
	@echo '   [Compile] $(CONFIG)/obj/authpass.o'
	$(CC) -c -o $(CONFIG)/obj/authpass.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/utils/authpass.c

#
#   authpass
#
DEPS_51 += $(CONFIG)/inc/mpr.h
DEPS_51 += $(CONFIG)/inc/me.h
DEPS_51 += $(CONFIG)/inc/osdep.h
DEPS_51 += $(CONFIG)/obj/mprLib.o
DEPS_51 += $(CONFIG)/bin/libmpr.a
DEPS_51 += $(CONFIG)/inc/pcre.h
DEPS_51 += $(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_51 += $(CONFIG)/bin/libpcre.a
endif
DEPS_51 += $(CONFIG)/inc/http.h
DEPS_51 += $(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_51 += $(CONFIG)/bin/libhttp.a
endif
DEPS_51 += $(CONFIG)/inc/appweb.h
DEPS_51 += $(CONFIG)/inc/customize.h
DEPS_51 += $(CONFIG)/obj/config.o
DEPS_51 += $(CONFIG)/obj/convenience.o
DEPS_51 += $(CONFIG)/obj/dirHandler.o
DEPS_51 += $(CONFIG)/obj/fileHandler.o
DEPS_51 += $(CONFIG)/obj/log.o
DEPS_51 += $(CONFIG)/obj/server.o
DEPS_51 += $(CONFIG)/bin/libappweb.a
DEPS_51 += $(CONFIG)/obj/authpass.o

LIBS_51 += -lappweb
ifeq ($(ME_COM_HTTP),1)
    LIBS_51 += -lhttp
endif
LIBS_51 += -lmpr
ifeq ($(ME_COM_PCRE),1)
    LIBS_51 += -lpcre
endif

$(CONFIG)/bin/authpass.out: $(DEPS_51)
	@echo '      [Link] $(CONFIG)/bin/authpass.out'
	$(CC) -o $(CONFIG)/bin/authpass.out $(LDFLAGS) $(LIBPATHS) "$(CONFIG)/obj/authpass.o" $(LIBPATHS_51) $(LIBS_51) $(LIBS_51) $(LIBS) -Wl,-r 

#
#   cgiProgram.o
#
DEPS_52 += $(CONFIG)/inc/me.h

$(CONFIG)/obj/cgiProgram.o: \
    src/utils/cgiProgram.c $(DEPS_52)
	@echo '   [Compile] $(CONFIG)/obj/cgiProgram.o'
	$(CC) -c -o $(CONFIG)/obj/cgiProgram.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/utils/cgiProgram.c

ifeq ($(ME_COM_CGI),1)
#
#   cgiProgram
#
DEPS_53 += $(CONFIG)/inc/me.h
DEPS_53 += $(CONFIG)/obj/cgiProgram.o

$(CONFIG)/bin/cgiProgram.out: $(DEPS_53)
	@echo '      [Link] $(CONFIG)/bin/cgiProgram.out'
	$(CC) -o $(CONFIG)/bin/cgiProgram.out $(LDFLAGS) $(LIBPATHS) "$(CONFIG)/obj/cgiProgram.o" $(LIBS) -Wl,-r 
endif

#
#   ejsc.o
#
DEPS_54 += $(CONFIG)/inc/me.h
DEPS_54 += $(CONFIG)/inc/ejs.h

$(CONFIG)/obj/ejsc.o: \
    src/paks/ejs/ejsc.c $(DEPS_54)
	@echo '   [Compile] $(CONFIG)/obj/ejsc.o'
	$(CC) -c -o $(CONFIG)/obj/ejsc.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/ejs/ejsc.c

ifeq ($(ME_COM_EJS),1)
#
#   ejsc
#
DEPS_55 += $(CONFIG)/inc/mpr.h
DEPS_55 += $(CONFIG)/inc/me.h
DEPS_55 += $(CONFIG)/inc/osdep.h
DEPS_55 += $(CONFIG)/obj/mprLib.o
DEPS_55 += $(CONFIG)/bin/libmpr.a
DEPS_55 += $(CONFIG)/inc/pcre.h
DEPS_55 += $(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_55 += $(CONFIG)/bin/libpcre.a
endif
DEPS_55 += $(CONFIG)/inc/http.h
DEPS_55 += $(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_55 += $(CONFIG)/bin/libhttp.a
endif
DEPS_55 += $(CONFIG)/inc/zlib.h
DEPS_55 += $(CONFIG)/obj/zlib.o
ifeq ($(ME_COM_ZLIB),1)
    DEPS_55 += $(CONFIG)/bin/libzlib.a
endif
DEPS_55 += $(CONFIG)/inc/ejs.h
DEPS_55 += $(CONFIG)/inc/ejs.slots.h
DEPS_55 += $(CONFIG)/inc/ejsByteGoto.h
DEPS_55 += $(CONFIG)/obj/ejsLib.o
DEPS_55 += $(CONFIG)/bin/libejs.a
DEPS_55 += $(CONFIG)/obj/ejsc.o

LIBS_55 += -lejs
ifeq ($(ME_COM_HTTP),1)
    LIBS_55 += -lhttp
endif
LIBS_55 += -lmpr
ifeq ($(ME_COM_PCRE),1)
    LIBS_55 += -lpcre
endif
ifeq ($(ME_COM_ZLIB),1)
    LIBS_55 += -lzlib
endif
ifeq ($(ME_COM_SQLITE),1)
    LIBS_55 += -lsql
endif

$(CONFIG)/bin/ejsc.out: $(DEPS_55)
	@echo '      [Link] $(CONFIG)/bin/ejsc.out'
	$(CC) -o $(CONFIG)/bin/ejsc.out $(LDFLAGS) $(LIBPATHS) "$(CONFIG)/obj/ejsc.o" $(LIBPATHS_55) $(LIBS_55) $(LIBS_55) $(LIBS) -Wl,-r 
endif

ifeq ($(ME_COM_EJS),1)
#
#   ejs.mod
#
DEPS_56 += src/paks/ejs/ejs.es
DEPS_56 += $(CONFIG)/inc/mpr.h
DEPS_56 += $(CONFIG)/inc/me.h
DEPS_56 += $(CONFIG)/inc/osdep.h
DEPS_56 += $(CONFIG)/obj/mprLib.o
DEPS_56 += $(CONFIG)/bin/libmpr.a
DEPS_56 += $(CONFIG)/inc/pcre.h
DEPS_56 += $(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_56 += $(CONFIG)/bin/libpcre.a
endif
DEPS_56 += $(CONFIG)/inc/http.h
DEPS_56 += $(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_56 += $(CONFIG)/bin/libhttp.a
endif
DEPS_56 += $(CONFIG)/inc/zlib.h
DEPS_56 += $(CONFIG)/obj/zlib.o
ifeq ($(ME_COM_ZLIB),1)
    DEPS_56 += $(CONFIG)/bin/libzlib.a
endif
DEPS_56 += $(CONFIG)/inc/ejs.h
DEPS_56 += $(CONFIG)/inc/ejs.slots.h
DEPS_56 += $(CONFIG)/inc/ejsByteGoto.h
DEPS_56 += $(CONFIG)/obj/ejsLib.o
DEPS_56 += $(CONFIG)/bin/libejs.a
DEPS_56 += $(CONFIG)/obj/ejsc.o
DEPS_56 += $(CONFIG)/bin/ejsc.out

$(CONFIG)/bin/ejs.mod: $(DEPS_56)
	( \
	cd src/paks/ejs; \
	../../../$(LBIN)/ejsc --out ../../../$(CONFIG)/bin/ejs.mod --optimize 9 --bind --require null ejs.es ; \
	)
endif

#
#   ejs.o
#
DEPS_57 += $(CONFIG)/inc/me.h
DEPS_57 += $(CONFIG)/inc/ejs.h

$(CONFIG)/obj/ejs.o: \
    src/paks/ejs/ejs.c $(DEPS_57)
	@echo '   [Compile] $(CONFIG)/obj/ejs.o'
	$(CC) -c -o $(CONFIG)/obj/ejs.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/ejs/ejs.c

ifeq ($(ME_COM_EJS),1)
#
#   ejscmd
#
DEPS_58 += $(CONFIG)/inc/mpr.h
DEPS_58 += $(CONFIG)/inc/me.h
DEPS_58 += $(CONFIG)/inc/osdep.h
DEPS_58 += $(CONFIG)/obj/mprLib.o
DEPS_58 += $(CONFIG)/bin/libmpr.a
DEPS_58 += $(CONFIG)/inc/pcre.h
DEPS_58 += $(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_58 += $(CONFIG)/bin/libpcre.a
endif
DEPS_58 += $(CONFIG)/inc/http.h
DEPS_58 += $(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_58 += $(CONFIG)/bin/libhttp.a
endif
DEPS_58 += $(CONFIG)/inc/zlib.h
DEPS_58 += $(CONFIG)/obj/zlib.o
ifeq ($(ME_COM_ZLIB),1)
    DEPS_58 += $(CONFIG)/bin/libzlib.a
endif
DEPS_58 += $(CONFIG)/inc/ejs.h
DEPS_58 += $(CONFIG)/inc/ejs.slots.h
DEPS_58 += $(CONFIG)/inc/ejsByteGoto.h
DEPS_58 += $(CONFIG)/obj/ejsLib.o
DEPS_58 += $(CONFIG)/bin/libejs.a
DEPS_58 += $(CONFIG)/obj/ejs.o

LIBS_58 += -lejs
ifeq ($(ME_COM_HTTP),1)
    LIBS_58 += -lhttp
endif
LIBS_58 += -lmpr
ifeq ($(ME_COM_PCRE),1)
    LIBS_58 += -lpcre
endif
ifeq ($(ME_COM_ZLIB),1)
    LIBS_58 += -lzlib
endif
ifeq ($(ME_COM_SQLITE),1)
    LIBS_58 += -lsql
endif

$(CONFIG)/bin/ejs.out: $(DEPS_58)
	@echo '      [Link] $(CONFIG)/bin/ejs.out'
	$(CC) -o $(CONFIG)/bin/ejs.out $(LDFLAGS) $(LIBPATHS) "$(CONFIG)/obj/ejs.o" $(LIBPATHS_58) $(LIBS_58) $(LIBS_58) $(LIBS) -Wl,-r 
endif

ifeq ($(ME_COM_ESP),1)
#
#   esp-paks
#
DEPS_59 += src/paks/esp-html-mvc
DEPS_59 += src/paks/esp-html-mvc/client
DEPS_59 += src/paks/esp-html-mvc/client/assets
DEPS_59 += src/paks/esp-html-mvc/client/assets/favicon.ico
DEPS_59 += src/paks/esp-html-mvc/client/css
DEPS_59 += src/paks/esp-html-mvc/client/css/all.css
DEPS_59 += src/paks/esp-html-mvc/client/css/all.less
DEPS_59 += src/paks/esp-html-mvc/client/index.esp
DEPS_59 += src/paks/esp-html-mvc/css
DEPS_59 += src/paks/esp-html-mvc/css/app.less
DEPS_59 += src/paks/esp-html-mvc/css/theme.less
DEPS_59 += src/paks/esp-html-mvc/generate
DEPS_59 += src/paks/esp-html-mvc/generate/appweb.conf
DEPS_59 += src/paks/esp-html-mvc/generate/controller.c
DEPS_59 += src/paks/esp-html-mvc/generate/controllerSingleton.c
DEPS_59 += src/paks/esp-html-mvc/generate/edit.esp
DEPS_59 += src/paks/esp-html-mvc/generate/list.esp
DEPS_59 += src/paks/esp-html-mvc/layouts
DEPS_59 += src/paks/esp-html-mvc/layouts/default.esp
DEPS_59 += src/paks/esp-html-mvc/LICENSE.md
DEPS_59 += src/paks/esp-html-mvc/package.json
DEPS_59 += src/paks/esp-html-mvc/README.md
DEPS_59 += src/paks/esp-mvc
DEPS_59 += src/paks/esp-mvc/generate
DEPS_59 += src/paks/esp-mvc/generate/appweb.conf
DEPS_59 += src/paks/esp-mvc/generate/controller.c
DEPS_59 += src/paks/esp-mvc/generate/migration.c
DEPS_59 += src/paks/esp-mvc/generate/src
DEPS_59 += src/paks/esp-mvc/generate/src/app.c
DEPS_59 += src/paks/esp-mvc/LICENSE.md
DEPS_59 += src/paks/esp-mvc/package.json
DEPS_59 += src/paks/esp-mvc/README.md
DEPS_59 += src/paks/esp-server
DEPS_59 += src/paks/esp-server/generate
DEPS_59 += src/paks/esp-server/generate/appweb.conf
DEPS_59 += src/paks/esp-server/LICENSE.md
DEPS_59 += src/paks/esp-server/package.json
DEPS_59 += src/paks/esp-server/README.md

$(CONFIG)/esp: $(DEPS_59)
	( \
	cd src/paks; \
	mkdir -p "../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0" ; \
	mkdir -p "../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0/client" ; \
	mkdir -p "../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0/client/assets" ; \
	cp esp-html-mvc/client/assets/favicon.ico ../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0/client/assets/favicon.ico ; \
	mkdir -p "../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0/client/css" ; \
	cp esp-html-mvc/client/css/all.css ../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0/client/css/all.css ; \
	cp esp-html-mvc/client/css/all.less ../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0/client/css/all.less ; \
	cp esp-html-mvc/client/index.esp ../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0/client/index.esp ; \
	mkdir -p "../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0/css" ; \
	cp esp-html-mvc/css/app.less ../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0/css/app.less ; \
	cp esp-html-mvc/css/theme.less ../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0/css/theme.less ; \
	mkdir -p "../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0/generate" ; \
	cp esp-html-mvc/generate/appweb.conf ../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0/generate/appweb.conf ; \
	cp esp-html-mvc/generate/controller.c ../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0/generate/controller.c ; \
	cp esp-html-mvc/generate/controllerSingleton.c ../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0/generate/controllerSingleton.c ; \
	cp esp-html-mvc/generate/edit.esp ../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0/generate/edit.esp ; \
	cp esp-html-mvc/generate/list.esp ../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0/generate/list.esp ; \
	mkdir -p "../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0/layouts" ; \
	cp esp-html-mvc/layouts/default.esp ../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0/layouts/default.esp ; \
	cp esp-html-mvc/LICENSE.md ../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0/LICENSE.md ; \
	cp esp-html-mvc/package.json ../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0/package.json ; \
	cp esp-html-mvc/README.md ../../$(CONFIG)/esp/esp-html-mvc/5.0.0-rc0/README.md ; \
	mkdir -p "../../$(CONFIG)/esp/esp-mvc/5.0.0-rc0" ; \
	mkdir -p "../../$(CONFIG)/esp/esp-mvc/5.0.0-rc0/generate" ; \
	cp esp-mvc/generate/appweb.conf ../../$(CONFIG)/esp/esp-mvc/5.0.0-rc0/generate/appweb.conf ; \
	cp esp-mvc/generate/controller.c ../../$(CONFIG)/esp/esp-mvc/5.0.0-rc0/generate/controller.c ; \
	cp esp-mvc/generate/migration.c ../../$(CONFIG)/esp/esp-mvc/5.0.0-rc0/generate/migration.c ; \
	mkdir -p "../../$(CONFIG)/esp/esp-mvc/5.0.0-rc0/generate/src" ; \
	cp esp-mvc/generate/src/app.c ../../$(CONFIG)/esp/esp-mvc/5.0.0-rc0/generate/src/app.c ; \
	cp esp-mvc/LICENSE.md ../../$(CONFIG)/esp/esp-mvc/5.0.0-rc0/LICENSE.md ; \
	cp esp-mvc/package.json ../../$(CONFIG)/esp/esp-mvc/5.0.0-rc0/package.json ; \
	cp esp-mvc/README.md ../../$(CONFIG)/esp/esp-mvc/5.0.0-rc0/README.md ; \
	mkdir -p "../../$(CONFIG)/esp/esp-server/5.0.0-rc0" ; \
	mkdir -p "../../$(CONFIG)/esp/esp-server/5.0.0-rc0/generate" ; \
	cp esp-server/generate/appweb.conf ../../$(CONFIG)/esp/esp-server/5.0.0-rc0/generate/appweb.conf ; \
	cp esp-server/LICENSE.md ../../$(CONFIG)/esp/esp-server/5.0.0-rc0/LICENSE.md ; \
	cp esp-server/package.json ../../$(CONFIG)/esp/esp-server/5.0.0-rc0/package.json ; \
	cp esp-server/README.md ../../$(CONFIG)/esp/esp-server/5.0.0-rc0/README.md ; \
	)
endif

ifeq ($(ME_COM_ESP),1)
#
#   esp.conf
#
DEPS_60 += src/paks/esp/esp.conf

$(CONFIG)/bin/esp.conf: $(DEPS_60)
	@echo '      [Copy] $(CONFIG)/bin/esp.conf'
	mkdir -p "$(CONFIG)/bin"
	cp src/paks/esp/esp.conf $(CONFIG)/bin/esp.conf
endif

#
#   esp.o
#
DEPS_61 += $(CONFIG)/inc/me.h
DEPS_61 += $(CONFIG)/inc/esp.h

$(CONFIG)/obj/esp.o: \
    src/paks/esp/esp.c $(DEPS_61)
	@echo '   [Compile] $(CONFIG)/obj/esp.o'
	$(CC) -c -o $(CONFIG)/obj/esp.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/esp/esp.c

ifeq ($(ME_COM_ESP),1)
#
#   espcmd
#
DEPS_62 += $(CONFIG)/inc/mpr.h
DEPS_62 += $(CONFIG)/inc/me.h
DEPS_62 += $(CONFIG)/inc/osdep.h
DEPS_62 += $(CONFIG)/obj/mprLib.o
DEPS_62 += $(CONFIG)/bin/libmpr.a
DEPS_62 += $(CONFIG)/inc/pcre.h
DEPS_62 += $(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_62 += $(CONFIG)/bin/libpcre.a
endif
DEPS_62 += $(CONFIG)/inc/http.h
DEPS_62 += $(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_62 += $(CONFIG)/bin/libhttp.a
endif
DEPS_62 += $(CONFIG)/inc/appweb.h
DEPS_62 += $(CONFIG)/inc/customize.h
DEPS_62 += $(CONFIG)/obj/config.o
DEPS_62 += $(CONFIG)/obj/convenience.o
DEPS_62 += $(CONFIG)/obj/dirHandler.o
DEPS_62 += $(CONFIG)/obj/fileHandler.o
DEPS_62 += $(CONFIG)/obj/log.o
DEPS_62 += $(CONFIG)/obj/server.o
DEPS_62 += $(CONFIG)/bin/libappweb.a
DEPS_62 += $(CONFIG)/inc/esp.h
DEPS_62 += $(CONFIG)/obj/espLib.o
DEPS_62 += $(CONFIG)/bin/libmod_esp.a
DEPS_62 += $(CONFIG)/obj/esp.o

LIBS_62 += -lmod_esp
LIBS_62 += -lappweb
ifeq ($(ME_COM_HTTP),1)
    LIBS_62 += -lhttp
endif
LIBS_62 += -lmpr
ifeq ($(ME_COM_PCRE),1)
    LIBS_62 += -lpcre
endif
ifeq ($(ME_COM_SQLITE),1)
    LIBS_62 += -lsql
endif

$(CONFIG)/bin/esp.out: $(DEPS_62)
	@echo '      [Link] $(CONFIG)/bin/esp.out'
	$(CC) -o $(CONFIG)/bin/esp.out $(LDFLAGS) $(LIBPATHS) "$(CONFIG)/obj/esp.o" $(LIBPATHS_62) $(LIBS_62) $(LIBS_62) $(LIBS) -Wl,-r 
endif


#
#   genslink
#
genslink: $(DEPS_63)
	( \
	cd src; \
	esp --static --genlink slink.c compile ; \
	)

#
#   http-ca-crt
#
DEPS_64 += src/paks/http/ca.crt

$(CONFIG)/bin/ca.crt: $(DEPS_64)
	@echo '      [Copy] $(CONFIG)/bin/ca.crt'
	mkdir -p "$(CONFIG)/bin"
	cp src/paks/http/ca.crt $(CONFIG)/bin/ca.crt

#
#   http.o
#
DEPS_65 += $(CONFIG)/inc/me.h
DEPS_65 += $(CONFIG)/inc/http.h

$(CONFIG)/obj/http.o: \
    src/paks/http/http.c $(DEPS_65)
	@echo '   [Compile] $(CONFIG)/obj/http.o'
	$(CC) -c -o $(CONFIG)/obj/http.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/paks/http/http.c

ifeq ($(ME_COM_HTTP),1)
#
#   httpcmd
#
DEPS_66 += $(CONFIG)/inc/mpr.h
DEPS_66 += $(CONFIG)/inc/me.h
DEPS_66 += $(CONFIG)/inc/osdep.h
DEPS_66 += $(CONFIG)/obj/mprLib.o
DEPS_66 += $(CONFIG)/bin/libmpr.a
DEPS_66 += $(CONFIG)/inc/pcre.h
DEPS_66 += $(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_66 += $(CONFIG)/bin/libpcre.a
endif
DEPS_66 += $(CONFIG)/inc/http.h
DEPS_66 += $(CONFIG)/obj/httpLib.o
DEPS_66 += $(CONFIG)/bin/libhttp.a
DEPS_66 += $(CONFIG)/inc/est.h
DEPS_66 += $(CONFIG)/obj/estLib.o
ifeq ($(ME_COM_EST),1)
    DEPS_66 += $(CONFIG)/bin/libest.a
endif
DEPS_66 += $(CONFIG)/obj/mprSsl.o
DEPS_66 += $(CONFIG)/bin/libmprssl.a
DEPS_66 += $(CONFIG)/obj/http.o

LIBS_66 += -lhttp
LIBS_66 += -lmpr
ifeq ($(ME_COM_PCRE),1)
    LIBS_66 += -lpcre
endif
LIBS_66 += -lmprssl
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_66 += -lssl
    LIBPATHS_66 += -L$(ME_COM_OPENSSL_PATH)
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_66 += -lcrypto
    LIBPATHS_66 += -L$(ME_COM_OPENSSL_PATH)
endif
ifeq ($(ME_COM_EST),1)
    LIBS_66 += -lest
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_66 += -lmatrixssl
    LIBPATHS_66 += -L$(ME_COM_MATRIXSSL_PATH)
endif
ifeq ($(ME_COM_NANOSSL),1)
    LIBS_66 += -lssls
    LIBPATHS_66 += -L$(ME_COM_NANOSSL_PATH)/bin
endif

$(CONFIG)/bin/http.out: $(DEPS_66)
	@echo '      [Link] $(CONFIG)/bin/http.out'
	$(CC) -o $(CONFIG)/bin/http.out $(LDFLAGS) $(LIBPATHS)    "$(CONFIG)/obj/http.o" $(LIBPATHS_66) $(LIBS_66) $(LIBS_66) $(LIBS) -Wl,-r 
endif

#
#   sqlite3.h
#
$(CONFIG)/inc/sqlite3.h: $(DEPS_67)
	@echo '      [Copy] $(CONFIG)/inc/sqlite3.h'
	mkdir -p "$(CONFIG)/inc"
	cp src/paks/sqlite/sqlite3.h $(CONFIG)/inc/sqlite3.h

#
#   sqlite3.o
#
DEPS_68 += $(CONFIG)/inc/me.h
DEPS_68 += $(CONFIG)/inc/sqlite3.h

$(CONFIG)/obj/sqlite3.o: \
    src/paks/sqlite/sqlite3.c $(DEPS_68)
	@echo '   [Compile] $(CONFIG)/obj/sqlite3.o'
	$(CC) -c -o $(CONFIG)/obj/sqlite3.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/sqlite/sqlite3.c

ifeq ($(ME_COM_SQLITE),1)
#
#   libsql
#
DEPS_69 += $(CONFIG)/inc/sqlite3.h
DEPS_69 += $(CONFIG)/inc/me.h
DEPS_69 += $(CONFIG)/obj/sqlite3.o

$(CONFIG)/bin/libsql.a: $(DEPS_69)
	@echo '      [Link] $(CONFIG)/bin/libsql.a'
	ar -cr $(CONFIG)/bin/libsql.a "$(CONFIG)/obj/sqlite3.o"
endif

#
#   manager.o
#
DEPS_70 += $(CONFIG)/inc/me.h
DEPS_70 += $(CONFIG)/inc/mpr.h

$(CONFIG)/obj/manager.o: \
    src/paks/mpr/manager.c $(DEPS_70)
	@echo '   [Compile] $(CONFIG)/obj/manager.o'
	$(CC) -c -o $(CONFIG)/obj/manager.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/mpr/manager.c

#
#   manager
#
DEPS_71 += $(CONFIG)/inc/mpr.h
DEPS_71 += $(CONFIG)/inc/me.h
DEPS_71 += $(CONFIG)/inc/osdep.h
DEPS_71 += $(CONFIG)/obj/mprLib.o
DEPS_71 += $(CONFIG)/bin/libmpr.a
DEPS_71 += $(CONFIG)/obj/manager.o

LIBS_71 += -lmpr

$(CONFIG)/bin/appman.out: $(DEPS_71)
	@echo '      [Link] $(CONFIG)/bin/appman.out'
	$(CC) -o $(CONFIG)/bin/appman.out $(LDFLAGS) $(LIBPATHS) "$(CONFIG)/obj/manager.o" $(LIBPATHS_71) $(LIBS_71) $(LIBS_71) $(LIBS) -Wl,-r 

#
#   server-cache
#
src/server/cache: $(DEPS_72)
	( \
	cd src/server; \
	mkdir -p cache ; \
	)

#
#   sqlite.o
#
DEPS_73 += $(CONFIG)/inc/me.h
DEPS_73 += $(CONFIG)/inc/sqlite3.h

$(CONFIG)/obj/sqlite.o: \
    src/paks/sqlite/sqlite.c $(DEPS_73)
	@echo '   [Compile] $(CONFIG)/obj/sqlite.o'
	$(CC) -c -o $(CONFIG)/obj/sqlite.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/sqlite/sqlite.c

ifeq ($(ME_COM_SQLITE),1)
#
#   sqliteshell
#
DEPS_74 += $(CONFIG)/inc/sqlite3.h
DEPS_74 += $(CONFIG)/inc/me.h
DEPS_74 += $(CONFIG)/obj/sqlite3.o
DEPS_74 += $(CONFIG)/bin/libsql.a
DEPS_74 += $(CONFIG)/obj/sqlite.o

LIBS_74 += -lsql

$(CONFIG)/bin/sqlite.out: $(DEPS_74)
	@echo '      [Link] $(CONFIG)/bin/sqlite.out'
	$(CC) -o $(CONFIG)/bin/sqlite.out $(LDFLAGS) $(LIBPATHS) "$(CONFIG)/obj/sqlite.o" $(LIBPATHS_74) $(LIBS_74) $(LIBS_74) $(LIBS) -Wl,-r 
endif

#
#   testAppweb.h
#
$(CONFIG)/inc/testAppweb.h: $(DEPS_75)
	@echo '      [Copy] $(CONFIG)/inc/testAppweb.h'
	mkdir -p "$(CONFIG)/inc"
	cp test/src/testAppweb.h $(CONFIG)/inc/testAppweb.h

#
#   testAppweb.o
#
DEPS_76 += $(CONFIG)/inc/me.h
DEPS_76 += $(CONFIG)/inc/testAppweb.h
DEPS_76 += $(CONFIG)/inc/mpr.h
DEPS_76 += $(CONFIG)/inc/http.h

$(CONFIG)/obj/testAppweb.o: \
    test/src/testAppweb.c $(DEPS_76)
	@echo '   [Compile] $(CONFIG)/obj/testAppweb.o'
	$(CC) -c -o $(CONFIG)/obj/testAppweb.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" test/src/testAppweb.c

#
#   testHttp.o
#
DEPS_77 += $(CONFIG)/inc/me.h
DEPS_77 += $(CONFIG)/inc/testAppweb.h

$(CONFIG)/obj/testHttp.o: \
    test/src/testHttp.c $(DEPS_77)
	@echo '   [Compile] $(CONFIG)/obj/testHttp.o'
	$(CC) -c -o $(CONFIG)/obj/testHttp.o $(CFLAGS) $(DFLAGS) "-I$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" test/src/testHttp.c

#
#   testAppweb
#
DEPS_78 += $(CONFIG)/inc/mpr.h
DEPS_78 += $(CONFIG)/inc/me.h
DEPS_78 += $(CONFIG)/inc/osdep.h
DEPS_78 += $(CONFIG)/obj/mprLib.o
DEPS_78 += $(CONFIG)/bin/libmpr.a
DEPS_78 += $(CONFIG)/inc/pcre.h
DEPS_78 += $(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_78 += $(CONFIG)/bin/libpcre.a
endif
DEPS_78 += $(CONFIG)/inc/http.h
DEPS_78 += $(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_78 += $(CONFIG)/bin/libhttp.a
endif
DEPS_78 += $(CONFIG)/inc/appweb.h
DEPS_78 += $(CONFIG)/inc/customize.h
DEPS_78 += $(CONFIG)/obj/config.o
DEPS_78 += $(CONFIG)/obj/convenience.o
DEPS_78 += $(CONFIG)/obj/dirHandler.o
DEPS_78 += $(CONFIG)/obj/fileHandler.o
DEPS_78 += $(CONFIG)/obj/log.o
DEPS_78 += $(CONFIG)/obj/server.o
DEPS_78 += $(CONFIG)/bin/libappweb.a
DEPS_78 += $(CONFIG)/inc/testAppweb.h
DEPS_78 += $(CONFIG)/obj/testAppweb.o
DEPS_78 += $(CONFIG)/obj/testHttp.o

LIBS_78 += -lappweb
ifeq ($(ME_COM_HTTP),1)
    LIBS_78 += -lhttp
endif
LIBS_78 += -lmpr
ifeq ($(ME_COM_PCRE),1)
    LIBS_78 += -lpcre
endif

$(CONFIG)/bin/testAppweb.out: $(DEPS_78)
	@echo '      [Link] $(CONFIG)/bin/testAppweb.out'
	$(CC) -o $(CONFIG)/bin/testAppweb.out $(LDFLAGS) $(LIBPATHS) "$(CONFIG)/obj/testAppweb.o" "$(CONFIG)/obj/testHttp.o" $(LIBPATHS_78) $(LIBS_78) $(LIBS_78) $(LIBS) -Wl,-r 

ifeq ($(ME_COM_CGI),1)
#
#   test-basic.cgi
#
DEPS_79 += $(CONFIG)/inc/mpr.h
DEPS_79 += $(CONFIG)/inc/me.h
DEPS_79 += $(CONFIG)/inc/osdep.h
DEPS_79 += $(CONFIG)/obj/mprLib.o
DEPS_79 += $(CONFIG)/bin/libmpr.a
DEPS_79 += $(CONFIG)/inc/pcre.h
DEPS_79 += $(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_79 += $(CONFIG)/bin/libpcre.a
endif
DEPS_79 += $(CONFIG)/inc/http.h
DEPS_79 += $(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_79 += $(CONFIG)/bin/libhttp.a
endif
DEPS_79 += $(CONFIG)/inc/appweb.h
DEPS_79 += $(CONFIG)/inc/customize.h
DEPS_79 += $(CONFIG)/obj/config.o
DEPS_79 += $(CONFIG)/obj/convenience.o
DEPS_79 += $(CONFIG)/obj/dirHandler.o
DEPS_79 += $(CONFIG)/obj/fileHandler.o
DEPS_79 += $(CONFIG)/obj/log.o
DEPS_79 += $(CONFIG)/obj/server.o
DEPS_79 += $(CONFIG)/bin/libappweb.a
DEPS_79 += $(CONFIG)/inc/testAppweb.h
DEPS_79 += $(CONFIG)/obj/testAppweb.o
DEPS_79 += $(CONFIG)/obj/testHttp.o
DEPS_79 += $(CONFIG)/bin/testAppweb.out

test/web/auth/basic/basic.cgi: $(DEPS_79)
	( \
	cd test; \
	echo "#!`type -p ejs`" >web/auth/basic/basic.cgi ; \
	echo 'print("HTTP/1.0 200 OK\nContent-Type: text/plain\n\n" + serialize(App.env, {pretty: true}) + "\n")' >>web/auth/basic/basic.cgi ; \
	chmod +x web/auth/basic/basic.cgi ; \
	)
endif

ifeq ($(ME_COM_CGI),1)
#
#   test-cache.cgi
#
DEPS_80 += $(CONFIG)/inc/mpr.h
DEPS_80 += $(CONFIG)/inc/me.h
DEPS_80 += $(CONFIG)/inc/osdep.h
DEPS_80 += $(CONFIG)/obj/mprLib.o
DEPS_80 += $(CONFIG)/bin/libmpr.a
DEPS_80 += $(CONFIG)/inc/pcre.h
DEPS_80 += $(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_80 += $(CONFIG)/bin/libpcre.a
endif
DEPS_80 += $(CONFIG)/inc/http.h
DEPS_80 += $(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_80 += $(CONFIG)/bin/libhttp.a
endif
DEPS_80 += $(CONFIG)/inc/appweb.h
DEPS_80 += $(CONFIG)/inc/customize.h
DEPS_80 += $(CONFIG)/obj/config.o
DEPS_80 += $(CONFIG)/obj/convenience.o
DEPS_80 += $(CONFIG)/obj/dirHandler.o
DEPS_80 += $(CONFIG)/obj/fileHandler.o
DEPS_80 += $(CONFIG)/obj/log.o
DEPS_80 += $(CONFIG)/obj/server.o
DEPS_80 += $(CONFIG)/bin/libappweb.a
DEPS_80 += $(CONFIG)/inc/testAppweb.h
DEPS_80 += $(CONFIG)/obj/testAppweb.o
DEPS_80 += $(CONFIG)/obj/testHttp.o
DEPS_80 += $(CONFIG)/bin/testAppweb.out

test/web/caching/cache.cgi: $(DEPS_80)
	( \
	cd test; \
	echo "#!`type -p ejs`" >web/caching/cache.cgi ; \
	echo 'print("HTTP/1.0 200 OK\nContent-Type: text/plain\n\n{number:" + Date().now() + "}\n")' >>web/caching/cache.cgi ; \
	chmod +x web/caching/cache.cgi ; \
	)
endif

ifeq ($(ME_COM_CGI),1)
#
#   test-cgiProgram
#
DEPS_81 += $(CONFIG)/inc/me.h
DEPS_81 += $(CONFIG)/obj/cgiProgram.o
DEPS_81 += $(CONFIG)/bin/cgiProgram.out

test/cgi-bin/cgiProgram.out: $(DEPS_81)
	( \
	cd test; \
	cp ../$(CONFIG)/bin/cgiProgram.out cgi-bin/cgiProgram.out ; \
	cp ../$(CONFIG)/bin/cgiProgram.out cgi-bin/nph-cgiProgram.out ; \
	cp ../$(CONFIG)/bin/cgiProgram.out 'cgi-bin/cgi Program.out' ; \
	cp ../$(CONFIG)/bin/cgiProgram.out web/cgiProgram.cgi ; \
	chmod +x cgi-bin/* web/cgiProgram.cgi ; \
	)
endif

ifeq ($(ME_COM_CGI),1)
#
#   test-testScript
#
DEPS_82 += $(CONFIG)/inc/mpr.h
DEPS_82 += $(CONFIG)/inc/me.h
DEPS_82 += $(CONFIG)/inc/osdep.h
DEPS_82 += $(CONFIG)/obj/mprLib.o
DEPS_82 += $(CONFIG)/bin/libmpr.a
DEPS_82 += $(CONFIG)/inc/pcre.h
DEPS_82 += $(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_82 += $(CONFIG)/bin/libpcre.a
endif
DEPS_82 += $(CONFIG)/inc/http.h
DEPS_82 += $(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_82 += $(CONFIG)/bin/libhttp.a
endif
DEPS_82 += $(CONFIG)/inc/appweb.h
DEPS_82 += $(CONFIG)/inc/customize.h
DEPS_82 += $(CONFIG)/obj/config.o
DEPS_82 += $(CONFIG)/obj/convenience.o
DEPS_82 += $(CONFIG)/obj/dirHandler.o
DEPS_82 += $(CONFIG)/obj/fileHandler.o
DEPS_82 += $(CONFIG)/obj/log.o
DEPS_82 += $(CONFIG)/obj/server.o
DEPS_82 += $(CONFIG)/bin/libappweb.a
DEPS_82 += $(CONFIG)/inc/testAppweb.h
DEPS_82 += $(CONFIG)/obj/testAppweb.o
DEPS_82 += $(CONFIG)/obj/testHttp.o
DEPS_82 += $(CONFIG)/bin/testAppweb.out

test/cgi-bin/testScript: $(DEPS_82)
	( \
	cd test; \
	echo '#!../$(CONFIG)/bin/cgiProgram.out' >cgi-bin/testScript ; chmod +x cgi-bin/testScript ; \
	)
endif

#
#   installBinary
#
installBinary: $(DEPS_83)

#
#   install
#
DEPS_84 += installBinary

install: $(DEPS_84)


#
#   run
#
DEPS_85 += compile

run: $(DEPS_85)
	( \
	cd src/server; \
	sudo ../../$(CONFIG)/bin/appweb -v ; \
	)


#
#   uninstall
#
DEPS_86 += build

uninstall: $(DEPS_86)
	( \
	cd package; \
	rm -f "$(ME_VAPP_PREFIX)/appweb.conf" ; \
	rm -f "$(ME_VAPP_PREFIX)/esp.conf" ; \
	rm -f "$(ME_VAPP_PREFIX)/mine.types" ; \
	rm -f "$(ME_VAPP_PREFIX)/install.conf" ; \
	rm -fr "$(ME_VAPP_PREFIX)/inc/appweb" ; \
	)

#
#   version
#
version: $(DEPS_87)
	echo 5.0.0-rc0

