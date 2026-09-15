display  " (4) combine the single parameters to regionalised SAMs in mSAM"
display  "     also, write out interregional trade data and transport margins"


Parameters
    mSAM(reg,*,*)
    mTradeData(good,*,*)
    mTradeMargins(good,reg,reg)
;

mSAM(reg,good,sec)= IOZ_old(reg,good,sec);


* =================                                   ========================== *
*When writing XDDZ to MSAM we have to take out some values for R6 (Sokkelen) because of small numbers and this is creating errors in the MPSGE-kode
scalars
 checktol_2 /1e-08/
 checktol_3 /1e-20/
;

*mSAM(reg,sec,good)=XDDZ(reg,sec,good)
mSAM(reg,sec,good)=XDDZ(reg,sec,good);
*$(not XDDZ(reg,sec,good)<checktol_3);
* =================                                   ========================== *

mSAM(reg,fin,sec)$mapPFin('131',fin) = LZ(sec,reg);
mSAM(reg,fin,sec)$mapPFin('135',fin) = KZ(sec,reg);



mSAM(reg,good,fin)$mapPFin('142',fin) = CZ_old(reg,good);
mSAM(reg,good,fin)$mapPFin('143',fin) = CGZ_old(reg,good);
mSAM(reg,good,fin)$mapPFin('144',fin) = IZ_old(reg,good);
mSAM(reg,good,fin)$mapPFin('145',fin) = SVZ(reg,good);



mTradeData(good,reg,reg2) = TRADEZ(good,reg,reg2);
*$(not TRADEZ(good,reg,reg2)<checktol_3);

mTradeData(good,reg,fin)$mapPFin('149',fin)= EROWZ(reg,good) ;
*$(not EROWZ(reg,good)<checktol_3);
mTradeData(good,fin,reg)$mapPFin('149',fin) = MROWZ(reg,good)  ;
*$(not MROWZ(reg,good)<checktol_3);



* Outgoing trade is the sum of TRADEZ (trade to other regions) and EROWZ (export to RestOfWorld)
mSAM(reg,good,'trade')= EROWZ(reg,good) + sum(reg2$(ord(reg2)<>ord(reg)),TRADEZ(good,reg,reg2)) ;
*$(not TRADEZ(good,reg,reg2)<checktol_3)) ;
* Import is the sum of TRADEZ (trade from other regions) and MROWZ (import from RestOfWorld)
mSAM(reg,'trade',good)= MROWZ(reg,good) + sum(reg2$(ord(reg2)<>ord(reg)),TRADEZ(good,reg2,reg) );
*$(not TRADEZ(good,reg,reg2)<checktol_3)) ;

mSAM(reg,good,fin)$mapPFin('146',fin) =TMXZ(reg,good);
display TMXZ;
** 27/10: Usikker om det skal summeres over fra- eller til-dimensjon
mSAM(reg,fin,good)$mapPFin('146',fin)= sum(reg2,TMCRZ(reg2,reg,good));
mTradeMargins(good,reg,reg2)=TMCRZ(reg,reg2,good) ;
*$(not TMCRZ(reg,reg2,good)<checktol_3);;



mSAM(reg,fin,ff)$(mapPFin('143',fin) and mapPFin('134',ff))=TTYZ(reg);
mSAM(reg,fin,ff)$(mapPFin('142',fin) and mapPFin('143',ff))=TRANSFZ(reg);
mSAM(reg,fin,good)$mapPFin('138',fin)= sum(reg2,TAXCZR(reg2,reg,good));
mSAM(reg,fin,sec)$mapPFin('137',fin) = TAXPZ(sec,reg);
mSAM(reg,fin,sec)$mapPFin('144',fin) = INVZ(sec,reg);
mSAM(reg,fin,ff)$(mapPFin('144',fin) and mapPFin('142',ff)) = SHZ(reg);
mSAM(reg,fin,ff)$(mapPFin('144',fin) and mapPFin('143',ff)) = SGZ(reg);



* Adding zeros where we don't have any values
mSAM(reg,good,sec)$(not mSAM(reg,good,sec))=0;
mSAM(reg,sec,good)$(not mSAM(reg,sec,good))=0;

**
mSAM(reg,fin,sec)$(not mSAM(reg,fin,sec))=0;
mSAM(reg,fin,ff)$(not mSAM(reg,fin,ff))=0;
mSAM(reg,fin,good)$(not mSAM(reg,fin,good))=0;
mSAM(reg,good,'trade')$(not mSAM(reg,good,'trade'))=0;
mSAM(reg,'trade',good)$(not mSAM(reg,'trade',good))=0;

* Adding zeros where we don't have any values
mTradeData(good,reg,reg2)$(not mTradeData(good,reg,reg2))=0;
mTradeData(good,reg,fin)$(not mTradeData(good,reg,fin) and mapPFin('149',fin))=0;
mTradeData(good,fin,reg)$(not mTradeData(good,fin,reg)and mapPFin('149',fin))=0;

*Adding zeros where we don't have any values
mTradeMargins(good,reg,reg2)$(not mTradeMargins(good,reg,reg2))=0;
