option mip=cplex

set localizzazioni /a1*a11/;

alias(localizzazioni,loc);

set cover(localizzazioni,loc)
/
a1.a1
a1.a4
a1.a8
a1.a2
a1.a3
a2.a1
a2.a2
a2.a3
a2.a7
a2.a8
a3.a1
a3.a2
a3.a3
a3.a11
a4.a1
a4.a4
a4.a8
a4.a5
a5.a4
a5.a5
a5.a6
a5.a9
a6.a5
a6.a6
a6.a9
a6.a7
a7.a6
a7.a7
a7.a2
a7.a10
a8.a1
a8.a4
a8.a8
a8.a9
a8.a10
a8.a11
a9.a8
a9.a9
a9.a10
a9.a11
a9.a6
a9.a5
a10.a8
a10.a9
a10.a10
a10.a11
a10.a7
a10.a2
a11.a8
a11.a9
a11.a10
a11.a11
a11.a3
/;

parameter costo(localizzazioni)
/
a1=15
a2=20
a3=15
a4=20
a5=15
a6=20
a7=20
a8=20
a9=15
a10=20
a11=15
/;

binary variable x(localizzazioni);
variable z;

equation cop(localizzazioni);
cop(localizzazioni)..
         sum(loc$cover(localizzazioni,loc),x(loc))=g=1;

equation fo1;
fo1..
  z=e=sum(localizzazioni,costo(localizzazioni)*x(localizzazioni));


equation fo2;
fo2..
  z=e=sum(localizzazioni,x(localizzazioni));

model local1 /cop,fo1/;
model local2 /cop,fo2/;

solve local1 using mip minimizing z;
display x.l,z.l;

solve local2 using mip minimizing z;
display x.l,z.l;


