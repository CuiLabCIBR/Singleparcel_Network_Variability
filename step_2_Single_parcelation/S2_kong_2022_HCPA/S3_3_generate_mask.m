
clear;
load('config.mat');
addpath(genpath(Utildir));
CBIG_ArealMSHBM_avg_profiles(seed_mesh,targ_mesh,out_dir,num2str(total_subs),total_sess);

CBIG_ArealMSHBM_generate_ini_params_Schaefer(seed_mesh, targ_mesh, '400', out_dir);

CBIG_ArealMSHBM_generate_radius_mask_Schaefer('400', mesh, out_dir);

%% use hcp prior data from kong 2022
mkdir([ProjectFolder filesep 'priors']);
mkdir([ProjectFolder filesep 'priors/gMSHBM']);
mkdir([ProjectFolder filesep 'priors/gMSHBM/beta50']);

copyfile(['/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/CBIG/stable_projects/brain_parcellation/' ...
    'Kong2022_ArealMSHBM/lib/group_priors/HCP_fs_LR_32k_40sub/400/gMSHBM/beta50/Params_Final.mat'],[ProjectFolder filesep 'priors/gMSHBM/beta50']);
