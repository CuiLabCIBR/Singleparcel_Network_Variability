clear;clc;
%% this script is used to calculate the mean variability matrix for HCP adults data
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/Single_parcellation_FC_Variability/Functions'));
root_dir = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/SingleParcellation_Kong_HCPA';
sub_motion_valide_all = csvread('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/motion_data/HCP_Adults_motion_valid.csv',1);% only use motion valid subjects
OUT_DIR = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HCPA_single_parcel';
if ~exist(OUT_DIR,'dir')
    mkdir(OUT_DIR)
end
sub_motion_valide_all(sub_motion_valide_all==769064)=[];
sub_motion_valide_all(sub_motion_valide_all==154532)=[];
sub_motion_valide_all(sub_motion_valide_all==966975)=[];%the length of one run for 154532 769064 and 966975 is not sufficient
data_all = size(sub_motion_valide_all,1);
%% within subject variability based on 12 run dataset
Mypool = parpool('local',12);
for s=1:data_all  % for each subject
        sub = ['sub-' num2str(sub_motion_valide_all(s))];
        subname = [root_dir '/ind_parcel_400_12run/' sub filesep 'data_pacel.mat'];    
        subdata = load(subname);subdata = subdata.data_pacel;
        parfor run = 1:12
            ind_parcel_400 = squeeze(subdata(2:401,:,run));
            z_corr_data = atanh(corr(ind_parcel_400'));
            all_session(run,:) = convet_matrix_to_vector(z_corr_data);
        end
        sub_std(s,:) = std(all_session,1);
        subname
end
all_sub_std = mean(sub_std);
intra_matrix = squareform(all_sub_std);
plot_variability_matrix(intra_matrix,0.18,0.25);
h = gcf;
saveas(h, [OUT_DIR,'/intra_variability.jpg'],'jpg');
close;
if ~exist([OUT_DIR,'/intra_variability/'],'dir')
    mkdir([OUT_DIR,'/intra_variability/'])
end
save([OUT_DIR,'/intra_variability/intra_sub_std.mat'],'intra_matrix');
cortex_visualize(intra_matrix,[OUT_DIR,'/intra_variability.dscalar.nii']);