$title SAM for SCGE
$oneolcom
$ontext
         **************************************************************
         *                                                            *
         *                         SAM input                          *
         *             data disaggregation and aggregation            *
         *                            by                              *
         *                       Adrian Werner                        *
         *                    Per Ivar Helgesen                       *
         *                   Okt 2013 -                               *
         *                                                            *
         **************************************************************

This program reads national SAM data from Excel, and converts them
to user-defined regions, sectors, goods and factors.

                 National SAM input      Panda formats           User specified
                ---------------------------------------------------------------
    regions:       <none>                county/municipality     reg
    sectors:       SAMsec                Psec                    sec
    goods:         SAMgood               Pgood                   good

The national SAM is split into 9 parts (submatrices) and mapped to Panda  format:
      goods, industries, factors&finaldemand
      Pgood, Psec      , Pfin
Two of the nine submatrices are empty (good-good and sector-sector).
These submatrices are then aggregated to user-specified goods, industries, and factors.
From the submatrices of the balanced SAM, the code reads then out the single parameters
and, using a gravity model formulation, interregional trade data and transport margins are
calculated and the single parameters are regionalised.
The parameters are combined back again to regional SAMs which, finally, are tested for
some balances.

See also the description in Preprocessing.pdf.
$offtext

Option DECIMALS=2;
* for solving gravity model
Option iterlim = 1000000 ;
Option reslim = 1000000 ;
*option nlp = conopt3 ;
*option nlp = conopt2 ;
*option nlp = conopt1 ;
option nlp = pathnlp ;
*option nlp = minos ;


* Read case specification (data from step 2b)):
* which input XLS file, selective reading of the aggregation keys etc.
$INCLUDE CaseData.gms

* Find the correct keys and sets according to the key IDs specifies in CaseData.gms
* Connects original structure with the one defined by user.
$call gdxxrw i=%input%.xlsx o=AggKeys.gdx set=mapCMtoReg rng=RKey%regkey% rdim=2 par=RegLvl rng=RLevel%regkey% rdim=0 cdim=0 set=mapPSec rng=IKey%indkey% rdim=2 set=mapPGood rng=PKey%prodkey% rdim=2 set=mapPFin rng=FKey%finkey% rdim=2
* Lists the sectors and commodities defined by user
$call gdxxrw i=%input%.xlsx o=AggCaseSets.gdx  dset=reg rng=RReg%regkey% rdim=1 dset=good rng=PProd%prodkey% rdim=1 dset=sec rng=IInd%indkey% rdim=1  dset=fin rng=FFin%finkey% rdim=1
* Data for disaggregating into regions from SSB
$call gdxxrw i=%input%.xlsx o=DisAgg.gdx  par=distrPCounty rng="3.1 Keys_County!c2" rdim=2 cdim=1 dset=county rng="0. Sets!b3" rdim=1
$call gdxxrw i=%input%.xlsx o=Elas.gdx  Squeeze=N par=elas_prod rng="5.1ElasProd!A2" par=elas_sec  rng="5.2ElasSec!A2" rdim=1 cdim=1


scalar
   RegLvl
   goods
   sectors
   regions
   checktol /1e-13/
  ;

* define here to get output in right order
* AW 1/10 - doesn't seem to work anyway now...
sets
        good                    !! user case goods                                                                                                                                                 -
        sec                     !! user case sectors
        fin                     !! user case factors final demand etc
;



$GDXIN AggKeys.gdx
$LOAD RegLvl

* 1) read data from Excel and map to PANDA classification
* (From classification A to classification B, depending on what is in the Sam_Ind_Map and SAM_Prod_Map in excel)
$INCLUDE includes\SamRead+Map.gms


* 2) aggregate SAM data to case-specific sectors / goods / factors+final demand
* From Classification B to the internal classification chosen by the user (iAGR etc...)
$INCLUDE includes\UserGSF.gms


goods = card(good);
sectors = card(sec);
regions = card(reg);

display "Create regionalised data for a case with";
display regions, "regions, ", goods," commodities and ", sectors," sectors.";

**********************            Read the elastities                    *****************************
parameter
elas_sec(*,*)
elas_prod(*,*)
elas_sec_s(cnt,sec)
elas_sec_s1(cnt,sec)
elas_prod_s(cnt,good)
elas_prod_s1(cnt,good)
elas_prod_s2(cnt,good)
elas_prod_s3(cnt,good)
;

$GDXIN Elas.gdx
$LOAD elas_sec, elas_prod

loop(cnt,
elas_sec_s(cnt,sec)= elas_sec(sec,"s");
elas_sec_s1(cnt,sec)= elas_sec(sec,"s1");
);

loop(cnt,
elas_prod_s(cnt,good)=  elas_prod(good,"s");
elas_prod_s1(cnt,good)= elas_prod(good,"s1");
elas_prod_s2(cnt,good)= elas_prod(good,"s2");
elas_prod_s3(cnt,good)= elas_prod(good,"s3");
);
****************************                                          **********************************


* 3) create trade data / gravity model, this takes also care of regionalisation of the other data
$INCLUDE includes\TradeGravity.gms

* 4) build one common regionalised SAM
$INCLUDE includes\write_msam.gms



* 5) Balance, checks etc. for the regional matrices
$INCLUDE includes\CheckBalance.gms



Execute_unload "sjekk", XZ,XXDZ,MROWZ,TRADEZ,TMCRZ, EROWZ

**Execute_unload "check", EROWZ, MROWZ, TRADEZ, XZ
*Execute_unload "msam_bal", mSAM, cnt, com, sec, mTradeData, mTradeMargins, mapSecGood,CZ_old,CGZ_old,IZ_old, IOZ_old, ITZ,CBUDZ,CBUDGZ
Execute_unload "msam_bal", mSAM, cnt, com, sec, mTradeData, mTradeMargins, CZ_old,CGZ_old,IZ_old, IOZ_old, ITZ,CBUDZ,CBUDGZ, distrgood_share_public, elas_sec_s, elas_sec_s1, elas_prod_s, elas_prod_s1, elas_prod_s2, elas_prod_s3
*Execute 'gdx2xls msam_bal'
