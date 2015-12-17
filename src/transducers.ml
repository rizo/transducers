
open Elements

type ('r, 'a) reducer = 'r -> 'a -> 'a
(** [reducer] is a type of a function that takes a result and an element
    and produces an incremented result. *)

type ('a, 'b, 'r) transducer = ('b, 'r) reducer -> ('a, 'r) reducer
(** [transducer] take a reducing function and returns another reducing
    function. *)

let compose t1 t2 = fun r -> t1 (t2 r)

let conj = flip cons

let transduce_list t xs = List.rev (List.fold xs ~init:[] ~f:(t (flip cons)))

let map : ('a -> 'b) -> ('r -> 'b -> 'r) -> ('r -> 'a -> 'r) =
  fun f k r a -> k r (f a)

let filter : ('a -> bool) -> ('r -> 'a -> 'r) -> ('r -> 'a -> 'r) =
  fun p k r a -> if p a then k r a else r

let () =
  let plan = map ((+) 10) % filter odd in
  let res  = transduce_list plan (List.range 0 100) in
  print (fmt "#res = %d" (List.length res))

