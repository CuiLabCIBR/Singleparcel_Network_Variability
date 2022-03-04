clear;clc;
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/cifti-matlab'));
load('config.mat');
IDs = readtable(idFile);
IDs = IDs.subname;
data_root = '/GPFS/cuizaixu_lab_permanent/wuguowei/HNU/xcp_abcd';
out_dir = [ProjectFolder filesep 'func_gii'];
if ~exist(out_dir)
   mkdir(out_dir); 
end

for nsub = 1:size(IDs,1)
    ID_str = IDs{nsub};
    for ses=1:str2double(total_sess)
        run_data = [data_root filesep ID_str '/func/' ID_str '_task-rest_run-' num2str(ses)...
            '_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii'];


        out_sub = [out_dir filesep ID_str];
        if ~exist(out_sub,'dir')
            mkdir(out_sub); 
        end
        out_run_L = [out_sub filesep ID_str '_task-rest_run-' num2str(ses) '.L.func.gii'];
        out_run_R = [out_sub filesep ID_str '_task-rest_run-' num2str(ses) '.R.func.gii'];

        cmd = [wb_command ' -cifti-separate ' run_data ' COLUMN -metric CORTEX_LEFT ' out_run_L...
            ' -metric CORTEX_RIGHT ' out_run_R];
        unix(cmd);
    end
    ID_str
end