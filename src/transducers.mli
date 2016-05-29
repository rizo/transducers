
type 'a reduced = Continue of 'a | Done of 'a

type 'a iterator

type ('a, 'r) reducer

type ('a, 'b) transducer

val compose : ('b, 'c) transducer -> ('a, 'b) transducer -> ('a, 'c) transducer
val ( >> )  : ('a, 'b) transducer -> ('b, 'c) transducer -> ('a, 'c) transducer
val ( << )  : ('b, 'c) transducer -> ('a, 'b) transducer -> ('a, 'c) transducer

val map : ('a -> 'b) -> ('a, 'b) transducer

val filter : ('a -> bool) -> ('a, 'a) transducer

val take : int -> ('a, 'a) transducer

val transduce : ('a, 'b) transducer -> ('r -> 'b -> 'r) -> 'r -> 'a iterator -> 'r

val of_list : 'a list -> 'a iterator
(** [of_list l] create an iterator of list. *)

val of_chan : in_channel -> string iterator
(** Create an iterator from input channel. *)

val to_list : ('a, 'b) transducer -> 'a iterator -> 'b list
(** [to_list xf iter] applies the transducer [xf] to the iterator [iter]
    and constructs a list with the results. *)

val to_chan : out_channel -> ('a, string) transducer -> 'a iterator -> unit
(** [to_chan c xf iter] applies the transducer [xf] to the iterator [iter]
    and sends the results to the output channel [c]. *)

