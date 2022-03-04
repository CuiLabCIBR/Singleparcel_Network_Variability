clear; 
load('config.mat'); 
addpath(genpath(Utildir)); 
parfor i = 1:total_subs
        CBIG_ArealMSHBM_generate_gradient(mesh,out_dir,num2str(i),total_sess);
end
