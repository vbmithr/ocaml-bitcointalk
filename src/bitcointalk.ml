(*---------------------------------------------------------------------------
   Copyright (c) 2017 Vincent Bernardoff. All rights reserved.
   Distributed under the ISC license, see terms at the end of the file.
   %%NAME%% %%VERSION%%
  ---------------------------------------------------------------------------*)

module Person = struct
  type t = {
    name : string ;
    id : int ;
    link : string ;
  } [@@deriving fields,xml]
end

module Topic = struct
  type t = {
    subject : string ;
    id : int ;
    link : string ;
  } [@@deriving fields,xml]
end

module Board = struct
  type t = {
    name : string ;
    id : int ;
    link : string ;
  } [@@deriving fields,xml]
end

module Time = struct
  open Core

  type t = Time_ns.t

  let month_of_string = function
  | "January" -> Month.Jan
  | "February" -> Month.Feb
  | "March" -> Month.Mar
  | "April" -> Month.Apr
  | "May" -> Month.May
  | "June" -> Month.Jun
  | "July" -> Month.Jul
  | "August" -> Month.Aug
  | "September" -> Month.Sep
  | "October" -> Month.Oct
  | "November" -> Month.Nov
  | "December" -> Month.Dec
  | s -> invalid_argf "month_of_string: %s" s ()

  let time_of_string s =
    let zone = Time_ns.Zone.utc in
    if String.subo s ~pos:0 ~len:5 = "Today" then
      let date = Date.today ~zone in
      match String.split s ~on:'t' with
      | _ :: time :: _ ->
          let time = Time_ns.Ofday.of_string @@ String.strip time in
          Time_ns.of_date_ofday ~zone date time
      | _ -> invalid_arg "time_of_string"
    else
    match String.split s ~on:',' with
    | [ monthday ; year ; time ] ->
        let y = Int.of_string @@ String.strip year in
        begin match String.split monthday ~on:' ' with
        | [month ; day] ->
            let m = month_of_string @@ String.strip month in
            let d = Int.of_string @@ String.strip day in
            let time = Time_ns.Ofday.of_string @@ String.strip time in
            let date = Date.create_exn ~y ~m ~d in
            Time_ns.of_date_ofday ~zone date time
        | _ -> invalid_arg "time_of_string"
        end
    | _ -> invalid_arg "time_of_string"

  let to_xml t = Csvfields.Xml.xml_of_string @@ Time_ns.to_string t
  let of_xml xml = match Csvfields.Xml.contents xml with
  | Some time -> time_of_string time
  | None -> invalid_arg "Time.of_xml"

  let xsd = []
end

module Article = struct
  type t = {
    time : Time.t ;
    id : int ;
    subject : string ;
    body : string ;
    poster : Person.t ;
    topic : Topic.t ;
    board : Board.t ;
    link : string ;
  } [@@deriving fields,xml]
end

module Recent_post = struct
  type t = {
    time : Time.t ;
    id : int ;
    subject : string ;
    body : string ;
    starter : Person.t ;
    poster : Person.t ;
    topic : Topic.t ;
    board : Board.t ;
    link : string ;
  } [@@deriving fields,xml]
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
