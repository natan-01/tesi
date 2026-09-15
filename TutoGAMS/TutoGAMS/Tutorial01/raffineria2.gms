option lp=cplex;

Set J insieme dei tipi di greggio /greggio1,greggio2/;
Sets Prodotti insieme dei prodotti finiti
/
prod1
prod2
/;

alias(Prodotti,K);

Parameters h(K) vettore della domanda minima da soddisfare
/
prod1=13200
prod2=8000
/;

Parameter b(J) capacita marginale della produzione
/
greggio1=55
greggio2=55
/;

Parameter P(J,K) quantita di prodotto k ottenibile da un unita di greggio j
/
greggio1.prod1=200
greggio1.prod2=100
greggio2.prod1=60
greggio2.prod2=50
/;

parameter c(J)/
greggio1=42
greggio2=22
/;

display c;
positive variable x(J) quantita di greggio da acquistare;
variable z variabile associata alla funzione obiettivo;

Equation capacita, domanda, fo;

capacita..
sum(J,b(J)*x(J))=l=15000;

domanda(K)..
sum(J,P(J,K)*x(J))=g=h(K);

fo..
sum(J,c(J)*x(J))=e=z;

model raffineria /capacita,domanda,fo/;

solve raffineria using lp minimizing z;

display x.l,z.l;