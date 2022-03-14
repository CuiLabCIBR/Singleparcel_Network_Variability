# Singleparcel_Network_Variability
those scripts are used in Singleparcel Network Variability Project  
# step 1, subject filtering  

We use three datasets including [**HCP_ALL_Adults**](https://www.humanconnectome.org/), [**HCP Development**](https://www.humanconnectome.org/study/hcp-lifespan-development) and [**HNU**](http://fcon_1000.projects.nitrc.org/indi/CoRR/html/hnu_1.html) datasets to test the hypothsis of this study. Two motion cutting threshold rules were applied to filter subjects for this research:First,if a subject exceeded 1.5 times the interquartile range (in the adverse direction) of the motion distribution which mesured by FD_Power,[Power et al., (2014)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3849338/), the subject was excluded. Second, individual scans were also excluded if more than 25% of frames exceeded 0.2mm frame-wise displacement(FD_power). The way to filter subjects followed those papers:[Faskowitz, J., Esfahlani, F.Z., Jo, Y. et al(2020)](https://www.nature.com/articles/s41593-020-00719-y#Abs1) and [Sporns, O.,et al. (2021)](https://direct.mit.edu/netn/article/5/2/405/97538).  
  
  
You can run the [step1 Motion Control](https://github.com/zaixulab-CIBR/Singleparcel_Network_Variability/tree/main/step_1_Motion_Control) to choose valid subjects for this study.Finally, 248 subjects in HCPA dataset(for 4 resting fmri runs), 415 subjects(for 4 resting fmri runs and 5 task fmri runs) in HCPD dataset and 25 subjects(10 resting fmri runs) in HNU dataset were included in futher analysis, however, due to the scan length problem, 3 subjects of HCPA dataset were further excluded.  
  
  # step 2, single parcelation based on individual FC  
   
 Considering the variability between subjects on functional connectivity was mixed from topography and strength of edge, we use a new method that developed from [Kong, R ., et al(2021)](https://doi.org/10.1093/CERCOR/BHAB101), which can allow estimation of individual-specific cortical parcellations based on resting fMRI connectivity. We used a pre-computed group priors of gMSHBM initializated by 400 parcel Schaefer group-level parcellation to guide the individual parcelation, so each particpant got 400 parcel regions for further analysis.  
   
   
 You should run scripts in each folder for different dataset, each folder contains same steps to calculate the individual parcels in fsLR 32k space and transformation nii file in MNI space for whiter matter tractography.

