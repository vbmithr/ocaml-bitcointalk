(*---------------------------------------------------------------------------
   Copyright (c) 2017 Vincent Bernardoff. All rights reserved.
   Distributed under the ISC license, see terms at the end of the file.
   %%NAME%% %%VERSION%%
  ---------------------------------------------------------------------------*)

(** Parse BitcoinTalk in OCaml

    {e %%VERSION%% — {{:%%PKG_HOMEPAGE%% }homepage}} *)

(** {1 Bitcointalk} *)

module Person : sig
  type t = {
    name : string ;
    id : int ;
    link : string ;
  } [@@deriving xml,fields]
end

module Topic : sig
  type t = {
    subject : string ;
    id : int ;
    link : string ;
  } [@@deriving xml,fields]
end

module Board : sig
  type t = {
    name : string ;
    id : int ;
    link : string ;
  } [@@deriving xml,fields]
end

module Article : sig
  type t = {
    time : string ;
    id : int ;
    subject : string ;
    body : string ;
    poster : Person.t ;
    topic : Topic.t ;
    board : Board.t ;
    link : string ;
  } [@@deriving xml,fields]
end

module Recent_post : sig
  type t = {
    time : string ;
    id : int ;
    subject : string ;
    body : string ;
    starter : Person.t ;
    poster : Person.t ;
    topic : Topic.t ;
    board : Board.t ;
    link : string ;
  } [@@deriving xml,fields]
end

(*---------------------------------------------------------------------------
   Copyright (c) 2017 Vincent Bernardoff

   Permission to use, copy, modify, and/or distribute this software for any
   purpose with or without fee is hereby granted, provided that the above
   copyright notice and this permission notice appear in all copies.

   THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
   WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
   MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
   ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
   WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
   ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
   OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  ---------------------------------------------------------------------------*)
