display  "     Perform some balancing checks" ;

** Balance / calculate residual cells
mSAM(reg,fin,ff)$(mapPFin('134',fin) and mapPFin('142',ff)) = TTYZ(reg);
mSAM(reg,fin,ff)$(mapPFin('142',fin) and mapPFin('131',ff)) = sum(sec,LZ(sec,reg));
mSAM(reg,fin,ff)$(mapPFin('142',fin) and mapPFin('135',ff)) = sum(sec,KZ(sec,reg));
mSAM(reg,fin,ff)$(mapPFin('143',fin) and mapPFin('137',ff)) = sum(sec,TAXPZ(sec,reg));
mSAM(reg,fin,ff)$(mapPFin('143',fin) and mapPFin('138',ff)) = sum((rr,good),TAXCZR(rr,reg,good));
mSAM(reg,fin,ff)$(mapPFin('145',fin) and mapPFin('144',ff)) = sum(good,SVZ(reg,good));
* SROWZ:   AW 6/10 Calculate as balancing item from investment balance (or row vs. column sum for '144' ;-) )
SROWZ(reg) = ITZ(reg)+sum(good,SVZ(reg,good))
              -sum(sec,INVZ(sec,reg))-SHZ(reg)-SGZ(reg);
*display SROWZ;

** AW try 20/10 - alternative calculation; same as in balancing of national SAM
** calculate also TRHROW(reg) here as residual, as in national SAM
** -- is global trade balance satisfied then? (doubt it)
* Balanserer GOVERNMENT
TRROWZ(reg)=sum(good,CGZ_old(reg,good))+TRANSFZ(reg)+SGZ(reg)-TTYZ(reg)- sum(sec,TAXPZ(sec,reg))- sum((rr,good),TAXCZR(rr,reg,good));
*             -TTYZ(reg)- sum((fin,ff)$(mapPFin('143',fin) and mapPFin('137',ff)),mSAM(reg,fin,ff))- sum((fin,ff)$(mapPFin('143',fin) and mapPFin('138',ff)),mSAM(reg,fin,ff));

* Balanserer HOUSEHOLD
TRHROWZ(reg) = sum(sec,LZ(sec,reg))+sum(sec,KZ(sec,reg))+TRANSFZ(reg)-sum(good,CZ_old(reg,good))-TTYZ(reg)-SHZ(reg);

* OBS: need to write in correct cell, depending on sign (received from or transferred to)
loop(reg,
   if(SROWZ(reg)>0,
      mSAM(reg,fin,'trade')$mapPFin('144',fin)=SROWZ(reg);
   else
      mSAM(reg,'trade',fin)$mapPFin('144',fin)=-SROWZ(reg);
   );
   if (TRROWZ(reg)>0,
      mSAM(reg,fin,'trade')$mapPFin('143',fin) = TRROWZ(reg);
   else
      mSAM(reg,'trade',fin)$mapPFin('143',fin)= -TRROWZ(reg);
   );
   if (TRHROWZ(reg) > 0,
      mSAM(reg,'trade',fin)$mapPFin('142',fin) = TRHROWZ(reg);
   else
      mSAM(reg,fin,'trade')$mapPFin('142',fin) = -TRHROWZ(reg);
   );
);

**********    ===============================       DATA CHECKS ======================================     *********

parameters
  diXD(reg,good)
  diX(reg,good)
  trade_bal(reg,good)
  investment_bal(reg) balance of savings and investments
  trade_bal_global(reg) global trade balance
  salebal(reg,good)
  demandbal(reg,good)
  tradebal(reg)
  invbal(reg)
  tradebal_glob(reg)
* to check AW 28/10:
  householdbal(reg)
  govbal(reg)
;


* a) Sales in a region = domestic supply + exports to RoW and other regions
* AW 2/12: bruk XDDZ direkte istf. XDZ og mapSecGood
*diXD(reg,good) = sum(sec$mapSecGood(sec,good),XDZ(sec,reg)) - sum(rr, TRADEZ(good,reg,rr))-  EROWZ(reg,good) ;
diXD(reg,good) = sum(sec,XDDZ(reg,sec,good)) - sum(rr, TRADEZ(good,reg,rr))-  EROWZ(reg,good) ;
salebal(reg,good) = sum(sec,mSAM(reg,sec,good))-mSAM(reg,good,'trade')-mTradeData(good,reg,reg);
*last mSAM term does not include intraregional trade, TRADEZ does -> need also mTradeData for intraregional
display diXD,salebal;

