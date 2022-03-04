clear;clc;
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/Single_parcellation_FC_Variability/Functions'));
root_dir = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/SingleParcellation_Kong_HCPA/';
sub_motion_valide_all = csvread('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/motion_data/HCP_Adults_motion_valid.csv',1);% only use motion valid subjects
OUT_DIR = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HCPA_single_parcel';
sub_motion_valide_all(sub_motion_valide_all==769064)=[];
sub_motion_valide_all(sub_motion_valide_all==154532)=[];
sub_motion_valide_all(sub_motion_valide_all==966975)=[];%the length of one run for 154532 769064 and 966975 is not sufficient
data_all = size(sub_motion_valide_all,1);
%% between subject variability based on 4 run datasets
clear sub_std
mkdir([OUT_DIR,filesep,'inter_variability']);
for run = 1:4
    parfor s=1:data_all  % for each subject
        sub = ['sub-' num2str(sub_motion_valide_all(s))];
        subname = [root_dir 'ind_parcel_400_4run/' sub filesep 'data_pacel.mat'];    
        subdata = load(subname);subdata = subdata.data_pacel;
        ind_sub = squeeze(subdata(2:401,:,run));
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
