open Core
open Async
open Log.Global
open Cohttp_async

open Bitcointalk

let root = Uri.of_string "https://bitcointalk.org/index.php"

let (//) = Filename.concat

let output_dir = ref ""

let on_post (post : Recent_post.t) =
  let board_id = Board.id post.board in
  let topic_id = Topic.id post.topic in
  let dir_path = (!output_dir // (Int.to_string board_id) // (Int.to_string topic_id)) in
  let post_xml = Csvfields.Xml.xml_element ~name:"post" (Recent_post.to_xml post) in
  Unix.mkdir ~p:() dir_path >>= fun () ->
  Writer.with_file (dir_path // Int.to_string post.id ^ ".xml") ~f:begin fun writer ->
    Writer.write writer (Csvfields.Xml.to_string post_xml) ;
    Deferred.unit
  end

let fetch url =
  Client.get url >>= fun (resp, body) ->
  Body.to_string body >>= fun body ->
  debug "%s" body ;
  let xml = Csvfields.Xml.(stateful_of_string (Parser_state.make ()) body |> children) in
  debug "Found %d posts" @@ List.length xml ;
  let posts = List.map xml ~f:Recent_post.of_xml in
  Deferred.List.iter posts ~f:on_post

let main boards limit period od daemon pidfile logfile loglevel () =
  output_dir := od ;
  if daemon then Daemon.daemonize ~cd:"." ();
  Lock_file.create_exn ~unlink_on_exit:true pidfile >>= fun () ->
  begin match logfile with
  | None -> ()
  | Some logfile -> set_output Log.Output.[stderr (); file `Text ~filename:logfile]
  end ;
  set_level (match loglevel with 2 -> `Info | 3 -> `Debug | _ -> `Error) ;
  let boards = List.map boards ~f:Int.to_string in
  let url = match boards with
  | [] -> Uri.with_query root [ "action", [".xml"] ; ]
  | [board] -> Uri.with_query root [ "action", [".xml"] ; "limit", [string_of_int limit] ; "board", [board] ]
  |  boards -> Uri.with_query root [ "action", [".xml"] ; "limit", [string_of_int limit] ; "boards", boards ] in
  debug "URL: %s" @@ Uri.to_string url ;
  fetch url

let command =
  let spec =
    let open Command.Spec in
    empty
    +> flag "-boards" (listed int) ~doc:"Boards"
    +> flag "-limit" (optional_with_default 5 int) ~doc:"Limit"
    +> flag "-period" (optional_with_default 30 int) ~doc:"Refresh every n seconds (default: 30)"
    +> flag "-o" (optional_with_default "data" string) ~doc:"Output directory (default: 'data')"
    +> flag "-daemon" no_arg ~doc:" Daemonize"
    +> flag "-pidfile" (optional_with_default "run/btpump.pid" string) ~doc:"filename Path of the pid file (run/btpump.pid)"
    +> flag "-logfile" (optional string) ~doc:"filename Path of the log file (log/btpump.log)"
    +> flag "-loglevel" (optional_with_default 1 int) ~doc:"1-3 loglevel"
  in
  Command.async ~summary:"BitcoinTalk pumper" spec main

let () = Command.run command

