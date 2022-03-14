# Singleparcel_Network_Variability
those scripts are used in Singleparcel Network Variability Project  
# step 1 subject filtering  

we use three datasets including [**HCP_ALL_Adults**](https://www.humanconnectome.org/), [**HCP Development**](https://www.humanconnectome.org/study/hcp-lifespan-development) and [**HNU**](http://fcon_1000.projects.nitrc.org/indi/CoRR/html/hnu_1.html) datasets to test the hypothsis of this study. A motion cutting threshold applied to filter valid subjects for this research:1,if a subject exceeded 1.5 times the interquartile range (in the adverse direction) of the motion(FD_Power, [Power et al., (2014])](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3849338/)) distribution in two or more of these measures, the subject was excluded. the way to filter subjects followed those papers:[Faskowitz, J., Esfahlani, F.Z., Jo, Y. et al(2020)](https://www.nature.com/articles/s41593-020-00719-y#Abs1) and [Sporns, O.,et al. (2021)](https://direct.mit.edu/netn/article/5/2/405/97538). 

