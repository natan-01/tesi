display "(1) Read in national SAM and map to Panda classification"



$call 'gdxxrw i=%input%.xlsx o=SAMsets.gdx MaxDupeErrors = 100        set=rsam rng="1.SAMnasj!d5" rdim=1 cdim=0 set=csam rng="1.SAMnasj!e4" cdim=1 rdim=0 set=SAMsec rng="2.1 SAM_Ind_Map!a2" rdim=1 dset=Psec rng="2.1 SAM_Ind_Map!b2" rdim=1 set=SAMgood rng="2.2 SAM_Prod_Map!a2" rdim=1 dset=Pgood rng="2.2 SAM_Prod_Map!b2" rdim=1 set=SAMfin rng="2.3 SAM_Fin_Map!a2" rdim=1 dset=Pfin rng="2.3 SAM_Fin_Map!b2" rdim=1 '
$call 'gdxxrw i=%input%.xlsx o=SAMmatrices.gdx  par=SAMin rng="1.SAMnasj!d4" rdim=1 cdim=1 set=mapSecP rng="2.1 SAM_Ind_Map!a2" rdim=2 set=mapGoodP rng="2.2 SAM_Prod_Map!a2" rdim=2 set=mapFinP rng="2.3 SAM_Fin_Map!a2" rdim=2'


*$call 'gdxxrw i=%input%.xlsx o=SAMsets.gdx Checkdate set=rsam rng="1.SAMnasj!d5" rdim=1 cdim=0 set=csam rng="1.SAMnasj!e4" cdim=1 rdim=0 set=SAMsec rng="2.1 SAM_Ind_Map!a2" rdim=1 dset=Psec rng="2.1 SAM_Ind_Map!b2" rdim=1 set=SAMgood rng="2.2 SAM_Prod_Map!a2" rdim=1 dset=Pgood rng="2.2 SAM_Prod_Map!b2" rdim=1 set=SAMfin rng="2.3 SAM_Fin_Map!a2" rdim=1 dset=Pfin rng="2.3 SAM_Fin_Map!b2" rdim=1 '
*$call 'gdxxrw i=%input%.xlsx o=SAMmatrices.gdx Checkdate par=SAMin rng="1.SAMnasj!d4" rdim=1 cdim=1 set=mapSecP rng="2.1 SAM_Ind_Map!a2" rdim=2 set=mapGoodP rng="2.2 SAM_Prod_Map!a2" rdim=2 set=mapFinP rng="2.3 SAM_Fin_Map!a2" rdim=2'
*$call 'gdxxrw i=%input%.xlsx o=SAMmatrices.gdx Checkdate par=SAMin rng="1.SAMnasj!d4" rdim=1 cdim=1'



parameter SAMin(*,*);           !! national SAM input


sets
        rsam                    !! spans the rows of input SAM
        csam                    !! spans the columns of input SAM
        SAMgood                 !! goods in input SAM
        SAMsec                  !! sectors in input SAM
        SAMfin                  !! factors and final demand in input SAM
        Pgood                   !! Panda goods or products
        Psec                    !! Panda sectors or industries
        Pfin                    !! 131-149 structure of Fin
        mapSecP(*,*), mapGoodP(*,*)     !! Maps input sectors & goods to Panda sectors & goods
        mapFinP(*,*)
;
alias
     (SAMgood, SAMgood2)
     (Pgood, p_gg, p_ggg)
     (SAMsec,  SAMsec2)
     (Psec,  p_ss, p_sss)
     (SAMfin, SAMfin2)
     (Pfin, p_ff,p_fff)

* Read data from gdx-files
$GDXIN SAMsets.gdx
$LOAD SAMsec, Psec, SAMgood, Pgood, SAMfin, Pfin, rsam, csam

$GDXIN SAMmatrices.gdx
$onundf  !! allows undefined values
$LOADDC SAMin
$LOAD mapSecP, mapGoodP, mapFinP

* ------------------------------------------------
* 1) Map SAM-data into Panda sectors and goods.
* ------------------------------------------------
* Split the national SAM into nine submatrices and map into Panda formats
parameters
     PGG(Pgood,Pgood), PSS(Psec,Psec)
     PGS(Pgood ,Psec), PGF(Pgood ,Pfin)
     PSG(Psec  ,Pgood), PSF(Psec  ,Pfin)
     PFG(Pfin,Pgood), PFS(Pfin,Psec), PFF(Pfin,Pfin)
