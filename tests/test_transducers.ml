
open Transducers

let () = begin
  let xform  = take 5 >> filter (fun x -> x mod 2 = 0) >> map (fun x -> x + 1) in
  let result = transduce xform (+) 0 (list [0; 1; 2; 3; 4; 5; 6; 7; 8; 9]) in
  assert (result = 9)
end

