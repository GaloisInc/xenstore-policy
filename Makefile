#
# Makefile
#
# Copyright (C) 2013, Galois, Inc.
# All Rights Reserved.
#

FLASK_FILES_PRE   := security_classes initial_sids access_vectors
FLASK_FILES_POST  := users initial_sid_defs

POLICY_FILES      := xenstore.if xenstore.te
POLICY_VERSION    := 24
POLICY            := xenstore.$(POLICY_VERSION)

CHECKPOLICY       := checkpolicy -c $(POLICY_VERSION)
ALL_FILES         := $(FLASK_FILES_PRE) $(POLICY_FILES) $(FLASK_FILES_POST)

INSTALL_FILES     := META xenstore.24 _build/flask_gen.cmi _build/flask_gen.cmo \
                     _build/flask_gen.cmx _build/flask_gen.o

build: $(POLICY) _build/flask_gen.cmx

$(POLICY): policy.conf
	$(CHECKPOLICY) -o $@ policy.conf

policy.conf: $(ALL_FILES) Makefile
	m4 -D self_contained_policy -s $(ALL_FILES) > $@

include/flask.h: $(ALL_FILES)
	test -d include || mkdir include
	python flask.py -a access_vectors -i initial_sids -s security_classes -u -o include

_build/flask_gen.cmx: flask_gen.ml
	ocamlbuild flask_gen.cmx

flask_gen.ml: $(ALL_FILES)
	python flask.py --ocaml -a access_vectors -i initial_sids -s security_classes -u -o .

clean:
	ocamlbuild -clean
	rm -rf include policy.conf $(POLICY)

install: build
	ocamlfind install xenstore-policy $(INSTALL_FILES)

uninstall:
	ocamlfind remove xenstore-policy

reinstall:
	$(MAKE) uninstall
	$(MAKE) install

# vim: set ft=make ts=2 noet:
