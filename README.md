# Singleparcel_Network_Variability
those scripts are used in Singleparcel Network Variability Project，you should add the ` Function` folder into the envoriment of MATLAB for using.  
# step 1, subject filtering  

We use three datasets including [**HCP_ALL_Adults**](https://www.humanconnectome.org/), [**HCP Development**](https://www.humanconnectome.org/study/hcp-lifespan-development) and [**HNU**](http://fcon_1000.projects.nitrc.org/indi/CoRR/html/hnu_1.html) datasets to test the hypothsis of this study. Two motion cutting threshold rules were applied to filter subjects for this research:First,if a subject exceeded 1.5 times the interquartile range (in the adverse direction) of the motion distribution which mesured by FD_Power,[Power et al., (2014)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3849338/), the subject was excluded. Second, individual scans were also excluded if more than 25% of frames exceeded 0.2mm frame-wise displacement(FD_power). The way to filter subjects followed those papers:[Faskowitz, J., Esfahlani, F.Z., Jo, Y. et al(2020)](https://www.nature.com/articles/s41593-020-00719-y#Abs1) and [Sporns, O.,et al. (2021)](https://direct.mit.edu/netn/article/5/2/405/97538).  
  
  
You can run the [step1 Motion Control](https://github.com/zaixulab-CIBR/Singleparcel_Network_Variability/tree/main/step_1_Motion_Control) to choose valid subjects for this study.Finally, 248 subjects in HCPA dataset(for 4 resting fmri runs,total 310 subjects ), 415 subjects(for 4 resting fmri runs and 5 task fmri runs, total 625 subjects) in HCPD dataset and 25 subjects(10 resting fmri runs, total 30 subjects) in HNU dataset were included in futher analysis, however, due to the scan length problem, 3 subjects of HCPA dataset were further excluded.  
  
  # step 2, single parcelation based on individual FC  
   
 Considering the variability between subjects on functional connectivity was mixed from topography and strength of edge, we use a new method that developed from [Kong, R ., et al(2021)](https://doi.org/10.1093/CERCOR/BHAB101), which can allow estimation of individual-specific cortical parcellations based on resting fMRI connectivity. We used a pre-computed group priors of gMSHBM initializated by 400 parcel Schaefer group-level parcellation to guide the individual parcelation, so each particpant got 400 parcel regions for further analysis.  
   
   
 You should run scripts in each folder for different dataset, each folder contains same steps to calculate the individual parcels in fsLR 32k space and transformation nii file in MNI space for whiter matter tractography.  Before you run those scripts below, you should set up computer envoriment for **CBIG** follows by [**Kong2022_ArealMSHBM**](https://github.com/ThomasYeoLab/CBIG/tree/master/stable_projects/brain_parcellation/)
   
   ## step2.1 S0_ConfigPaths_server.m  
   Setting up all default setting，ex: working directory, cifti package directory, gifti package directory and data directory.```you need to noticed that before run this script, you need to Check if your configuration for CBIG works.If you use serve of CIBR, please chech this file to set up the envoriment for CBIG:/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/setup/CBIG_MSHBM_tested_config.sh ``` You will get a ```config.mat``` for further analysis after this step.
   ## step2.2 S1_PrepareInput_ForGenerateProfile.m  
   This script was used to make ```func file list txt,  censor list txt and surface list txt for each subject in each session```(equal to run in this study),those func file list txt contains directory of resting fmri data in fsLR32k space for each subject on specific session, the censor list txt contains a single binary number column with the length equals to the number of time points on each subject, the outliers are indicated by 0s. The outliers will be ignored in generating profiles. And the surface list txt contains midthickness file of structral for gradient generate. ```If you do not censor data, you can leave the censor folder empty. And if you do not have midthickness gii file for each subject, you could also leave the surface folder empty.``` After this step, you would be prepared for running single parcellation.  
   ## step2.3 S2_generate_ArealMSHBM_gradient.m  
  This step generate diffusion embedding matrices for gradients.Details are described [here](https://github.com/ThomasYeoLab/CBIG/tree/master/stable_projects/brain_parcellation/Kong2022_ArealMSHBM#step-0-generate-diffusion-embedding-matrices-for-gradients-optional-for-gmshbm-only).  
  ## step2.4 S3_1_prepare_profile_for_individual_parcel.m  
  ```This step was used to generate txt file for each subject that contains directory of FC gradient file and FC profiles.```  
  ## step2.5 S3_2_generate_profiles.m  
  ```To generate the functional connectivity profiles for each subject based on each resting fMRI session.``` 
  ## step2.6 S3_3_generate_mask.m
  We use the pre-trained group priors of [**Kong2022_ArealMSHBM**](https://github.com/ThomasYeoLab/CBIG/tree/master/stable_projects/brain_parcellation/). So we just copy the group_priors/HCP_fs_LR_32k_40sub/400/gMSHBM/beta50/Params_Final.mat to the right directory.
  ## step2.7 S3_4_individual_pacelation.m  
  ``` Running individual parcellation for each subject by using gMS-HBM method.```
  ## step2.8 S3_5_topgraph_variability  
  Calculating the topgraph variability as same as [Zaixu Cui, et al(2020)](https://www.sciencedirect.com/science/article/pii/S0896627320300556)
  ## step2.9 S4_1_generat_ind_parcel_nii.m
  ``` Generating the dlabel.nii file for each subject based on the results from prior single parcellation.```  
  ## step2.10 S4_2_separate_dtseries.m
  ``` This script is used to convert the cifti file into gifti file for convenient use in next step.```
  ## step2.11 S4_3_corr_based_singlepar_runs.m
  ``` This script is used to calculate the mean timeseries on each parcel for each subject based on single parcellation.```  
  ## step2.12 S5_1_convert_dlabel_nii.m  
  ``` This script is used to convert dlabel file in fsLR32k space into MNI space nii file.``` 
  ## step2.13 S5_2_chekc_label_nii.m 
  ``` We need to check the accuracy of convert step.```   
# Step 3, Variability estimatemation for all datasets.
```In this step, we estimate the intra-subject variability for all three datasets, and then we estimated inter-subject variability, inter-subject variability which regress mean intra-subject variability out for HCPA and HCPD datasets(there only are 25 subjects on HNU dataset).``` This approach followd the way of [**Stoecklein, S.,et al(2020)**](https://www.pnas.org/doi/pdf/10.1073/pnas.1907892117).  
  ## step3.1 step0_calculate_group_label.m  
  ```We used the scheafer 400 group label as the group reference label.```  
  ## step3.2.1 step_1_inra_variability_12run.m
  ```This script is used to calculate the mean intra-subject variability matrix for HCP adults data. We split each session (4 session for each subject) of HCPA resting into three segments to estimate the intra-subject variability for each subject by calculating the standard deviation between 12 segments.And then, the mean intra-subject variability matrix was calculated by average all subject.```
  ## step3.2.2 step_1_inra_variability_8run_all_sub.m
This script is used to calculate the mean intra-subject variability matrix for HCP development data. The task activation model was regressed from three task identification fMRI data [**Fair et al.,(2007b)**](https://www.sciencedirect.com/science/article/pii/S1053811906011773) for “pseudo-resting state” timeseries calculation(detail code information can be found [here](https://github.com/zaixulab-CIBR/utils/wiki/fMRI-process-pipeline:--HCPD_dataset#step3-hcpd-task-fmri-activation-regressor)). The details that how to merge 5 task-regressed-out runs into 4 segments are described in [**here**](https://github.com/zaixulab-CIBR/Singleparcel_Network_Variability/blob/main/step_2_Single_parcelation/S2_kong_2022_HCPD/S4_3_corr_based_singlepar_runs.m).
 ## step3.3 step_2_inter_variability_4run.m  
 ``` This script is used to calculate the mean inter-subject variability matrix across 4 resting runs.We first calculated standard deviation for each session across all subject, and then got the mean inter-subject variability matrix from averaging all standard deviation matrix across 4 sessions.```
 ## step3.4 step_3_inter_regress_intra.m
 ``` This script is used to calculate the mean inter-subject variability matrix which regress mean intra-subject variability (for sample reference, the inter-subject variability matrix mentioned on below all refered to this matrix). Specificlly, a liner model was built to estimate the contribution from mean intra-subject variability to inter-subject variability for each session, and then, we averaged  residuals of liner model from 4 sessions for the final inter-subject variability matrix calculation.```  
 ## step3.5 step3_plot_figure_for_each_dataset
 ``` Running those scripts to plot figure 1.```  
   
 # step 4,  Correlate the Gene map with the inter-subject variability matrix of FC.  
 ## step4.1 Step_1_create_scheafer_400to_yeo_gene.m
 We use the Gene map which calculated by [**Krienen, F. M., Yeo, B. T. T., Ge, T., Buckner, R. L., & Sherwood, C. C. (2016)**](https://www.pnas.org/doi/10.1073/pnas.1510903113). At first, we need to align this map to our group parcellation atlas. ```The yeo 17 label atlas was used for the PNAS paper, and the cheafer 400 group label was used in this study.```
## step4.2 Step_2_corr_gene_and_FC_variability_HCPA.m
``` Correlate the Gene map with the inter-subject variability matrix of HCPA data. ```  
## step4.3 Step_3_corr_gene_and_FC_variability_HCPD.m
``` Correlate the Gene map with the inter-subject variability matrix of HCPD data. ``` 
## step4.4 corr_data.Rmd
``` Plot figure2 ```   
# step 5,  Correlate the Structral connectivity map with the inter-subject variability matrix of FC. 
we use Qsiprep to build structral connectivity map for each subject, and the [**mrtrix_multishell_msmt_ACT-hsvs**](https://qsiprep.readthedocs.io/en/latest/reconstruction.html#mrtrix-multishell-msmt-act-hsvs) method were used. Whole cortex was segemented into 400 regions based on our single parcellation results. The Structral connectivity process steps were discribed in [**here**](https://github.com/zaixulab-CIBR/dMRI_processing).
## step5.1 step_1_HCPA_SC_FC_couping.m  
``` Correlate the Structral connectivity map which weighted by streamline counts with the inter-subject variability matrix of HCPA data. Finally, 233 subjects were included on constraction of the mean structral connectivity map on HCPA dataset, 12 subjects were exculded beacause of losting dMRI data or transformation error.```
## step5.2 step_1_HCPD_SC_FC_couping.m  
``` Correlate the Structral connectivity map which weighted by streamline counts with the inter-subject variability matrix of HCPD data. Finally, 410 subjects were included on constraction of the mean structral connectivity map on HCPA dataset, 5 subjects were exculded beacause of losting dMRI data or transformation error.```
## step5.3 sc_fc_corr.Rmd  
``` Plot figure3 ```   
# step 6, Variability estimation for Age Effects  
We estimated the age effects on FC variability through HCPD dataset. Age groups include 8-10 year olds (n=57), 14-16 year olds (n=165), and 19-21 year olds (n=128) were chosen to estimate the age effects on FC variability.  
 ## step6.1 step_1_inra_variability_8run.m
 ``` This script is used to calculate the mean intra-subject variability matrix for each age group from HCPD data.```
  ## step6.2 step_2_inter_variability_4run.m
 ``` This script is used to calculate the mean inter-subject variability matrix for each age group from HCPD data.```
  ## step6.3 step_3_inter_regress_intra.m
 ``` This script is used to calculate the mean intra-subject variability matrix which regress intra-subject variability out for each age group from HCPD data.```
  ## step6.4 step4_age_effects.m
  ``` This script is used to calculate the within-network and between-network variability on each network based on yeo-7network parcellation scheme.```
  ## step6.5  plot_variability_for_dmn.Rmd
  ``` This script is used to plot the variability for connections between each network and DMN.```
  ## step6.6  plot_variability_for_within_and_between_network.R
  ``` This script is used to plot the within-network and between-network variability for each network.```

