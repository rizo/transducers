
type 'a reduced = Continue of 'a | Done of 'a

type 'a iterable = Iterable : 's * ('s -> ('a * 's) option) -> 'a iterable

type ('s, 'a, 'r) reducer =
  { init : 's;
    step : 's -> 'r -> 'a -> ('s * 'r reduced);
    stop : 's -> 'r -> 'r }

type ('s, 't, 'a, 'b) transducer =
  { this : 'r. ('t, 'b, 'r) reducer -> ('s, 'a, 'r) reducer }

val compose :
  ('a, 'b, 'c, 'd) transducer ->
  ('b, 'e, 'd, 'f) transducer -> ('a, 'e, 'c, 'f) transducer
val ( >> ) :
  ('a, 'b, 'c, 'd) transducer ->
  ('b, 'e, 'd, 'f) transducer -> ('a, 'e, 'c, 'f) transducer
val ( << ) :
  ('a, 'b, 'c, 'd) transducer ->
  ('e, 'a, 'f, 'c) transducer -> ('e, 'b, 'f, 'd) transducer

val map : ('a -> 'b) -> ('s, 's, 'a, 'b) transducer

val filter : ('a -> bool) -> ('s, 's, 'a, 'a) transducer

val take : int -> (int * 's, 's, 'a, 'a) transducer

val transduce : ('s, unit, 'a, 'b) transducer
  -> ('r -> 'b -> 'r) -> 'r -> 'a iterable -> 'r

val list : 'a list -> 'a iterable

val chan : in_channel -> string iterable

