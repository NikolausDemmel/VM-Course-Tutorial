let
  curry = fn f,x,y => f (x,y);
  add = fn z => let (x,y) = z
		in x+y
in ((curry add) 1) 2

  
