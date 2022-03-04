clear;clc;
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/Single_parcellation_FC_Variability/Functions'));
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/Single_parcellation_FC_Variability/Functions'));
root_dir = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/SingleParcellation_Kong_HCPD_rp2';
file_name = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/motion_data/task_and_rest_motion_valid_sub.csv';
sub_motion_valide_all= readtable(file_name);
sub_motion_valide_all = sub_motion_valide_all.subject;
data_all = numel(sub_motion_valide_all);
OUT_DIR = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HCPD_single_parcel';
%% between subject variability based on 4 run datasets
clear sub_std
mkdir([OUT_DIR,filesep,'inter_variability']);
for run = 1:4
    parfor s=1:data_all  % for each subject
        sub = ['sub-' sub_motion_valide_all{s}];
        subname = [root_dir '/ind_parcel_400_4run/' sub filesep 'data_pacel.mat'];    
        subdata_all_run = load(subname);subdata_all_run = subdata_all_run.data_pacel;
        subdata = subdata_all_run{run}; 
        ind_sub = squeeze(subdata(2:401,:));
        z_corr_data = atanh(corr(ind_sub'));
        sub_std(s,:) = convet_matrix_to_vector(z_corr_data);
        subname
    end
    inter_variability(run,:) = std(sub_std,1);
    inter_std = squareform(std(sub_std,1));
     plot_variability_matrix(inter_std,0.22,0.25);
     h = gcf;
     saveas(h, [OUT_DIR,filesep,'inter_variability/','/fig_processed_file_sub',num2str(run),'.jpg'],'jpg');
     close;
    save([OUT_DIR,filesep,'inter_variability/inter_variability_run-',num2str(run),'.mat'],'inter_std');
end
mean_inter_variability = squareform(mean(inter_variability));
plot_variability_matrix(mean_inter_variability,0.18,0.25);
h = gcf;
saveas(h, [OUT_DIR,'/inter_variability.jpg'],'jpg');
close;
save([OUT_DIR '/inter_variability/inter_sub_std.mat'],'mean_inter_variability');
cortex_visualize(mean_inter_variability,[OUT_DIR,'/inter_variability.dscalar.nii']);
