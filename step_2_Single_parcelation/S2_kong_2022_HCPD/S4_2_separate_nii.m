clear;clc;
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/cifti-matlab'));
load('config.mat');
IDs = readtable(idFile);
IDs = table2cell(IDs);
data_root = '/GPFS/cuizaixu_lab_permanent/Public_Data/HCPD/processed_data/rsfMRI/';
out_dir = [ProjectFolder filesep 'func_gii'];
if ~exist(out_dir)
   mkdir(out_dir); 
end
%Mypool = parpool('local',15);
task_name = {'REST1';'REST2';'CARIT';'EMOTION';'GUESSING'};
direct_name = {'AP';'PA'};
parfor nsub = 1:size(IDs,1)
    ID_str = ['sub-' IDs{nsub}];
    for task = 1:size(task_name)
        task_n = task_name{task};
        if strcmp(task_n(1:4),'REST')
            data_path = [data_root 'xcp_abcd_rest_no_MSM/'];
        else
            data_path = [data_root 'xcp_abcd_task_no_MSM/'];
        end
        for direct = 1:2
            direct_n = direct_name{direct};
            if task==4 && direct==1
                continue
            else
                if strcmp(task_n(1:4),'REST')
                    run_data = [data_path filesep ID_str '/func/' ID_str '_task-' task_n...
                    '_acq-' direct_n '_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii'];
                else
                    run_data = [data_path filesep ID_str filesep ID_str '_task-' task_n...
                    '_acq-' direct_n '_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii'];
                end
                out_sub = [out_dir filesep ID_str];
                if ~exist(out_sub,'dir')
                    mkdir(out_sub); 
                end
                out_run_L = [out_sub filesep ID_str '_task-' task_n '_' direct_n '.L.func.gii'];
                out_run_R = [out_sub filesep ID_str '_task-' task_n '_' direct_n '.R.func.gii'];

                cmd = [wb_command ' -cifti-separate ' run_data ' COLUMN -metric CORTEX_LEFT ' out_run_L...
                    ' -metric CORTEX_RIGHT ' out_run_R];
                unix(cmd);
            end
        end
    end
    ID_str
   
end
delete(Mypool)