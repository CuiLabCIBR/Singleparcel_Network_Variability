clear;clc;
% this script is used to convert the cifti file into gifti file for
% convenient use in next step
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/cifti-matlab'));
load('config.mat');
IDs = csvread(idFile,1);
data_root = '/GPFS/cuizaixu_lab_permanent/wuguowei/processing';
runsname = {'rest_1_xcp_abcd';'rest_2_xcp_abcd';};
out_dir = [ProjectFolder '/func_file'];
if ~exist(out_dir)
   mkdir(out_dir); 
end
Mypool = parpool('local',10);
parfor nsub = 1:size(IDs,1)
    ID_str = ['sub-' num2str(IDs(nsub))];
    for run =1:2
        runLR = [data_root filesep runsname{run} '/xcp_abcd/' ID_str '/func/' ID_str ...
            '_task-REST' num2str(run) '_acq-LR_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii'];
        runRL = [data_root filesep runsname{run} '/xcp_abcd/' ID_str '/func/' ID_str ...
            '_task-REST' num2str(run) '_acq-RL_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii'];
        out_sub = [out_dir filesep ID_str];
        if ~exist(out_sub,'dir')
            mkdir(out_sub); 
        end
        out_run1LR_L = [out_sub filesep ID_str '_task-REST' num2str(run) '_LR.L.func.gii'];
        out_run1LR_R = [out_sub filesep ID_str '_task-REST' num2str(run) '_LR.R.func.gii'];

        out_run1RL_L = [out_sub filesep ID_str '_task-REST' num2str(run) '_RL.L.func.gii'];
        out_run1RL_R = [out_sub filesep ID_str '_task-REST' num2str(run) '_RL.R.func.gii'];
        
        cmd = [wb_command ' -cifti-separate ' runLR ' COLUMN -metric CORTEX_LEFT ' out_run1LR_L ' -metric CORTEX_RIGHT ' out_run1LR_R];
        unix(cmd);
        cmd = [wb_command ' -cifti-separate ' runRL ' COLUMN -metric CORTEX_LEFT ' out_run1RL_L ' -metric CORTEX_RIGHT ' out_run1RL_R];
        unix(cmd);
        ID_str
    end
end
delete(Mypool)