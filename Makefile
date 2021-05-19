PREFIX ?= /usr/local
MANDIR ?= $(PREFIX)/share/man
SYSCONFDIR ?= $(PREFIX)/etc

all:
	@echo Run \'make install\' to install NeoRunner.

install:
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@mkdir -p $(DESTDIR)$(SYSCONFDIR)/nr
	@mkdir -p $(DESTDIR)$(MANDIR)/man1
	@cp -p nr $(DESTDIR)$(PREFIX)/bin/nr
	@cp -p config/executor_map_by_ext.json $(DESTDIR)$(SYSCONFDIR)/nr
	@cp -p nr.1 $(DESTDIR)$(MANDIR)/man1
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/nr
	@echo NeoRunner has been successfully installed.

uninstall:
	@rm -rf $(DESTDIR)$(PREFIX)/bin/nr
	@rm -rf $(DESTDIR)$(SYSCONFDIR)/nr
	@rm -rf $(DESTDIR)$(MANDIR)/man1/nr.1*
	@echo NeoRunner has been successfully uninstalled.

