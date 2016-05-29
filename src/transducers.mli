
type 'a reduced = Continue of 'a | Done of 'a

type 'a iterable

type ('a, 'r) reducer

type ('a, 'b) transducer

val compose : ('b, 'c) transducer -> ('a, 'b) transducer -> ('a, 'c) transducer
val ( >> )  : ('a, 'b) transducer -> ('b, 'c) transducer -> ('a, 'c) transducer
val ( << )  : ('b, 'c) transducer -> ('a, 'b) transducer -> ('a, 'c) transducer

val map : ('a -> 'b) -> ('a, 'b) transducer

val filter : ('a -> bool) -> ('a, 'a) transducer

val take : int -> ('a, 'a) transducer

val transduce : ('a, 'b) transducer -> ('r -> 'b -> 'r) -> 'r -> 'a iterable -> 'r

val list : 'a list -> 'a iterable
(** Create an iterable from list. *)

val chan : in_channel -> string iterable
(** Create an iterable from input channel. *)

