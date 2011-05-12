let
    test = 1:2:3:4:[];
    rev = fn list => letrec
  	  r = fn x,result => case x of
		[]  -> result;
		h:t -> (r t) (h:result)
	  in (r list) []
in  rev test
