let 
   l1 = 1:2:3:[];
   l2 = 4:5:[]
in letrec
   app = fn x,y => case x of
	[]  -> y;
	h:t -> h : ((app t) y)
   in (app l1) l2 

   
