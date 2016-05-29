
type 'a reduced = Continue of 'a | Done of 'a

type 'a iterable =
    Iterable : 's * ('s -> ('a * 's) option) -> 'a iterable

type ('s, 'a, 'r) reducer =
  { init : 's;
    step : 's -> 'r -> 'a -> ('s * 'r reduced);
    stop : 's -> 'r -> 'r }

type ('s, 't, 'a, 'b) transducer =
  { this : 'r . ('t, 'b, 'r) reducer -> ('s, 'a, 'r) reducer }

let compose { this = f } { this = g } =
  { this = fun step -> f (g step) }

let (>>) f g = compose f g
let (<<) g f = compose f g

let map f =
  let this reducer =
    { reducer with step = fun s r x -> reducer.step s r (f x) } in
  { this}

let filter p =
  let this reducer =
        { reducer with step = fun s r x ->
              if p x then reducer.step s r x
              else (s, Continue r) } in
  { this }

let take n =
  let this reducer =
    { init = (n, reducer.init);
      stop = (fun (_, s) -> reducer.stop s);
      step = (fun (i, s) r x ->
          if i > 0 then
            let (s', r') = reducer.step s r x in
            ((i - 1, s'), r')
          else
            ((i, s), Done r)) } in
  { this }

let stateless f = { init = ();
                    stop = (fun s r -> r);
                    step = (fun () x y -> ((), Continue (f x y))) }


let transduce { this = xf } f r0 (Iterable (input, next)) =
  let reducer = xf (stateless f) in
  let rec loop s r input =
    match next input with
    | None -> (s, r)
    | Some (x, xs) ->
      begin match reducer.step s r x with
        | s, Done r     -> (s, r)
        | s, Continue r -> loop s r xs
      end in
  let (s, r) = loop reducer.init r0 input in
  reducer.stop s r

(* Producers *)

let list input =
  let next l =
    match l with
    | []      -> None
    | x :: xs -> Some (x, xs) in
  Iterable (input, next)

let chan input =
  let next c =
    try Some (input_line c, c)
    with End_of_file -> None in
  Iterable (input, next)


