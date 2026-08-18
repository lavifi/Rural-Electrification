version 19
set more off

* Run once on a machine with internet access. Review installation messages.
ssc install estout, replace
ssc install distinct, replace
ssc install unique, replace
ssc install coefplot, replace
ssc install pretrends, replace
ssc install honestdid, replace
ssc install reghdfe, replace
ssc install boottest, replace

net install csdid2, from("https://friosavila.github.io/stpackages") replace
net install grc1leg, from("https://www.stata.com/users/vwiggins/") replace

* `wildbootstrap` is bundled with current Stata releases. On older supported
* installations, follow Stata's official installation instructions.

display as result "Package installation commands completed."
exit
