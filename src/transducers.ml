
open Elements

type ('r, 'a) reducer = 'r -> 'a -> 'a
(** [reducer] is a type of a function that takes a result and an element
    and produces an incremented result. *)

type ('a, 'b, 'r) transducer = ('b, 'r) reducer -> ('a, 'r) reducer
(** [transducer] takes a reducer, applies a transformation and returns a new reducer. *)

let transduce_list t xs = List.rev (List.fold xs ~init:[] ~f:(t (flip cons)))

let map : ('a -> 'b) -> ('r -> 'b -> 'r) -> ('r -> 'a -> 'r) =
  fun f step r a -> step r (f a)

let filter : ('a -> bool) -> ('r -> 'a -> 'r) -> ('r -> 'a -> 'r) =
  fun p step r a -> if p a then step r a else r

let () =
  let plan = fun x -> map ((+) 10) (filter odd x) in
  let res  = transduce_list plan (List.range 0 100) in
  print (fmt "#res = %d" (List.length res))

