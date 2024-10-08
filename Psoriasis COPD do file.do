***Clinical 
tab1 f_21000_0_0 f_21000_1_0 f_21000_2_0
tab1 f_22130*
tab1 f_22129*
tab1 f_22128*
sum f_3062_*
tab1 f_21000_0_0 f_21000_1_0 f_21000_2_0
tab1 f_22130*
tab1 f_22129*
tab1 f_22128*
sum f_3062_* f_3063_*
gen FEV1FVC=f_3063_0_0/f_3062_0_0
sum FEV1FVC
recode FEV1FVC min/0.7=1 0.7/max=0,gen(COPD)
tab COPD


gen COPDdiag=0
foreach v of varlist *22168* *22169* *22170* *22129* *22128* *22130* *42017* *42016* *22149* *22150* *22148*{
recode COPDdiag 0=1 if `v'!=.
}
drop COPDdiag
gen COPDdiag=0
foreach v of varlist *42017* *42016* *22149* *22150* *22148*{
recode COPDdiag 0=1 if `v'!=.
}
foreach v of varlist *22168* *22169* *22170* *22129* *22128* *22130* {
recode COPDdiag 0=1 if `v'==2
}
tab COPDdiag
tab COPDdiag f_22130*
tab COPDdiag f_22128*
tab COPDdiag f_22129*

****Merge
tab n_22006_0_0
tab n_22006_0_0 if _merge==2,missing
keep if _merge==3
tab n_22006_0_0 ,missing
tab1 s_affy4119227 s_affy22369516 s_affy27465148

foreach v of varlist s_affy4119227 s_affy22369516 s_affy27465148{
encode `v',gen(`v'n)
recode `v'n 1=.
}
tab1 s_affy4119227n s_affy22369516n s_affy27465148n
tab COPD s_affy4119227n,col exact
tab COPD s_affy22369516n ,col exact
tab COPD s_affy27465148n ,col exact
tab COPDdiag s_affy4119227n,col exact
tab COPDdiag s_affy22369516n ,col exact
tab COPDdiag s_affy27465148n ,col exact

***Frequency of each SNPs
tab1 s_affy4119227n s_affy22369516n s_affy27465148n
***Frequency COPD diagnosis by SNPs
tab COPDdiag s_affy4119227n,col exact
tab COPDdiag s_affy22369516n ,col exact
tab COPDdiag s_affy27465148n ,col exact
***Distribution of FEV1/FVC by SNPs
tabstat FEV1FVC,by( s_affy4119227n) stat(n median p25 p75)
reg FEV1FVC i.s_affy4119227n,r
tabstat FEV1FVC,by( s_affy22369516n ) stat(n median p25 p75)
reg FEV1FVC i.s_affy22369516n ,r
tabstat FEV1FVC,by( s_affy27465148n ) stat(n median p25 p75)
reg FEV1FVC i.s_affy27465148n ,r
***Distribution of obstructive pattern by SNPs
tab COPD s_affy4119227n,col exact
tab COPD s_affy22369516n ,col exact
tab COPD s_affy27465148n ,col exact


***Emphysema
foreach v of varlist f_41201_0_0-f_41201_0_9{
decode `v',gen(`v'n)
}
foreach v of varlist f_41202_0_0-f_41202_0_58{
decode `v',gen(`v'n)
}
tab1  *41204_0*
foreach v of varlist f_41204_0_0-f_41204_0_127 {
decode `v',gen(`v'n)
}
foreach v of varlist f_41204_0_109-f_41204_0_127 {
decode `v',gen(`v'n)
}
gen emphysema=0
foreach v of varlist f_41201_0_0n- f_41204_0_127n{
recode emphysema 0=1 if strmatch(`v',"*J43*")
}
tab emphysema s_affy4119227n,col exact
tab emphysema s_affy22369516n ,col exact
tab emphysema s_affy27465148n ,col exact

**FEV1FVC FEV1 FVC current smoker interaction
tab f_1239_0_0 f_1249_0_0,missing nolabel
gen smoking=0
recode smoking 0=2 if f_1239_0_0==3
recode smoking 0=1 if f_1239_0_0==2 & f_1249_0_0>2 & f_1249_0_0<5
recode smoking 0=. if f_1239_0_0==1 | f_1249_0_0==1
tab smoking
reg FEV1FVC i.smoking,r
reg FEV1FVC i.smoking##i.s_affy4119227n ,r
recode smoking 1=0 2=1,gen(currentsmok)
reg FEV1FVC currentsmok##i.s_affy4119227n ,r
contrast currentsmok#s_affy4119227n
reg FEV1FVC currentsmok##i.s_affy22369516n ,r
contrast currentsmok#s_affy22369516n
reg FEV1FVC currentsmok##i.s_affy27465148n ,r
contrast currentsmok# s_affy27465148n
tab1 s_affy4119227n s_affy22369516n s_affy27465148n
format %tdNN/DD/CCYY f_53_0_0
gen yearv=year( f_53_0_0)
gen age=yearv-f_34_0_0
sum age
reg f_3063_0_0 f_53_0_0  age i.f_31_0_0
reg  f_3063_0_0 f_53_0_0  age i.f_31_0_0 currentsmok##i.s_affy27465148n ,r
contrast currentsmok# s_affy27465148n
tab1 s_affy4119227n s_affy22369516n s_affy27465148n
reg  f_3063_0_0 f_53_0_0  age i.f_31_0_0 currentsmok##i.s_affy4119227n  ,r
contrast currentsmok#s_affy4119227n
reg  f_3063_0_0 f_53_0_0  age i.f_31_0_0 currentsmok##i.s_affy22369516n ,r
contrast currentsmok#s_affy22369516n
reg  f_3063_0_0 f_53_0_0  age i.f_31_0_0 currentsmok##i.s_affy27465148n ,r
contrast currentsmok#s_affy27465148n
reg  f_3062_0_0 f_53_0_0  age i.f_31_0_0 currentsmok##i.s_affy4119227n  ,r
contrast currentsmok#s_affy4119227n
tab currentsmok
tab smoking
reg  f_3062_0_0 f_53_0_0  age i.f_31_0_0 currentsmok##i.s_affy27465148n ,r
reg  f_3062_0_0 f_53_0_0  age i.f_31_0_0 currentsmok##i.s_affy22369516n ,r
contrast currentsmok#s_affy22369516n
reg  f_3064_0_0 f_53_0_0  age i.f_31_0_0 currentsmok##i.s_affy27465148n ,r
contrast currentsmok#s_affy27465148n

reg  FVCp calciumblo f_53_0_0  age i.f_31_0_0 if currentsmok==1 ,r
reg FEV1p calciumblo f_53_0_0  age i.f_31_0_0 if currentsmok==1 ,r
reg  FVCp calciumblo f_53_0_0  age i.f_31_0_0 currentsmok ,r
reg  FEV1p calciumblo f_53_0_0  age i.f_31_0_0 currentsmok ,r
reg FEV1p i.smoking##i.s_affy4119227n ,r
reg FEV1p currentsmok##i.s_affy4119227n ,r
contrast currentsmok#s_affy4119227n
reg FVCp currentsmok##i.s_affy4119227n ,r
contrast currentsmok#s_affy4119227n
reg FEV1p currentsmok##i.s_affy4119227n age i.f_31_0_0,r
contrast currentsmok#s_affy4119227n
reg FVCp currentsmok##i.s_affy4119227n age i.f_31_0_0,r
contrast currentsmok#s_affy4119227n
reg  FEV1p calciumblo f_53_0_0  age i.f_31_0_0 if currentsmok==1 ,r
reg  FVCp calciumblo f_53_0_0  age i.f_31_0_0 if currentsmok==1 ,r
reg  FVCp calciumblo f_53_0_0  age i.f_31_0_0 if currentsmok==1 ,r
reg FEV1p calciumblo f_53_0_0  age i.f_31_0_0 if currentsmok==1 ,r

***ICD 10
gen PHT=0
foreach v of varlist f_41201_0_0n- f_41204_0_127n{
recode PHT 0=1 if strmatch(`v',"*I27*")
}
tab PHT
gen ILD=0
foreach v of varlist f_41201_0_0n- f_41204_0_127n{
recode ILD 0=1 if strmatch(`v',"*J84*")
}
tab ILD
gen Sarcoi=0
foreach v of varlist f_41201_0_0n- f_41204_0_127n{
recode Sarcoi 0=1 if strmatch(`v',"*D86*")
}
tab Sarcoi
drop Sarcoi
gen Sarcoi=0
foreach v of varlist f_41201_0_0n- f_41204_0_127n{
recode Sarcoi 0=1 if strmatch(`v',"*D86") | strmatch(`v',"*D86.6*") |strmatch(`v',"*D86.2*")
}
tab Sarcoi
drop Sarcoi
gen Sarcoi=0
foreach v of varlist f_41201_0_0n- f_41204_0_127n{
recode Sarcoi 0=1 if strmatch(`v',"*D86") | strmatch(`v',"*D866*") |strmatch(`v',"*D862*")
}
tab Sarcoi
gen ILDn=0
foreach v of varlist f_41201_0_0n- f_41204_0_127n{
recode ILDn 0=1 if strmatch(`v',"*J84") | strmatch(`v',"*J841*")| strmatch(`v',"*J849*")
}
tab ILD ILDn
drop ILDn
gen Pneu=0
foreach v of varlist f_41201_0_0n- f_41204_0_127n{
recode Pneu 0=1 if strmatch(`v',"*J10*") | strmatch(`v',"*J11*")| strmatch(`v',"*J12*") |strmatch(`v',"*J13*") | strmatch(`v',"*J14*")| strmatch(`v',"*J15*") | strmatch(`v',"*J16*") | strmatch(`v',"*J17*")| strmatch(`v',"*J18*") | strmatch(`v',"*J200*") | strmatch(`v',"*J851*")| strmatch(`v',"*J852*")
}
tab Pneu
gen Asthma=0
foreach v of varlist f_41201_0_0n- f_41204_0_127n{
recode Asthma 0=1 if strmatch(`v',"*J45*")
}
tab Asthma
gen LungC=0
foreach v of varlist f_41201_0_0n- f_41204_0_127n{
recode LungC 0=1 if strmatch(`v',"*C34*")
}
tab LungC
gen ARDS=0
foreach v of varlist f_41201_0_0n- f_41204_0_127n{
recode ARDS 0=1 if strmatch(`v',"*J80*")
}
tab ARDS
gen HPneu=0
foreach v of varlist f_41201_0_0n- f_41204_0_127n{
recode HPneu 0=1 if strmatch(`v',"*J67") | strmatch(`v',"*J678*") |strmatch(`v',"*J679*") |strmatch(`v',"*J680*")
}
tab HPneu
gen Broncho=0
foreach v of varlist f_41201_0_0n- f_41204_0_127n{
recode Broncho 0=1 if strmatch(`v',"*J47")
}
tab Broncho
foreach v of varlist PHT- Broncho{
tab `v' s_affy4119227n,col exact
}

gen CRD=0
foreach v of varlist f_41201_0_0n- f_41204_0_127n{
recode CRD 0=1 if strmatch(`v',"*J40*") | strmatch(`v',"*J41*")| strmatch(`v',"*J42*") |strmatch(`v',"*J43*") | strmatch(`v',"*J44*")| strmatch(`v',"*J45*") | strmatch(`v',"*J46*") | strmatch(`v',"*J47*")
}
gen ResF=0
foreach v of varlist f_41201_0_0n- f_41204_0_127n{
recode ResF 0=1 if strmatch(`v',"*J96*")
}
tab CRD s_affy4119227n,col exact
tab ResF s_affy4119227n,col exact

**Psoriasis
gen Psoria=0
foreach v of varlist f_41201_0_0n- f_41204_0_127n{
recode Psoria 0=1 if strmatch(`v',"*M07*") | strmatch(`v',"*L40*")
}
tab Psoria
foreach v of varlist PHT- ResF{
tab Psoria `v',col exact
}


**New full data
replace `v'="" if `v'=="NA"
destring `v',replace
sum `v'
}
gen FEV1FVC=f_20150_0_0/f_20151_0_0
sum FEV1FVC
replace FEV1FVC=FEV1FVC*100
recode FEV1FVC min/70=1 70/max=0,gen(Obstruction)
tab Obstruction


gen emphysema=0
foreach v of varlist f_41270_0_0- f_41270_0_212 {
recode emphysema 0=1 if strmatch(`v',"*J43*")
}
tab Obstruction emphysema,col missing
tab Obstruction emphysema,row missing
gen PHT=0
foreach v of varlist f_41270_0_0- f_41270_0_212 {
recode PHT 0=1 if strmatch(`v',"*I27*")
}
gen ILD=0
foreach v of varlist f_41270_0_0- f_41270_0_212 {
recode ILD 0=1 if strmatch(`v',"*J84*")
}


gen Sarcoi=0
foreach v of varlist f_41270_0_0- f_41270_0_212 {
recode Sarcoi 0=1 if strmatch(`v',"*D86") | strmatch(`v',"*D866*") |strmatch(`v',"*D862*")
}
gen Psoria=0
foreach v of varlist f_41270_0_0- f_41270_0_212 {
recode Psoria 0=1 if strmatch(`v',"*M07*") | strmatch(`v',"*L40*")
}
gen Pneu=0
foreach v of varlist f_41270_0_0- f_41270_0_212 {
recode Pneu 0=1 if strmatch(`v',"*J10*") | strmatch(`v',"*J11*")| strmatch(`v',"*J12*") |strmatch(`v',"*J13*") | strmatch(`v',"*J14*")| strmatch(`v',"*J15*") | strmatch(`v',"*J16*") | strmatch(`v',"*J17*")| strmatch(`v',"*J18*") | strmatch(`v',"*J200*") | strmatch(`v',"*J851*")| strmatch(`v',"*J852*")
}

gen Asthma=0
foreach v of varlist f_41270_0_0- f_41270_0_212 {
recode Asthma 0=1 if strmatch(`v',"*J45*")
}

gen LungC=0
foreach v of varlist f_41270_0_0- f_41270_0_212 {
recode LungC 0=1 if strmatch(`v',"*C34*")
}
tab LungC
gen ARDS=0
foreach v of varlist f_41270_0_0- f_41270_0_212 {
recode ARDS 0=1 if strmatch(`v',"*J80*")
}
tab ARDS
gen HPneu=0
foreach v of varlist f_41270_0_0- f_41270_0_212 {
recode HPneu 0=1 if strmatch(`v',"*J67") | strmatch(`v',"*J678*") |strmatch(`v',"*J679*") |strmatch(`v',"*J680*")
}
tab HPneu
gen Broncho=0
foreach v of varlist f_41270_0_0- f_41270_0_212 {
recode Broncho 0=1 if strmatch(`v',"*J47")
}
tab Broncho


gen CRD=0
foreach v of varlist f_41270_0_0- f_41270_0_212 {
recode CRD 0=1 if strmatch(`v',"*J40*") | strmatch(`v',"*J41*")| strmatch(`v',"*J42*") |strmatch(`v',"*J43*") | strmatch(`v',"*J44*")| strmatch(`v',"*J45*") | strmatch(`v',"*J46*") | strmatch(`v',"*J47*")
}
gen ResF=0
foreach v of varlist f_41270_0_0- f_41270_0_212 {
recode ResF 0=1 if strmatch(`v',"*J96*")
}

gen date=date(f_53_0_0,"YMD")
format %tdNN/DD/CCYY date
gen yearv=year( date)
desc f_34_0_0
format %tdNN/DD/CCYY f_34_0_0
gen age=yearv-f_34_0_0
sum age

foreach v of varlist f_1239_0_0 f_1249_0_0{
replace `v'="" if `v'=="NA"
destring `v',replace
tab `v'
}
foreach v of varlist f_1239_0_0 f_1249_0_0{
recode `v' -3=.
}
gen currentsmok=f_1239_0_0
recode currentsmok 2=0
gen pastsmok=f_1249_0_0
recode pastsmok 2/4=0
label variable f_31_0_0 "1= M 0 = F"

gen Race=0
foreach v of varlist f_21000_*_0{
recode Race 0=1 if strmatch(`v', "1")|strmatch(`v', "1001")| strmatch(`v', "1002") | strmatch(`v', "1003")
recode Race 0=2 if strmatch(`v', "2001")|strmatch(`v', "2002")| strmatch(`v', "4002") | strmatch(`v', "4") | strmatch(`v', "4001")
recode Race 0=3 if strmatch(`v', "3001")|strmatch(`v', "3002")| strmatch(`v', "3") |strmatch(`v', "3003") |strmatch(`v', "5") | strmatch(`v', "3004")
recode Race 0=5 if strmatch(`v', "2")|strmatch(`v', "2003") | strmatch(`v', "2004")
recode Race 0=6 if strmatch(`v', "6") 
}

foreach v of varlist Obstruction emphysema PHT ILD Sarcoi Pneu Asthma LungC ARDS HPneu Broncho CRD ResF{
logistic `v' Psoria  i.Race i.f_31_0_0 age if Race>0,r
}

gen Black=0
foreach v of varlist f_21000_*_0{
recode Black 0=1 if strmatch(`v', "2001")|strmatch(`v', "2002")| strmatch(`v', "4002") | strmatch(`v', "4") | strmatch(`v', "4001")
}



*****Psoriasis SNPs
foreach v of varlist s_affy18880737- s_affy52286377{
encode `v',gen(`v'n)
tab1 s_affy18880737n- s_affy52286377n
recode s_affy18880737n 1=.
foreach v of varlist s_affy18884808n - s_affy52286377n{
recode `v' 1=.
}

**FEV1%
foreach v of varlist s_affy18880737n- s_affy52286377n{
oneway FEVp `v',b
}
**FVC%
foreach v of varlist s_affy18880737n- s_affy52286377n{
oneway FVCp `v',b
}
**FEV1/FVC
foreach v of varlist s_affy18880737n- s_affy52286377n{
oneway FEV1FVC `v',b
}
**Emphysema
foreach v of varlist s_affy18880737n- s_affy52286377n{
tab `v' emphysema ,col exact
}
**Psoriasis
foreach v of varlist s_affy18880737n- s_affy52286377n{
tab `v' Psoria ,col exact
}
**Psoriasis age race sex adjusted
foreach v of varlist s_affy18880737n- s_affy52286377n{
logistic  Psoria i.`v' i.Race Sex age if Race>0,r
}

foreach v of varlist s_affy3689590- s_affy52274960{
encode `v',gen(`v'n)
recode `v'n 1=.
tab1 `v'n
}


**FEV1%
foreach v of varlist s_affy3689590n- s_affy52274960n{
oneway FEVp `v',b
}
**FVC%
foreach v of varlist s_affy3689590n- s_affy52274960n{
oneway FVCp `v',b
}
**FEV1/FVC
foreach v of varlist s_affy3689590n- s_affy52274960n{
oneway FEV1FVC `v',b
}
**Emphysema
foreach v of varlist s_affy3689590n- s_affy52274960n{
tab `v' emphysema ,col exact
}
**Psoriasis
foreach v of varlist s_affy3689590n- s_affy52274960n{
tab `v' Psoria ,col exact
}
**Psoriasis age race sex adjusted
foreach v of varlist s_affy3689590n- s_affy52274960n{
logistic  Psoria i.`v' i.Race Sex age if Race>0,r
}

**gen file for the R analysis
gen eversmoker=0
recode eversmoker 0=1 if currentsmok==1 | pastsmok==1
recode eversmoker 0=. if currentsmok==. & pastsmok==.
rename f_50_0_0 height

keep f_eid Sex height FVCp FEVp FEV1FVC Black White age eversmoker s_affy3689590 s_affy5842400 s_affy10426937 s_affy12648368 s_affy13195723 s_affy14326841 s_affy14388789 s_affy15520900 s_affy16076632 s_affy18367011 s_affy19152970 s_affy20337447 s_affy25959198 s_affy30399712 s_affy27465148n Psoria emphysema

foreach v of varlist s_affy3689590- s_affy30399712{
encode `v',gen(`v'n)
recode `v'n 1=.
}
rename s_affy3689590n rs1250546
rename s_affy5842400n rs12118303
rename s_affy10426937n rs8016947
rename s_affy12648368n rs12445568
rename s_affy13195723n rs9988642
rename s_affy14326841n rs55823223
rename s_affy14388789n rs11652075
rename s_affy15520900n rs34536443
rename s_affy16076632n rs492602
rename s_affy18367011n rs17716942
rename s_affy19152970n rs4821124
rename s_affy20337447n rs10865331
rename s_affy25959198n rs12188300
rename s_affy30399712n rs2700987
rename s_affy27465148n rs33980500
tab1 rs33980500 rs1250546- rs2700987
foreach v of varlist  rs*{
recode `v' 2=0 3=1 4=2
}


***************************************************************
**for STATA
drop s_affy27465148n- s_affy3689590n
foreach v of varlist s_affy27465148- s_affy3689590{
encode `v',gen(`v'n)
recode `v'n 1=.
}
drop rs1250546- rs2700987
rename s_affy3689590n rs1250546
rename s_affy5842400n rs12118303
rename s_affy10426937n rs8016947
rename s_affy12648368n rs12445568
rename s_affy13195723n rs9988642
rename s_affy14326841n rs55823223
rename s_affy14388789n rs11652075
rename s_affy15520900n rs34536443
rename s_affy16076632n rs492602
rename s_affy18367011n rs17716942
rename s_affy19152970n rs4821124
rename s_affy20337447n rs10865331
rename s_affy25959198n rs12188300
rename s_affy30399712n rs2700987
drop rs33980500
rename s_affy27465148n rs33980500




***FEV1 model
qtlsnp rs* ,trait(FEVp)  class(Sex eversmoker) cont(age age2 height) siglev(0.99) detail
***FVC model
qtlsnp rs* ,trait(FVCp)  class(Sex eversmoker) cont(age age2 height) siglev(0.99) detail
***FV1/FVC model
qtlsnp rs* ,trait(FEV1FVC)  class(Sex eversmoker) cont(age age2 height) siglev(0.99) detail


***FEV1 model
qtlsnp rs* ,trait(FEVp)  class(Sex eversmoker) cont(age age2 height) dominant siglev(0.99) detail
***FVC model
qtlsnp rs* ,trait(FVCp)  class(Sex eversmoker) cont(age age2 height) dominant siglev(0.99) detail
***FV1/FVC model
qtlsnp rs* ,trait(FEV1FVC)  class(Sex eversmoker) cont(age age2 height) dominant siglev(0.99) detail


***FEV1 model
qtlsnp rs* ,trait(FEVp)  class(Sex eversmoker) cont(age age2 height) recessive siglev(0.99) detail
***FVC model
qtlsnp rs* ,trait(FVCp)  class(Sex eversmoker) cont(age age2 height) recessive siglev(0.99) detail
***FV1/FVC model
qtlsnp rs* ,trait(FEV1FVC)  class(Sex eversmoker) cont(age age2 height) recessive siglev(0.99) detail



***Merge
qtlsnp rs* ,trait( fev1 )  class(Sex eversmoker) cont(age age2 height) siglev(0.99) detail
qtlsnp rs* ,trait( fvc )  class(Sex eversmoker) cont(age age2 height) siglev(0.99) detail

**PSO and Emphysema**Pso
foreach v of varlist rs*{
logistic Psoria `v' Sex eversmoker age if White==1,r
}
**emphysema
foreach v of varlist rs*{
logistic emphysema `v' Sex eversmoker age if White==1,r
}

***Pso lung in White


***Unadjusted in White
foreach v of varlist Obstruction emphysema PHT ILD Pneu Asthma LungC ARDS HPneu Broncho CRD ResF{
tab Psoria `v'  if White==1,col chi2
logistic `v' Psoria if White==1
}
***Adjusted in White
foreach v of varlist Obstruction emphysema PHT ILD Pneu Asthma LungC ARDS HPneu Broncho CRD ResF{
logistic `v' Psoria eversmoker age  Sex if White==1
}



***Psoriasis arthirtis in full data

gen Psoria_ar=0
foreach v of varlist f_41270_0_0- f_41270_0_212{
recode Psoria_ar 0=1 if strmatch(`v',"*L405*")
}

***Pso arthirtis lung in White

tab Psoria_ar Psoria  if White==1,col 
***Unadjusted in White
foreach v of varlist Obstruction emphysema PHT ILD Pneu Asthma LungC ARDS HPneu Broncho CRD ResF{
tab Psoria_ar `v'  if White==1,col chi2
logistic `v' Psoria_ar if White==1
}
***Adjusted in White
foreach v of varlist Obstruction emphysema PHT ILD Pneu Asthma LungC ARDS HPneu Broncho CRD ResF{
logistic `v' Psoria_ar eversmoker age  Sex if White==1
}


***Pso arthirtis lung in White in Pso patients

**Unadjusted
foreach v of varlist  Obstruction emphysema PHT ILD Pneu Asthma LungC ARDS HPneu Broncho CRD ResF{
tab Psoria_ar `v'  if White==1 & Psoria==1,col chi2
logistic `v' Psoria_ar if White==1 & Psoria ==1 
}
***Adjusted
foreach v of varlist  Obstruction emphysema PHT ILD Pneu Asthma LungC ARDS HPneu Broncho CRD ResF{
logistic `v' Psoria_ar eversmoker age  Sex if White==1 & Psoria ==1 
}



destring f_21002_0_0,gen(weight) force
destring f_21001_0_0,gen(bmi) force
destring f_20161_0_0,gen(packyear) force
tab  Psoria_ar Psoria if White==1,sum(age)
tab  Psoria_ar Psoria if White==1,sum(height)
tab  Psoria_ar Psoria if White==1,sum(weight)
tab  Psoria_ar Psoria if White==1,sum(bmi)
tab  Psoria_ar Psoria if White==1,sum( FEVp )
tab  Psoria_ar Psoria if White==1,sum( FVCp )
tab  Psoria_ar Psoria if White==1,sum( FEV1FVC )
tab  Psoria_ar Psoria if White==1,sum( packyear)
tab currentsmok Psoria_ar  if  Psoria==1 & White==1,col
tab currentsmok   if  Psoria==0 & White==1
tab pastsmok Psoria_ar  if  Psoria==1 & White==1,col
tab   pastsmok  if  Psoria==0 & White==1
tab eversmok Psoria_ar  if  Psoria==1 & White==1,col
tab   eversmok  if  Psoria==0 & White==1
tab Sex Psoria_ar  if  Psoria==1 & White==1,col
tab  Sex  if  Psoria==0 & White==1
***GI

gen Crohn=0
foreach v of varlist f_41270_0_0- f_41270_0_212{
recode Crohn 0=1 if strmatch(`v',"*K50*")
}

gen UC=0
foreach v of varlist f_41270_0_0- f_41270_0_212{
recode UC 0=1 if strmatch(`v',"*K51*")
}

gen Malab=0
foreach v of varlist f_41270_0_0- f_41270_0_212{
recode Malab 0=1 if strmatch(`v',"*K90*")
}


***Unadjusted and adjusted in white 
foreach v of varlist Crohn UC Malab{
foreach i of varlist Obstruction emphysema PHT ILD Pneu Asthma LungC ARDS HPneu Broncho CRD ResF{
tab `i' `v'  if White==1,col chi2
logistic `v' `i'  if White==1
logistic `v' `i'  eversmoker age  Sex if White==1
}
}



***Unadjusted in White
foreach v of varlist Crohn UC Malab{
tab Psoria `v'  if White==1,col chi2
logistic `v' Psoria if White==1
}
***Adjusted in White
foreach v of varlist Crohn UC Malab{
logistic `v' Psoria eversmoker age  Sex if White==1
}



**New genotype Merge

foreach v of varlist s_affy3689595- s_affy28447542{
encode `v',gen(`v'n)
recode `v'n 1=.
}
tab1 s_affy3689595n- s_affy28447542n
rename s_affy3689595n rs1250544
rename s_affy5353131n rs4112788
rename s_affy5658510n rs694739
rename  s_affy8020725n rs4649203
rename  s_affy8216131n rs2066808
rename s_affy12647808n rs10782001
rename s_affy13694673n rs4795067
rename s_affy15521078n rs12720356
rename s_affy16837573n rs495337
rename s_affy19151795n rs181359
rename s_affy20320341n rs702873
rename s_affy25639687n rs20541
rename s_affy25958031n rs2082412
rename s_affy27210786n rs27524
rename s_affy27789069n rs610604
rename s_affy28447542n rs12191877


drop s_affy3689595- s_affy28447542
foreach v of varlist rs1250544- rs12191877 {
tab Psoria `v' if White==1,col
logistic  Psoria i.`v' if White==1
logistic  Psoria i.`v' eversmoker age  Sex if White==1
}


**Pso
foreach v of varlist rs1250544-rs12191877{
logistic Psoria `v' Sex eversmoker age if White==1,r
}
**Emphysema
foreach v of varlist rs1250544-rs12191877{
logistic emphysema `v' Sex eversmoker age if White==1,r
}


***FEV1
qtlsnp rs1250544- rs12191877 ,trait( fev1 )  class(Sex eversmoker) cont(age age2 height) siglev(0.99) detail
***FVC
qtlsnp rs1250544- rs12191877 ,trait( fvc )  class(Sex eversmoker) cont(age age2 height) siglev(0.99) detail
***FEV1/FVC
qtlsnp rs1250544- rs12191877 ,trait( FEV1FVC )  class(Sex eversmoker) cont(age age2 height) siglev(0.99) detail


**genotype  merge 
rename s_affy2656045 rs34944231
rename s_affy2656322 rs61753077
rename s_affy11160751 rs28929474
rename s_affy52246533 rs187920499
rename s_affy85755649 rs113993960

encode rs28929474,gen( rs28929474n)
recode rs28929474n 1=.
tab rs28929474n
tabstat FEV1FVC FEVp FVCp if White==1 ,by(rs28929474n) stat(mean sd)
qtlsnp rs28929474n ,trait( FEV1FVC )  class(Sex eversmoker) cont(age age2 height) siglev(0.99) detail rec
qtlsnp rs28929474n ,trait( FEVp )  class(Sex eversmoker) cont(age age2 height) siglev(0.99) detail rec
qtlsnp rs28929474n ,trait( FVCp )  class(Sex eversmoker) cont(age age2 height) siglev(0.99) detail rec

***Interaction with antitrypsin

recode rs28929474n 4=1 2/3=0,gen( rs28929474r)
tab1 rs34944231 rs61753077 rs113993960 s_affy52246533n
tab1 rs34944231 rs61753077 rs113993960 s_affy52246533n,nolabel
rename s_affy52246533n rs187920499n
encode rs61753077,gen(rs61753077n)
recode rs61753077n 1=.
encode rs113993960 ,gen(rs113993960n )
gen age2=age^2
encode rs34944231,gen(rs34944231n)
recode rs34944231n 1=.
tab1 rs34944231n rs61753077n rs187920499n rs113993960n

***Unadjusted
***FEVp
foreach v of varlist rs34944231n rs61753077n rs187920499n{
reg FEVp rs28929474r##i.`v' if White==1
}
***FVC
foreach v of varlist rs34944231n rs61753077n rs187920499n{
reg FVCp rs28929474r##i.`v' if White==1
}
***FEV1/FVC
foreach v of varlist rs34944231n rs61753077n rs187920499n{
reg FEV1FVC rs28929474r##i.`v' if White==1
}
***Age, sex, smoking adjusted
***FEVp
foreach v of varlist rs34944231n rs61753077n rs187920499n{
reg FEVp rs28929474r##i.`v' age age2 height Sex eversmoker if White==1
}
***FVC
foreach v of varlist rs34944231n rs61753077n rs187920499n{
reg FVCp rs28929474r##i.`v' age age2 height Sex eversmoker if White==1
}
***FEV1/FVC
foreach v of varlist rs34944231n rs61753077n rs187920499n{
reg FEV1FVC rs28929474r##i.`v' age age2 height Sex eversmoker if White==1
}
***tabulation of gene by a-anti gene
foreach v of varlist rs34944231n rs61753077n rs187920499n{
tab `v' rs28929474r if White==1,col chi2
}

***Unadjusted
***COPD
foreach v of varlist rs34944231n rs61753077n rs187920499n{
logistic Obstruction rs28929474r##i.`v' if White==1
}
***Emphysema
foreach v of varlist rs34944231n rs61753077n rs187920499n{
logistic emphysema rs28929474r##i.`v' if White==1
}
***This table shows the frequency of COPD by gene gene tabulation
foreach v of varlist rs34944231n rs61753077n rs187920499n{
tab `v' rs28929474r if White==1,sum( Obstruction ) freq
}
foreach v of varlist rs34944231n rs61753077n rs187920499n{
tab `v' rs28929474r if White==1,sum( Obstruction ) mean
}
***Emphysema
foreach v of varlist rs34944231n rs61753077n rs187920499n{
tab `v' rs28929474r if White==1,sum( emphysema ) mean
}


**Diabetes

f_41270_0_0- f_41270_0_212

gen IDdiab=0
foreach v of varlist f_41270_0_0- f_41270_0_212 {
recode IDdiab 0=1 if strmatch(`v',"*E10*") 
}

gen nonIDdiab=0
foreach v of varlist f_41270_0_0- f_41270_0_212 {
recode nonIDdiab 0=1 if strmatch(`v',"*E11*") 
}

gen diab=0
foreach v of varlist f_41270_0_0- f_41270_0_212 {
recode diab 0=1 if strmatch(`v',"*E10*") | strmatch(`v',"*E11*") | strmatch(`v',"*E12*") | strmatch(`v',"*E13*") | strmatch(`v',"*E14*") 
}

**Summary in white 
tab1 IDdiab nonIDdiab diab  if White==1
***Unadjusted binary in White
foreach v of varlist IDdiab nonIDdiab diab{
foreach i of varlist CRD ILD HPneu Pneu Asthma Sarcoi ResF{	
tab `i' `v'  if White==1,col chi2
logistic  `i' `v'  if White==1
}
}
***Adjusted in White
foreach v of varlist IDdiab nonIDdiab diab{
foreach i of varlist CRD ILD HPneu Pneu Asthma Sarcoi ResF{	
logistic `i' `v' eversmoker age  Sex if White==1
}
}
***Unadjusted and adjuted PFT in White
foreach v of varlist IDdiab nonIDdiab diab{
foreach i of varlist FEV1FVC FEVp FVCp{	
reg  `i' `v'  if White==1
reg `i' `v' eversmoker age  Sex if White==1
}
}

***Additional HBA1C adjustment

***Summary HbA1C
sum f_30750_0_0
***Additional HBA1C Adjusted binary in White
foreach v of varlist IDdiab nonIDdiab diab{
foreach i of varlist CRD ILD HPneu Pneu Asthma Sarcoi ResF{
logistic `i' `v' eversmoker age  Sex f_30750_0_0 if White==1
}
}
***Additional HBA1C Adjusted PFT in White
foreach v of varlist IDdiab nonIDdiab diab{
foreach i of varlist FEV1FVC FEVp FVCp{
reg `i' `v' eversmoker age  Sex f_30750_0_0 if White==1
}
}


***PFT and Hba1c
reg FEV1FVC eversmoker age  Sex f_30750_0_0 if White==1 & f_30750_0_0<=100 & diab==0
logistic Obstruction  eversmoker age  Sex f_30750_0_0 if White==1 & f_30750_0_0<=100 & diab==0
reg FEVp eversmoker age  Sex f_30750_0_0 if White==1 & f_30750_0_0<=100 & diab==0
reg FVCp eversmoker age  Sex f_30750_0_0 if White==1 & f_30750_0_0<=100 & diab==0


***Psoriasis review comment

gen diabm=0
foreach v of varlist f_41270_0_0- f_41270_0_212 {
recode diabm 0=1 if strmatch(`v',"*E10*") | strmatch(`v',"*E11*") | strmatch(`v',"*E12*") | strmatch(`v',"*E13*") | strmatch(`v',"*E08*") | strmatch(`v',"*E09*")
}
set logtype text

***Frequency of diabestes mellitus in white
tab diabm if  White==1 & Psoria!=.
***Summary weigth
sum weight if  White==1 & Psoria!=.
***ADjusted logistic models for additonal weight and diabetes mellitus
foreach v of varlist Pneu ARDS Asthma emphysema Broncho Obstruction PHT ILD   LungC  {
logistic `v' Psoria eversmoker age  Sex diabm weight if White==1
}



***New SNP 


**Frequency table 
tab1 rs72635708- rs7029094 if !missing(FEV1)

***FEV1
qtlsnp rs72635708- rs7029094 ,trait( FEV1 )  class(Sex eversmoker) cont(age age2 height) siglev(0.99) detail

**FVC 
qtlsnp rs72635708- rs7029094 ,trait( FVC )  class(Sex eversmoker) cont(age age2 height) siglev(0.99) detail

**FEV1/FVC 
qtlsnp rs72635708- rs7029094 ,trait( FEV1FVC )  class(Sex eversmoker) cont(age age2 height) siglev(0.99) detail

***FEV1%
qtlsnp rs72635708- rs7029094 ,trait( FEVp )  class(Sex eversmoker) cont(age age2 height) siglev(0.99) detail

***FVC%
qtlsnp rs72635708- rs7029094 ,trait( FVCp )  class(Sex eversmoker) cont(age age2 height) siglev(0.99) detail



**New genotype Psoriasis 8 31 2023

***Frequency of SNP by Psoria
foreach v of varlist  rs72635708- rs7029094{
tab Psoria `v'  if White==1,row
}
***Additive effect on Psor unadjusted and adjusted
foreach v of varlist  rs72635708- rs7029094{
logistic Psoria `v'  if White==1,r
logistic Psoria `v' Sex eversmoker age if White==1,r
}
***Effect of heter and homo vs wild on Psor unadjusted and adjusted
foreach v of varlist  rs72635708- rs7029094{
logistic Psoria i.`v'  if White==1,r
logistic Psoria i.`v' Sex eversmoker age if White==1,r
}
