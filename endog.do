use "D:\Computing\ART Class\data ice cream.dta", clear
reg cons price income
reg cons price income temp
ivregress 2sls cons income temp (price = milkprice)
estat endog
ivreg2 cons income temp (price = milkprice)
switchcopula price income temp
