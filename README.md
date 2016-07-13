jsontee — capture process output and exit code as a JSON stream
-------------------------------------------------------------------------------
%%VERSION%%

jsontee is TODO

jsontee is distributed under the ISC license.

Homepage: https://github.com/avsm/jsontee  
Contact: Anil Madhavapeddy `<anil@recoil.org>`

## Installation

jsontee can be installed with `opam`:

    opam install jsontee

If you don't use `opam` consult the [`opam`](opam) file for build
instructions.

## Documentation

The documentation and API reference is automatically generated by
`ocamldoc` from the interfaces. It can be consulted [online][doc]
and there is a generated version in the `doc` directory of the
distribution.

[doc]: http://anil.recoil.org/jsontee/doc

## Sample programs

If you installed jsontee with `opam` sample programs are located in
the directory `opam config var jsontee:doc`.

In the distribution sample programs and tests are located in the
[`test`](test) directory of the distribution. They can be built with:

    ocamlbuild -use-ocamlfind test/tests.otarget

The resulting binaries are in `_build/test`.

- `test.native` tests the library, nothing should fail.
