.PHONY: all clean

all: jsontee.native
	@ :

jsontee.native: jsontee.ml
	ocamlbuild -use-ocamlfind -classic-display $@

clean:
	rm -rf _build

jsontee:
	./opam-boot $@
	strip $@
