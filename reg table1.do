clear
import delimited "D:\Computing\ART Class\dataC.csv"
gen y1 = year - 2009
gen y2 = y1^2
gen y3 = y1^3
gen news_2 = news_st^2
gen censor = 1 if news_st==0
replace censor = 0 if censor ==.
//Main
quiet reg car_st settlefund, robust
est store r1
quiet reg car_st settlefund car_ce ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket, robust
est store r2
quiet reg car_st settlefund news_st car_ce ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket, robust
est store r3
quiet reg car_st settlefund news_st car_ce ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket y1 y2 y3, robust
est store r4
quiet reg car_st settlefund news_st car_ce ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket y1 y2 y3 manufacture tmt trade service , robust
est store r5
outreg2 [r1 r2 r3 r4 r5] using tr, tex(frag)  bdec(3)  sdec(3)  drop( y1 y2 y3 service trade tmt manufacture)
est stat r*

//Outliers
quiet robreg m car_st settlefund news_st car_ce ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket, robust
est store rr1
quiet robreg s car_st settlefund news_st car_ce ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket , robust
est store rr2
quiet robreg mm car_st settlefund news_st car_ce ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket, robust
est store rr3
quiet robreg mm car_st settlefund news_st car_ce ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket y1 y2 y3 manufacture tmt trade service , robust
est store rr4
outreg2 [rr1 rr2 rr3 rr4] using trr, tex(frag)  bdec(3)  sdec(3)  drop( y1 y2 y3 service trade tmt manufacture )
est stat r**
//Censor
quiet reg news_st news_ce setp_ce lgap ebit_st size_st debtratio_st m2b_st accounting financialmarket,r
est store c1
quiet tobit news_st news_ce setp_ce lgap ebit_st size_st debtratio_st m2b_st accounting financialmarket,r ll(0)
predict news_pd
gen news_pd_2 = news_pd^2
est store c2
quiet tobit news_st news_ce setp_ce lgap ebit_st size_st debtratio_st m2b_st m2b_st accounting financialmarket y1 y2 y3 manufacture tmt trade service ,r ll(0)
est store c3
est stat c*
outreg2 [c1 c2 c3] using tc1, tex(frag)  bdec(3)  sdec(3)  drop( y1 y2 y3 service trade tmt manufacture )
// Modified news
quiet reg car_st settlefund news_pd car_ce ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket, r
est store rc1
quiet robreg mm car_st settlefund news_pd car_ce ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket, robust
est store rc2
quiet robreg mm car_st settlefund news_pd car_ce ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket y1 y2 y3, robust
est store rc3
quiet robreg mm car_st settlefund news_pd car_ce ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket y1 y2 y3 manufacture tmt trade service, robust
est store rc4
est stat rc*
outreg2 [rc1 rc2 rc3 rc4] using trc, tex(frag)  bdec(3)  sdec(3)  drop( y1 y2 y3 service trade tmt manufacture )
//cross
crossfold reg car_st settlefund car_ce news_st ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket, robust
crossfold reg car_st settlefund car_ce news_st ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket y1 y2 y3, robust
crossfold reg car_st settlefund car_ce news_st ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket y1 y2 y3 manufacture tmt trade service, robust
crossfold robreg mm car_st settlefund car_ce news_st ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket, robust
crossfold robreg mm car_st settlefund car_ce news_st ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket y1 y2 y3, robust
crossfold robreg mm car_st settlefund car_ce news_st ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket y1 y2 y3 manufacture tmt trade service , robust
crossfold robreg mm car_st settlefund car_ce news_pd ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket, robust
crossfold robreg mm car_st settlefund car_ce news_pd ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket y1 y2 y3, robust
crossfold robreg mm car_st settlefund car_ce news_pd ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket y1 y2 y3 manufacture tmt trade service, robust
// IV
quiet reg settlefund lgap mkvalt_ce m2b_ce ebit_ce inst_pct news_ce, r
est store iv1
quiet ivregress 2sls news_st car_st car_ce ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket y1 y2 y3 service trade tmt manufacture (settlefund = lgap mkvalt_ce m2b_ce ebit_ce inst_pct news_ce), vce(r)
est store iv2
quiet ivregress gmm car_st news_st car_ce ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket y1 y2 y3 service trade tmt manufacture (settlefund = lgap mkvalt_ce m2b_ce ebit_ce inst_pct news_ce), vce(r)
est store iv3
quiet ivregress gmm car_st news_pd car_ce ebit_st size_st debtratio_st m2b_st abshto accounting financialmarket y1 y2 y3 service trade tmt manufacture (settlefund = lgap mkvalt_ce m2b_ce ebit_ce inst_pct news_ce), vce(r)
est store iv4
outreg2 [iv1 iv2 iv3 iv4] using tiv, tex(frag)  bdec(3)  sdec(3)  drop( y1 y2 y3 service trade tmt manufacture )
