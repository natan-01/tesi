*option solver lp= cplex;
$onsymxref
option limrow=700;
set impianti commenti vari /Seattle, San-Diego/;
set mercati insieme dei mercati /New-York, Chicago, Topeka/;



parameter a(impianti) capacita massima impianti /
Seattle=350
San-Diego=600
/;

parameter b(mercati) domanda minima /
New-York = 325
Chicago = 300
Topeka=275
/;

parameter costi(impianti,mercati) /
Seattle.New-York = 2.5
Seattle.Chicago = 1.7
Seattle.Topeka = 1.8
San-Diego.New-York = 2.5
San-Diego.Chicago = 1.8
San-Diego.Topeka = 1.4
/;

alias(impianti,i);
alias(mercati,j);
equations obiettivo, capmax(i), dommin(j);



variable z;
positive variable x(impianti,mercati);

obiettivo..
         z=e=sum((i,j),costi(i,j)*x(i,j));

capmax(i)..
         sum(j,x(i,j))=l=a(i);

dommin(j)..
         sum(i,x(i,j))=g=b(j);

model nomemodello /obiettivo,capmax,dommin/;

solve nomemodello using lp minimizing z;

display x.l;
