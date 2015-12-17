
open Elements

type ('r, 'a) reducer = 'r -> 'a -> 'r

type ('a, 'b) transducer = { t : 'r . ('r, 'b) reducer -> ('r, 'a) reducer }

module Iter
  : sig
    val map : ('a ->   'b) -> ('a, 'b) transducer
    val filter : ('a -> bool) -> ('a, 'a) transducer
    val compose : ('a, 'b) transducer -> ('b, 'c) transducer -> ('a, 'c) transducer
  end
= struct

  let map f =
    { t = fun step r a -> step r (f a) }

  let filter p =
    { t = fun step r a ->
          if p a then step r a else r }

  let compose { t = t1 } { t = t2 } =
    { t = fun step -> t1 (t2 step) }
end

let (<<) t1 t2 = Iter.compose t2 t1
let (>>) = Iter.compose

let transduce_list { t } xs =
  List.rev (List.fold xs ~init:[] ~f:(t (flip cons)))

let test () =
  let plan = Iter.(map ((+) 10) >> filter odd >> map Int.to_string) in
  let res  = transduce_list plan (List.range 0 10) in
  print (fmt "res = [%s]" (String.concat "; " res))

