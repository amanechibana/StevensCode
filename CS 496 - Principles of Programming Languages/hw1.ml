(*Amane Chibana*)
(*Pledge: I pledge my honor that I have abided by the Stevens Honor System.*)

(*defining type program*)
type program = int list
let square : program = [0; 2; 2; 3; 3; 4; 4; 5; 5; 1]
let letter_e : program = [ 0 ; 2 ; 2 ; 3 ; 3 ; 5 ; 5 ; 4 ; 3 ; 5 ; 4 ; 3 ; 3 ; 5 ; 5 ; 1 ]

(*declaring map function for later usage*)
let rec map : ('a -> 'b) -> 'a list -> 'b list =
  fun f l ->
  match l with
  | [] -> []
  | h::t -> f h :: map f t

(*declaring fold function for later usage*)  
let rec foldr : ('a -> 'b -> 'b) -> 'b -> 'a list -> 'b =
  fun f a l ->
  match l with
  | [] -> a
  | h::t -> f h (foldr f a t)

(*draws mirror image of input program*)
let rec mirror_image: int list -> int list = 
  fun l ->
  match l with
  | [] -> []
  | h::t ->
    if h = 2 || h = 3 then  (h + 2) :: mirror_image t 
    else if h > 3 then (h - 2):: mirror_image t 
    else h :: mirror_image t 

(*given a program returns a new one which draws the same pictures rotated in 90 degrees*)
let rec rotate_90_letter: int list -> int list = 
  fun l ->
  match l with 
  | [] -> []
  | h::t ->
    if h = 5 then 2 :: rotate_90_letter t 
    else if h > 1 then (h + 1):: rotate_90_letter t 
    else h :: rotate_90_letter t 

(*given a list of programs return a new list where all programs in the list are rotated 90 degrees*)
let rec rotate_90_word: int list list -> int list list = 
  fun l ->
  match l with 
  | [] -> []
  | h::t -> rotate_90_letter h :: rotate_90_word t 

(*returns a list with n copies of x*)
let rec repeat: int -> 'a -> 'a list = 
  fun n x ->
  match n with 
  | 0 -> []
  | m -> x :: repeat (n-1) x

(*helper function for pantograph*)
let pantohelp : int -> int -> int list =
  fun a l ->
  match l with 
  | 0 -> [l]
  | 1 -> [l]
  | m -> (repeat a l)

(*map + pantohelp return an int list list, convert it to an int list*)
let rec connect: int list list -> int list = 
  fun l ->
  match l with
  | [] -> []
  | h::t -> h @ connect t

(*returns a program the same thing as p but enlarged*)
  let pantograph : int -> int list -> int list =
    fun a l -> connect (map (pantohelp a) l)

(*version of pantograph not using map*)
let rec pantograph_nm : int -> int list -> int list = 
  fun a l ->
  match l with 
  | [] -> []
  | h::t -> 
    if h < 2 then h :: pantograph_nm a t
    else (repeat a h) @ (pantograph_nm a t)

(*helper function for pantograph using fold*)
let panto_fhelp : int -> int -> int list -> int list= 
  fun a x y -> (pantohelp a x) @ y

(*version of pantograph using fold*)
let pantograph_f : int -> int list -> int list =
  fun a l -> foldr (panto_fhelp a) [] l 

(*given a starting coordinate returns list of coordinates that the program visits*)
let rec coverage : int*int -> int list -> (int*int) list = 
  fun a l -> 
  match l with 
  | [] -> []
  | h::t -> match h with
    | 0 -> a :: coverage a t 
    | 1 -> a :: coverage a t 
    | 2 -> ((fst a), (snd a) + 1) :: coverage ((fst a), (snd a) + 1) t
    | 3 -> ((fst a + 1), (snd a)) :: coverage ((fst a + 1), (snd a)) t
    | 4 -> ((fst a), (snd a) - 1) :: coverage ((fst a), (snd a) - 1) t
    | 5 -> ((fst a - 1), (snd a)) :: coverage ((fst a - 1), (snd a)) t
    | _ -> a :: coverage a t

(*helper function for compress*)
let rec comphelp : int -> int -> int list -> (int*int) list = 
  fun n c l ->
    match l with
    | [] -> [(n,c)]
    | h::t -> 
      if h = n then comphelp h (c+1) t 
      else (n,c) :: comphelp h 1 t 

(*compresses a program by replacing adjacent copies of the same instruction with a tuple representing the directions*)
let compress : int list -> (int*int) list = 
  fun l -> 
    match l with 
    | [] -> []
    | h::t -> comphelp h 1 t
 
(*decompresses compressed instructions*)
let rec uncompress : (int * int) list  -> int list =
  fun l ->
  match l with 
  | [] -> []
  | h::t -> repeat (snd h) (fst h) @ uncompress t

(*helper function for uncompress with map*)
let uncomphelp: 'a * int -> 'a list  =
  fun l -> repeat (snd l) (fst l)

(*uncompress using map*)
let uncompress_m : (int*int) list -> int list = 
  fun l -> connect (map uncomphelp l) 

let uncomp_fhelp : 'a * int -> 'a list -> 'a list = 
  fun x y -> repeat (snd x) (fst x) @ y

(*uncompress using fold*)
let uncompress_f : (int*int) list -> int list = 
  fun l -> foldr uncomp_fhelp [] l 

(*helper function for optimize *)
let rec opthelp: program -> int -> program = 
  fun l x -> 
  match l with
  | [] -> []
  | h :: t ->
    if h > 1 then h :: opthelp t x
    else if h = x then opthelp t x 
    else h :: opthelp t h 

(*optimizes a program by eliminating redundant pen up and down instructions*)
let optimize: program -> program = 
  fun l -> opthelp l 1
