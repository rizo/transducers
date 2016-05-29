
open Transducers

let () = begin
  let xform  = take 5 >> filter (fun x -> x mod 2 = 0) >> map (fun x -> x + 1) in
  let r1 = transduce xform (+) 0 (of_list [0; 1; 2; 3; 4; 5; 6; 7; 8; 9]) in
  assert (r1 = 9);
  let r2 = to_list xform (of_list [1; 0; 1; 0; 1; 2; 3; 4; 5]) in
  assert (r2 = [1; 0; 1; 0; 1])
end

