(*Amane Chibana*)
(*Pledge: I pledge my honor that I have abided by the Stevens Honor System.*)

type 'a gt = Node of 'a *( 'a gt ) list

let t : int gt =
  Node (33 ,
  [ Node (12 ,[]) ;
  Node (77 ,
  [ Node (37 ,
  [ Node (14 , [])]) ;
  Node (48 , []) ;
  Node (103 , [])])
  ])

let mk_leaf : 'a -> 'a gt =
  fun n ->
  Node (n ,[])

let rec maxoflist : int list -> int -> int =
  fun l x ->
    match l with 
    | [] -> x
    | h::t -> 
      if h>x then maxoflist t h 
      else maxoflist t x

let rec height : 'a gt -> int = 
  fun t -> 
  match t with 
  | Node(_,[]) -> 1
  | Node(_,t) -> 1 + maxoflist (List.map height t) 0

let rec size : 'a gt -> int = 
  fun t -> 
  match t with 
  | Node(_,[]) -> 1
  | Node(_,t) -> 1 + List.fold_left (+) 0 (List.map size t) 

let rec paths_to_leaves : 'a gt -> int list list =
  fun t ->
  match t with
  | Node(_,[]) -> [[]]
  | Node(_,children) -> List.concat (List.mapi (fun i child -> List.map (fun path -> i :: path) (paths_to_leaves child)) children)

let is_leaf_perfect : 'a gt -> bool = 
  fun t -> 
  match List.map List.length (paths_to_leaves t) with
  | [] -> true
  | head::tail -> List.for_all (fun x -> x = head) tail

let rec preorder: 'a gt -> 'a list = 
  fun t -> 
  match t with 
  | Node(m,[]) -> [m]
  | Node(m,t) -> m::List.fold_left (List.append) [] (List.map preorder t)

let rec mirror : 'a gt -> 'a gt = 
  fun t ->
  match t with 
  | Node(m,[]) -> Node(m,[])
  | Node(m,x) -> Node(m,List.rev (List.map mirror x))

let rec map :('a -> 'b) -> 'a gt -> 'b gt = 
  fun f t ->
  match t with
  | Node(m,[]) -> Node(f m,[])
  | Node(m,x) -> Node(f m, List.map (fun child -> map f child) x)

let rec fold: ('a -> 'b list -> 'b) -> 'a gt -> 'b =
  fun f t ->
  match t with
  | Node(m,[]) -> f m []
  | Node(m,x) -> f m (List.map (fold f) x)

let sum t = fold (fun i rs -> i + List.fold_left (fun i j -> i + j) 0 rs) t

let mem t e = fold (fun i rs -> i = e || List.exists ( fun i -> i ) rs ) t

let mirror' : 'a gt -> 'a gt = 
  fun t ->
  fold (fun i rs -> Node(i,List.rev rs)) t

let rec degree : 'a gt -> int =
  fun t -> 
  match t with 
  | Node(m,[]) -> 0
  | Node(m,x) -> maxoflist ((List.length x)::List.map degree x) 0