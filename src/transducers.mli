
type 'a reduced = Continue of 'a | Done of 'a

type 'a iterator =
  Iterator : 's * ('s -> ('a * 's) option) -> 'a iterator

type ('a, 'r) reducer

type ('a, 'b) transducer

val compose : ('b, 'c) transducer -> ('a, 'b) transducer -> ('a, 'c) transducer
(** [compose f g] composes two transducers producing a new one. Note: The
    composition of transducers is contravariant internally. *)

val ( >> )  : ('a, 'b) transducer -> ('b, 'c) transducer -> ('a, 'c) transducer
(** [g >> f] is the infix version of [compose f g]. *)

val ( << )  : ('b, 'c) transducer -> ('a, 'b) transducer -> ('a, 'c) transducer
(** [f << g] is the infix version of [compose f g]. *)

val stateless : ('r -> 'a -> 'r) -> ('a, 'r) reducer
(** [stateless f] creates a stateless reducer with function [f]. *)

val transduce : ('a, 'b) transducer -> ('r -> 'b -> 'r) -> 'r -> 'a iterator -> 'r
(** [transduce xf f r0 iter] applies the transducer [xf] to the iterator [iter]
    and reduces the results with the function [f] and initial accumulator [r0]. *)

val map : ('a -> 'b) -> ('a, 'b) transducer

val filter : ('a -> bool) -> ('a, 'a) transducer

val take : int -> ('a, 'a) transducer

val iter_list : 'a list -> 'a iterator
(** [of_list l] create an iterator of list. *)

val iter_chan : in_channel -> string iterator
(** Create an iterator from input channel. *)

val into_list : 'b list -> ('a, 'b) transducer -> 'a iterator -> 'b list
(** [into_list l0 xf iter] applies the transducer [xf] to the iterator [iter]
    and adds the results to the list [l0]. *)

val into_chan : out_channel -> ('a, string) transducer -> 'a iterator -> unit
(** [into_chan c xf iter] applies the transducer [xf] to the iterator [iter]
    and sends the results to the output channel [c]. *)

