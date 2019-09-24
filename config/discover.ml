
type os =
    | Windows
    | Mac
    | Linux
    | Unknown

let uname () =
    let ic = Unix.open_process_in "uname" in
    let uname = input_line ic in
    let () = close_in ic in
    uname;;

let get_os =
    match Sys.os_type with
    | "Win32" -> Windows
    | _ -> match uname () with
        | "Darwin" -> Mac
        | "Linux" -> Linux
        | _ -> Unknown

let root = Sys.getenv "cur__root"
let c_flags = ["-I"; (Sys.getenv "PORTAUDIO_INCLUDE_PATH"); "-I"; Filename.concat root "include"; "-I"; Filename.concat root "src"]

let libPath = "-L" ^ (Sys.getenv "PORTAUDIO_LIB_PATH")

let ccopt s = ["-ccopt"; s]
let cclib s = ["-cclib"; s]

let flags =
    match get_os with
    | Windows ->  []
        @ ccopt(libPath)
        @ cclib("-lportaudio")
    | Linux -> []
        @ ccopt(libPath)
        @ cclib("-lportaudio")
    | _ -> []
        @ ccopt(libPath)
        @ cclib("-lportaudio")
;;

(*let cxx_flags =
    match get_os with
    | Linux -> c_flags @ ["-std=c++11"]
    | Windows -> c_flags @ ["-fno-exceptions"; "-fno-rtti"; "-lstdc++"]
    | _ -> c_flags
;;*)

Configurator.V1.Flags.write_sexp "c_flags.sexp" c_flags;
Configurator.V1.Flags.write_sexp "flags.sexp" flags;
