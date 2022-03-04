clear;
load('config.mat');
addpath(genpath(Utildir));
Mypool = parpool('local',6);
parfor i = 1:total_subs
    for sess = 1:str2num(total_sess)
           CBIG_ArealMSHBM_generate_profiles(seed_mesh,targ_mesh,out_dir,num2str(i),num2str(sess),0);
    end
    disp(i);
end
delete(Mypool);