;

* Map into Panda notation
PGG(Pgood,p_gg) = sum((SAMgood,SAMgood2)$(mapGoodP(SAMgood,Pgood) and mapGoodP(SAMgood2,p_gg) ), SAMin(SAMgood,SAMgood2) );
PGS(Pgood,p_ss) = sum((SAMgood,SAMsec)$(mapGoodP(SAMgood,Pgood) and mapSecP(SAMsec,p_ss) ), SAMin(SAMgood,SAMsec) );
PGF(Pgood,p_ff) = sum((SAMgood,SAMfin)$(mapGoodP(SAMgood,Pgood) and mapFinP(SAMfin,p_ff)), SAMin(SAMgood,SAMfin) );
PSG(Psec,p_gg) = sum((SAMsec,SAMgood)$(mapSecP(SAMsec,Psec) and mapGoodP(SAMgood,p_gg) ), SAMin(SAMsec,SAMgood) );
PSS(Psec,p_ss) = sum((SAMsec,SAMsec2)$(mapSecP(SAMsec,Psec) and mapSecP(SAMsec2,p_ss) ),  SAMin(SAMsec,SAMsec2) );
PSF(Psec,p_ff) = sum((SAMsec,SAMfin)$(mapSecP(SAMsec,Psec) and mapFinP(SAMfin,p_ff)),SAMin(SAMsec,SAMfin) );
PFG(Pfin,p_gg) = sum((SAMgood,SAMfin)$(mapGoodP(SAMgood,p_gg) and mapFinP(SAMfin,Pfin)), SAMin(SAMfin,SAMgood) );
PFS(Pfin,p_ss) = sum((SAMsec,SAMfin)$(mapSecP(SAMsec,p_ss) and mapFinP(SAMfin,Pfin)), SAMin(SAMfin,SAMsec) );
PFF(Pfin,p_ff) = sum((SAMfin,SAMFin2)$(mapFinP(SAMfin,Pfin) and mapFinP(SAMfin2,p_ff)), SAMin(SAMfin,SAMfin2));

* PGG and PSS should always only have zero entries: check
display "--- Check if GxG and SxS matrices are zero:";
parameters sumPGG, sumPSS;
sumPGG = sum((Pgood,p_gg),PGG(Pgood,p_gg));
sumPSS = sum((Psec,p_ss),PSS(Psec,p_ss));
display sumPGG, sumPSS;
* AW to do: stop execution of the code if this is not the case (within tolerance bounds) - or do something else?
* if everything is fine: don't consider these matrices anymore for the preprocessing
scalars
SAM_sum_p  !!intial sum if the SAM
SAM_sum_init !!initial sum of the SAM
;

* Checking the sum value of the initial SAM
SAM_sum_init = sum((rsam,csam),SAMin(rsam,rsam))  ;

* Checking the sum value of the p SAM
SAM_sum_p = sum((Pgood,p_gg),PGG(Pgood,p_gg))+sum((Pgood,p_ss),PGS(Pgood,p_ss))+sum((Pgood,p_ff),PGF(Pgood,p_ff))+sum((Psec,p_gg),PSG(Psec,p_gg))+sum((Psec,p_ss),PSS(Psec,p_ss))+
sum((Psec,p_ff),PSF(Psec,p_ff))+sum((Pfin,p_gg),PFG(Pfin,p_gg))+sum((Pfin,p_ss),PFS(Pfin,p_ss))+sum((Pfin,p_ff),PFF(Pfin,p_ff)) ;


display SAM_sum_init,SAM_sum_p;

execute_unload 'SAM_Panda', PGS, PGF, PSG, PSF, PFG, PFS, PFF;
*Execute 'GDXXRW.EXE SAM_Panda.gdx o=SAM_Panda.xlsx par=PGS rng=PGS!A1 rdim=1 cdim=1 par=PGF rng=PGF!A1 rdim=1 cdim=1 par=PSG rng=PSG!A1 rdim=1 cdim=1 par=PSF rng=PSF!A1 rdim=1 cdim=1 par=PFG rng=PFG!A1 rdim=1 cdim=1 par=PFS rng=PFS!A1 rdim=1 cdim=1 par=PFF rng=PFF!A1 rdim=1 cdim=1 '

