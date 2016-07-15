(*
 * Copyright (c) 2016 Anil Madhavapeddy <anil@recoil.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
*)

open Lwt.Infix

let exit_code_of_process status =
  match status with
  | Unix.WEXITED code -> "exit", (string_of_int code)
  | Unix.WSIGNALED signal -> "signal", (string_of_int signal)
  | Unix.WSTOPPED signal -> "stopped", (string_of_int signal)
 
let process command proc =
  let lines = ref [] in
  let add_line fd line =
    let time = Unix.gettimeofday () in
    let l = { Jsontee.fd; time; line } in
    lines := l :: !lines
  in
  let rec process_fd fd chan =
    Lwt_io.read_line_opt chan >>= function
    | None -> Lwt.return_unit
    | Some line ->
       add_line fd line;
       process_fd fd chan
  in
  let stdout_t = process_fd 1 proc#stdout in
  let stderr_t = process_fd 2 proc#stderr in
  (stdout_t <&> stderr_t) >>= fun () ->
  proc#status >>= fun status ->
  let status, code = exit_code_of_process status in
  let json = Jsontee.lines_to_json ~command ~status ~code ~lines:!lines in
  Lwt.return json

let run cmd () =
  match cmd with
  | [] -> `Error (true, "Need a non-empty command to execute")
  | argv_0::argv_n -> 
    Logs.info (fun p -> p "Executing %s %s" argv_0 (String.concat " " argv_n));
    let command = argv_0, (Array.of_list argv_n) in
    let json = Lwt_main.run (Lwt_process.with_process_full command (process command)) in
    print_endline (Ezjsonm.to_string json);
    `Ok ()

(* Command line interface *)
let setup_log style_renderer level =
  Fmt_tty.setup_std_outputs ?style_renderer ();
  Logs.set_level level;
  Logs.set_reporter (Logs_fmt.reporter ());
  ()

open Cmdliner

let setup_log =
  Term.(const setup_log $ Fmt_cli.style_renderer () $ Logs_cli.level ())

let cmd_args = Arg.(non_empty & pos_all string [] & info [] ~docv:"COMMAND")

let cmd =
  let doc = "jsontee captures the stdout, stderr and exit code of a sub-process" in
  let man = [
    `S "BUGS";
    `P "Email them to <anil@recoil.org> or report issues on $(i,https://github.com/avsm/jsontee).";
    `S "SEE ALSO";
    `P "$(b,tee)(1), $(b,jq)(1)" ]
  in
  Term.(ret (const run $ cmd_args $ setup_log)),
  Term.info "jsontee" ~version:"1.0.0" ~doc ~man

let () = match Term.eval cmd with `Error _ -> exit 1 
  | _ -> exit (if Logs.err_count () > 0 then 1 else 0)
