#!/usr/bin/env ocaml
#use "topfind"
#require "topkg"
open Topkg

let () =
  Pkg.describe "bitcointalk" @@ fun c ->
  Ok [ Pkg.mllib "src/bitcointalk.mllib" ;
       Pkg.bin ~auto:true "src/btpump" ;
     ]