* b) Demand in a region = import from ROW and other regions (as products or trade & transport margins)
diX(reg,good) = XZ(reg,good)-MROWZ(reg,good) - sum(rr, TRADEZ(good,rr,reg) + TMCRZ(rr,reg,good)+ TAXCZR(rr,reg,good) ) ;
*The version with trade and transportmargins included
*diX(reg,good) = XZ(reg,good)-MROWZ(reg,good) - sum(rr, TRADEZ(good,rr,reg) + TMCRZ(rr,reg,good)) ;

** AW 27/10: the first 3 lines are XZ
demandbal(reg,good) = sum(sec,mSAM(reg,good,sec))+sum(fin$mapPFin('142',fin),mSAM(reg,good,fin))
           + sum(fin$mapPFin('143',fin),mSAM(reg,good,fin))+sum(fin$mapPFin('144',fin),mSAM(reg,good,fin))
           + sum(fin$mapPFin('145',fin),mSAM(reg,good,fin))+sum(fin$mapPFin('146',fin),mSAM(reg,good,fin))
*           -mSAM(reg,'trade',good)-mTradeData(good,reg,reg)-sum(rr,mTradeMargins(good,rr,reg));
           -mSAM(reg,'trade',good)-mTradeData(good,reg,reg)-sum(fin$mapPFin('146',fin),mSAM(reg,fin,good));
* last line:
* use mTradeData as mSAM does *not* contain intraregional trade flows

trade_bal(reg,good) = diXD(reg,good) - diX(reg,good) ;
display diX, demandbal, trade_bal;

*loop((reg,good),
*   if (abs(salebal(reg,good)) gt checktol,
*          abort "Sales are not balanced "
*   );
*   if (abs(demandbal(reg,good)) gt checktol,
*          abort "Demands are not balanced "
*   );
*);

* c) Balance savings and investments
* Ulf's version:
investment_bal(reg) = sum(sec,INVZ(sec,reg)) + SHZ(reg)  + SGZ(reg) + SROWZ(reg)
*- sum(good,IZ(reg,good)) - sum(good, SVZ(reg,good));
-ITZ(reg) - sum(good, SVZ(reg,good));

invbal(reg)=sum((fin,sec)$mapPFin('144',fin),mSAM(reg,fin,sec))+sum((fin,ff)$(mapPFin('144',fin) and mapPFin('142',ff)),mSAM(reg,fin,ff))
            +sum((fin,ff)$(mapPFin('144',fin) and mapPFin('143',ff)),mSAM(reg,fin,ff))+ sum(fin$mapPFin('144',fin),(mSAM(reg,fin,'trade')-mSAM(reg,'trade',fin)))
* last two terms:  see calculation of SROWZ in TradeGravity.gms and Olga's model - to get sign right
**            -sum(good,mSAM(reg,good,fin)) )-sum((good,fin)$mapPFin('145',fin),mSAM(reg,good,fin));
            -ITZ(reg)-sum((good,fin)$mapPFin('145',fin),mSAM(reg,good,fin));

Display  investment_bal,invbal ;

* d) Global trade balance:
* incoming monetary flows (exports) = outgoing mon. flows (imports)
* Ulf's version:
trade_bal_global(reg) =
* Incoming monetary flows (exports)
  sum(good,EROWZ(reg,good)) + sum((good,rr),TRADEZ(good,reg,rr)) + sum(good,TMXZ(reg,good))
*  sum(good,EROWZ(reg,good))
 -  TRHROWZ(reg) +  TRROWZ(reg) + SROWZ(reg)
