*option solver lp= cplex;
$onsymxref
option limrow=700;

$include C:\Users\pisciella\Dropbox\CORSO Ricerca Operativa\GAMS tutorial\Tutorial 3\shippingdata.gms

equations obiettivo, capmax, dommin, capacitaconnessione;

variable z;
positive variable x(impianti,mercati);

alias(impianti,i);
alias(mercati,j);

obiettivo..
         z=e=sum((i,j),costi(i,j)*x(i,j));

capmax(i)..
         sum(j$collegamenti(i,j),x(i,j))=l=a(i);

dommin(j)..
         sum(i$collegamenti(i,j),x(i,j))=g=b(j);

capacitaconnessione(i,j)$connessione(i,j)..
         x(i,j)


model nomemodello /obiettivo,capmax,dommin/;

solve nomemodello using lp minimizing z;

display x.l;
