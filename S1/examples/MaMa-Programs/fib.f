letrec
fib = fn x => if x <= 1 then 1
	    else (fib (x-1)) + (fib (x-2))
in fib 4
 
