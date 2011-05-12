letrec
   f = fn result, x => if x <= 1 then result
		       else (f (x * result)) (x-1);
   fac = f 1
in
   fac 4
