letrec
   f = fn x => if x <= 1 then 1
                           else (x * (f (x-1)))
in
   f 4   
