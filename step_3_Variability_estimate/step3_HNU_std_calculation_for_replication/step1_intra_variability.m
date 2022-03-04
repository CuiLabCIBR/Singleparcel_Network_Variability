clear;clc;
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/Single_parcellation_FC_Variability/Functions'));
root_dir = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/SingleParcellation_Kong_HNU_rp/ind_parcel_400_10run';
OUT_DIR = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HNU_single_parcel';
sub_name = readtable('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/code/repeat_code/motion_data/HNU_motion_valid_sub.csv');
if ~exist(OUT_DIR,'dir')
    mkdir(OUT_DIR)
end
sub_name = sub_name.subname;
data_all = numel(sub_name);
%% within subject variability based on 10 run dataset
for s=1:data_all  % for each subject
    sub = sub_name{s};
    subname = [root_dir filesep sub filesep 'data_pacel.mat'];    
    subdata = load(subname);subdata = subdata.data_pacel;
    for run = 1:10
        ind_parcel_400 = squeeze(subdata(2:401,:,run));
        z_corr_data = atanh(corr(ind_parcel_400'));
        all_session(run,:) = convet_matrix_to_vector(z_corr_data);
    end
    sub_std(s,:) = std(all_session,1);
    subname
end
all_sub_std = mean(sub_std);
intra_matrix = squareform(all_sub_std);
plot_variability_matrix(intra_matrix,0.16,0.2);
h = gcf;
saveas(h, [OUT_DIR,'/intra_variability.jpg'],'jpg');
close;
if ~exist([OUT_DIR,'/intra_variability/'],'dir')
    mkdir([OUT_DIR,'/intra_variability/'])
end
save([OUT_DIR,'/intra_variability/intra_sub_std.mat'],'intra_matrix');
cortex_visualize(intra_matrix,[OUT_DIR,'/intra_variability.dscalar.nii']);