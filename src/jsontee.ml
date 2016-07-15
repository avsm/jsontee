(*---------------------------------------------------------------------------
 Copyright (c) 2016 Anil Madhavapeddy. All rights reserved.
   Distributed under the ISC license, see terms at the end of the file.
   %%NAME%% %%VERSION%%
  ---------------------------------------------------------------------------*)

type line = {
  fd: int;
  time: float;
  line: string;
}

let line_to_json l =
  `O [ "fd", `String (string_of_int l.fd);
       "time", `Float l.time;
       "line", `String l.line ]

let lines_to_json ~command ~status ~code ~lines =
  let cmd, args = command in
  let cmdline = `A (`String cmd :: (List.map (fun x -> `String x)) (Array.to_list args)) in
  `O [ "cmdline", cmdline;
       "status", `String status;
       "code", `String code;
       "exitcode", `String code;
       "lines", `A (List.map line_to_json lines) ]


(*---------------------------------------------------------------------------
   Copyright (c) 2016 Anil Madhavapeddy

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
