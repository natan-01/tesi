option lp=cplex;
option limrow=1000;

* definisco il set "grande"
set iter /iter1*iter1000/;

* definisco le variabili del problema
positive variable x;
variable y;
y.lo=0;

* definisco il parametro in cui salvo la soluzione di ogni iterazione
parameter x_s(iter) soluzione iterazione;

* definisco i parametri dove salvo soluzioni consecutive
parameter x_i,x_j valore della x in due soluzioni consecutive;

* definisco il set dinamico delle iterazioni che aumenta
* il numero massimo di elementi in questo set è 1000 (iter1000)
set incremento(iter) 'dynamic set';

* con il "no" dico che all'inizio questo set è vuoto
incremento(iter)=no;

* definisco i parametri a e b che variano in base a iter
parameter a(iter), b(iter);

* definisco il vincolo che cambia (ne aumenta il numero con le iterazioni
* nelle equazioni dobbiamo usare il nome del set dinamico
equation lincon(iter);
lincon(incremento)..
         y=g=a(incremento)+b(incremento)*x;

* inizializzo a zero la prima "soluzione"
x_i=0;

* definisco il punto di partenza per le valutazioni del "taglio"
x.l=0

* definisco il nome del modello ed il suo contenuto
model CuttingPlanes /all/

* inizializzo a zero il parametro scalar (diventa 1 quando il programma converge)
scalar converged /0/;

*continua a fare iterazioni fino a che converged non è uguale a 1
loop(iter$(not converged),

* per ogni nuova iterazione aggiungi un elemento nel set dinamico incremento
incremento(iter)=yes;

* il parametro x_s assume il valore della soluzione x.l del problema lineare
* (il primo valore lo abbiamo definito noi ed è pari a 0)

* ATTENZIONE: di iter ne sta considerando solo uno per volta
* mentre di incremento ne considera tanti perchè li attiva con yes ma non li disattiva mai
* se assegnassi x_s(iterazione)=x.l allora tutti gli x_s fino all'iterazione corrente
* assumerebbero valore x.l... ma noi vogliamo che solo x_s relativo all'iterazione corrente
* assuma il valore x.l
x_s(iter)=x.l;


* assegno i valori ai parametri a e b relativi al nuovo vincolo creato
a(iter)=-0.3*x_s(iter)**2+36;

b(iter)= 0.6*x_s(iter)-6;

* risolvo il problema lineare con i tagli aggiunti fino all'iterazione corrente
solve CuttingPlanes using lp minimizing y;

* aggiorno x_j (la soluzione corrente)
x_j=x.l;

* confronto con x_i (la soluzione precedente) per capire se sto convergendo.
* se le due soluzioni sono vicine allora converged diventa 1 e si esce dal loop.
converged$(abs(x_j-x_i) < 0.00001) = 1;

*aggiorno x_i
x_i=x_j;

);

display x_i,y.l;

