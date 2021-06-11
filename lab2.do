gen mkt = mktrf+rf
gen tindex = _n
order tindex
*set tindex to be month time series
tsset tindex, month
*time series has an unique demand tsline that can replace toway scatter
tsline mkt
*set month to string == smonth
tostring(month), gen(smonth)
*transform month to date(identify automatically)
gen td = date(smonth,"YM")
*set td to tm
gen tm = mofd(td)
*tm is how many months from 196001
tsset tm, month
order td tm
*gen the lag of mkt
gen mkt1 = l1.mkt
gen mkt2 = l2.mkt
order mkt*
corr mkt mkt1 mkt2
*using correlation is the same as using covariance; H0 of Prob>Q is corr=0; corrgram can generate 1-40 lag automatically and check their correlation
corrgram mkt
*drop date and generate month
gen month_cal = month(td)
forvalues i = 1(1)25{
	gen p`i'rf = p`i'-rf	
}
forvalues i = 1(1)25{
	quietly reg p`i'rf mktrf
	*matrix list B == display how B looks like
	*beta std alpha std 
	matrix B=e(b)
	matrix V=e(V)
	matrix R=e(r2)
	*_col is just used to lay out the page; beta tprob alpha tprob R-square
	display `i' _col(10) B[1,1] _col(25) tprob(618,B[1,1]/sqrt(V[1,1])) _col(40) B[1,2]   _col(55) tprob(618,B[1,2]/sqrt(V[2,2])) _col(70) R[1,1]
	
}
*matrix T = r(table) == where T[4,1] is pvalue that we can directly call

egen pm1=rowmean(p1 p2 p3 p4 p5)
egen pm2=rowmean(p6 p7 p8 p9 p10)
egen pm3=rowmean(p11 p12 p13 p14 p15)
egen pm4=rowmean(p16 p17 p18 p19 p20)
egen pm5=rowmean(p21 p22 p23 p24 p25)
gen janmktrf=mktrf*jan

*problem 7(2)
forvalues i=1(1)5{
quietly reg pm`i' jan
matrix B722=e(b)
matrix V722=e(V)
display `i' _col(10) B722[1,1] _col(25) tprob(618,B722[1,1]/sqrt(V722[1,1]))
}

*problem 8 
*3 factor
forvalues i = 1(1)25{
	quietly reg p`i'rf mktrf smb hml 
	matrix B81=e(b)
	matrix V81=e(V)
	*_col is just used to lay out the page;constant intercept is the last one in the matrixes; cons t 
	display `i' _col(10) B81[1,4] _col(25) B81[1,4]/sqrt(V81[4,4]) 	
}

*5 factor
forvalues i = 1(1)25{
	quietly reg p`i'rf mktrf smb hml rmw cma
	matrix B82=e(b)
	matrix V82=e(V)
	*_col is just used to lay out the page;constant intercept is the last one in the matrixes; cons t mktrf t
	display `i' _col(10) B82[1,6] _col(25) B82[1,6]/sqrt(V82[6,6]) _col(40) B82[1,1] _col(55) B82[1,1]/sqrt(V82[1,1]) 
}

forvalues i = 1(1)25{
	quietly reg p`i'rf mktrf smb hml rmw cma
	matrix B82=e(b)
	matrix V82=e(V)
	*_col is just used to lay out the page;constant intercept is the last one in the matrixes; smb t hml t
	display `i' _col(10) B82[1,2] _col(25) B82[1,2]/sqrt(V82[2,2]) _col(40) B82[1,3] _col(55) B82[1,3]/sqrt(V82[3,3]) 
}

forvalues i = 1(1)25{
	quietly reg p`i'rf mktrf smb hml rmw cma
	matrix B82=e(b)
	matrix V82=e(V)
	*_col is just used to lay out the page;constant intercept is the last one in the matrixes; rmw t cma t
	display `i' _col(10) B82[1,4] _col(25) B82[1,4]/sqrt(V82[4,4]) _col(40) B82[1,5] _col(55) B82[1,5]/sqrt(V82[5,5]) 
}