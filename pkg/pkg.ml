#!/usr/bin/env ocaml
#use "topfind"
#require "topkg"
open Topkg

let () =
  Pkg.describe "jsontee" @@ fun c ->
  Ok [ Pkg.mllib ~api:["Jsontee"] "src/jsontee.mllib";
       Pkg.bin "src-bin/jsontee_bin" ~dst:"jsontee";
       Pkg.test "test/test"; ]
