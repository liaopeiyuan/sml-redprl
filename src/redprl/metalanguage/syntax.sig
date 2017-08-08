signature METALANGUAGE_SYNTAX = 
sig
  type osym
  type osort
  type oterm
  type oast

  type mlvar
  type meta

  structure Ctx : DICT where type key = mlvar
  val freshVar : unit -> mlvar
  type ('b, 'a) scope

  datatype mltype = 
     UNIT
   | ARR of mltype * mltype
   | PROD of mltype * mltype
   | OTERM of osort
   | META of meta

  type rule_name = string

  datatype ('v, 's, 'o) mlterm = 
     VAR of 'v
   | LET of ('v, 's, 'o) mlterm * ('v, ('v, 's, 'o) mlterm) scope
   | LAM of ('v, ('v, 's, 'o) mlterm) scope
   | APP of ('v, 's, 'o) mlterm * ('v, 's, 'o) mlterm
   | PAIR of ('v, 's, 'o) mlterm * ('v, 's, 'o) mlterm
   | FST of ('v, 's, 'o) mlterm
   | SND of ('v, 's, 'o) mlterm
   | QUOTE of 'o | GOAL
   | REFINE of rule_name
   | EACH of ('v, 's, 'o) mlterm list
   | TRY of ('v, 's, 'o) mlterm * ('v, 's, 'o) mlterm
   | PUSH of ('s list, ('v, 's, 'o) mlterm) scope
   | NIL

  type mlterm_ = (mlvar, osym, oterm) mlterm

  val unscope : ('b, ('v, 's, 'o) mlterm) scope -> 'b * ('v, 's, 'o) mlterm
  val scope : mlvar * (mlvar, 's, 'o) mlterm -> (mlvar, (mlvar, 's, 'o) mlterm) scope
  val oscope : osym list * ('v, osym, oterm) mlterm -> (osym list, ('v, osym, oterm) mlterm) scope

  structure Resolver : 
  sig
    val scope : string * (string, 's, 'o) mlterm -> (string, (string, 's, 'o) mlterm) scope
    val resolve : (string, string, oast * osort) mlterm -> mlterm_
  end
end