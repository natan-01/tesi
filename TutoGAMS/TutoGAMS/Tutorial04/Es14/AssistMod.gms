option mip=cplex;

set localizzazioni /A,B,C,D,E/

set strade /a1,a2,a3,a4,a5,a6,a7,a8,a9/

parameter costoLoc(localizzazioni)
/
A=100
B=75
C=120
D=125
E=95
/;


set copertura(localizzazioni,strade)
/
A.a1
A.a2
B.a2
B.a3
B.a4
B.a5
B.a6
C.a3
C.a4
C.a5
C.a9
D.a6
D.a7
D.a8
E.a1
E.a4
E.a5
E.a9
/;

binary variable C(localizzazioni);
variable z fo;

equation cop(strade);
cop(strade)..
         sum(localizzazioni$copertura(localizzazioni,strade),C(localizzazioni))=g=1;

equation obj;
obj..
         z=e=sum(localizzazioni,costoLoc(localizzazioni)*C(localizzazioni));

model Assist /all/;

solve Assist using mip minimizing z;

display C.l;

