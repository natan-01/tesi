option mip = cplex;


set filiali /A,B,C,D,E,F,G,H,I/;
set province /CZ,CS,KR,RC,VV/;

set allocazione(filiali,province) dove possiamo aprire le filiali
/
A.RC
B.CS
C.RC
D.KR
E.CZ
F.VV
G.CZ
H.VV
I.RC
/;

parameter costiattivazione(filiali)
/
A=50
B=40
C=30
D=25
E=40
F=50
G=60
H=40
I=30
/;

parameter potenzialiclienti(filiali)
/
A=300
B=100
C=250
D=200
E=400
F=120
G=100
H=100
I=400
/;

binary variable x(filiali) apertura filiale;
variable z fo;
scalar budget /200/;

equation budgetc,minfiliali1(province),minfiliali2(province),maxfiliali(province),fo;

fo..
         z=e=sum(filiali,potenzialiclienti(filiali)*x(filiali));

budgetc..
         sum(filiali,costiattivazione(filiali)*x(filiali))=l=budget;

minfiliali1('RC')..
         sum(filiali$allocazione(filiali,'RC'),x(filiali))=g=2;

minfiliali2('CZ')..
         sum(filiali$allocazione(filiali,'CZ'),x(filiali))=g=1;


maxfiliali('VV')..
         sum(filiali$(allocazione(filiali,'VV') ),x(filiali))=l=2;


model FilBank /all/;

FilBank.optcr=0

solve FilBank using mip maximizing z;



display x.l;