** AW 20/10: har minus foran TRHROW pga. fortegn til denne (står i rad istf. kolonne, ref. nasj. SAM)
* Outgoing monetary flows (imports)
  -  sum(good,MROWZ(reg,good)) - sum((good,rr),TRADEZ(good,rr,reg) + TMCRZ(rr,reg,good));
*  -  sum(good,MROWZ(reg,good));

tradebal_glob(reg)=sum(good,mSAM(reg,good,'trade'))
      + (sum(fin$mapPFin('142',fin),mSAM(reg,fin,'trade')-mSAM(reg,'trade',fin)))
      + (sum(fin$mapPFin('143',fin),mSAM(reg,fin,'trade') - mSAM(reg,'trade',fin)))
      + (sum(fin$mapPFin('144',fin),mSAM(reg,fin,'trade') - mSAM(reg,'trade',fin)))
      - sum(good,mSAM(reg,'trade',good)) ;
*mSAM terms for EROW / MROW do not include intraregional trade, TRADEZ does -> need also mTradeData for intraregional
*But these cancel each other out (first & last line)
Display trade_bal_global,tradebal_glob;

* AW 28/10 to check
householdbal(reg)= TRHROWZ(reg)- (sum(sec,LZ(sec,reg))+sum(sec,KZ(sec,reg))+TRANSFZ(reg)-sum(good,CZ_old(reg,good))-TTYZ(reg)-SHZ(reg));
display householdbal;
govbal(reg)=  TRROWZ(reg)-(sum(good,CGZ_old(reg,good))+TRANSFZ(reg)+SGZ(reg)-TTYZ(reg)- sum(sec,TAXPZ(sec,reg))- sum((rr,good), TAXCZR(rr,reg,good)));
display govbal;


**AW 20/10
*loop(reg,
*   if (abs(investment_bal(reg)) gt checktol ,
*          abort "There is no global investment balance"
*   );
*  if (abs(trade_bal_global(reg)) gt checktol ,
*         abort "There is no global trade balance"
*  );
*);

** ====================== Calculate 'tot' row and column sums and add to mSAM
*** AW 13/10: unsure if this is needed at all
* 'trade' includes all export from the region (to other regions and to RoW)
* this cell is not included in Fin vector, replaces RoW -> must add separately
mSAM(reg,good,'tot')=sum(gg,mSAM(reg,good,gg))+sum(sec,mSAM(reg,good,sec))+sum(fin,mSAM(reg,good,fin))+mSAM(reg,good,'trade');
mSAM(reg,sec,'tot')=sum(good,mSAM(reg,sec,good))+sum(ss,mSAM(reg,sec,ss))+sum(fin,mSAM(reg,sec,fin))+mSAM(reg,sec,'trade');
mSAM(reg,fin,'tot')=sum(good,mSAM(reg,fin,good))+sum(sec,mSAM(reg,fin,sec))+sum(ff,mSAM(reg,fin,ff))+mSAM(reg,fin,'trade');
mSAM(reg,'trade','tot')=sum(good,mSAM(reg,'trade',good))+sum(sec,mSAM(reg,'trade',sec))+sum(ff,mSAM(reg,'trade',ff))+mSAM(reg,'trade','trade');
* 'trade' includes all import into the region (from other regions and from RoW)
* this cell is not included in Fin vector -> must add separately
mSAM(reg,'tot',good)=sum(gg,mSAM(reg,gg,good))+sum(sec,mSAM(reg,sec,good))+sum(fin,mSAM(reg,fin,good))+mSAM(reg,'trade',good);
mSAM(reg,'tot',sec)=sum(good,mSAM(reg,good,sec))+sum(ss,mSAM(reg,ss,sec))+sum(fin,mSAM(reg,fin,sec))+mSAM(reg,'trade',sec);
mSAM(reg,'tot',fin)=sum(good,mSAM(reg,good,fin))+sum(sec,mSAM(reg,sec,fin))+sum(ff,mSAM(reg,ff,fin))+mSAM(reg,'trade',fin);
mSAM(reg,'tot','trade')=sum(good,mSAM(reg,good,'trade'))+sum(sec,mSAM(reg,sec,'trade'))+sum(ff,mSAM(reg,ff,'trade'))+mSAM(reg,'trade','trade');
