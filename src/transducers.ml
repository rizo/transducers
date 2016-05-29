
type 'a reduced = Continue of 'a | Done of 'a

type 'a iterator =
    Iterator : 's * ('s -> ('a * 's) option) -> 'a iterator

type ('a, 'r) reducer =
    Reducer : ('s * ('s -> 'r -> 'a -> 's * 'r reduced)) -> ('a, 'r) reducer

type ('a, 'b) transducer =
  { this : 'r . ('b, 'r) reducer -> ('a, 'r) reducer }

let compose { this = g } { this = f } =
  { this = fun step -> f (g step) }

let (>>) g f = compose f g
let (<<) f g = compose f g

let map f =
  let this (Reducer (s, next)) =
    Reducer (s, fun s r x -> next s r (f x)) in
  { this }

let filter p =
  let this (Reducer (s, next)) =
    Reducer (s, fun s r x ->
        if p x then next s r x
        else (s, Continue r)) in
  { this }

let take n =
  let this (Reducer (s0, next)) =
    Reducer ((s0, 0),
             fun (s, i) r a ->
               if i >= n then
                 ((s, i), Done r)
               else
                 let s', r' = next s r a in
                 ((s', i + 1), r')) in
  { this }

let stateless f = Reducer ((), fun () x y -> (), Continue (f x y))

let transduce { this = xf } f r0 (Iterator (input, next)) =
  let (Reducer (s0, step)) = xf (stateless f) in
  let rec loop s r input =
    match next input with
    | None -> (s, r)
    | Some (x, xs) ->
      begin match step s r x with
        | s, Done r     -> (s, r)
        | s, Continue r -> loop s r xs
      end in
  let (s, r) = loop s0 r0 input in
  r

(* Producers *)

let of_list input =
  let next l =
    match l with
    | []      -> None
    | x :: xs -> Some (x, xs) in
  Iterator (input, next)

let of_chan input =
  let next c =
    try Some (input_line c, c)
    with End_of_file -> None in
  Iterator (input, next)

(* Consumers *)

let to_list xf iterator =
  List.rev (transduce xf (fun r x -> x :: r) [] iterator)

let to_chan c0 xf iterator =
  let _ = transduce xf (fun r x -> output_string r (x ^ "\n"); r) c0 iterator in
  ()

