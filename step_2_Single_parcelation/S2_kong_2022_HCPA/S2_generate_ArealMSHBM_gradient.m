clear;
load('config.mat');
addpath(genpath(Utildir));
Mypool = parpool('local',15);

parfor i = 1:total_subs
        CBIG_ArealMSHBM_generate_gradient(mesh,out_dir,num2str(i),num2str(total_sess));
        i
end
delete(Mypool);
