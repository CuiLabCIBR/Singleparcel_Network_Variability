clear;clc;
load('config.mat');
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/cifti-matlab/'));
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/gifti-master'))
data_all = dir([ProjectFolder '/ind_parcellation_gMSHBM/test_set/10_sess/beta50/Ind_parcellation_MSHBM_*.mat']);
out_dir = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HNU_single_parcel/';
if ~exist(out_dir,'dir')
    mkdir(out_dir);
end
for i = 1:numel(data_all)
    i
    tmp =load([data_all(i).folder filesep data_all(i).name]);
    sbj_Label_lh(i,:) = tmp.lh_labels;
    sbj_Label_rh(i,:) = tmp.rh_labels;
end

for vertex = 1:length(sbj_Label_lh)
    vertex
    for label = 1:400
       %left hemi
       Probability_lh(vertex,label) = length(find(sbj_Label_lh(:,vertex) == label))/total_subs;
       Probability_lh(vertex,label) = Probability_lh(vertex,label) * log2(Probability_lh(vertex,label));
       %right hemi
       Probability_rh(vertex,label) = length(find(sbj_Label_rh(:,vertex) == label))/total_subs;
       Probability_rh(vertex,label) = Probability_rh(vertex,label) * log2(Probability_rh(vertex,label));
    end
    Probability_lh(find(isnan(Probability_lh))) = 0;
    Probability_rh(find(isnan(Probability_rh))) = 0;
    Variability_lh(vertex) = -sum(Probability_lh(vertex,:));
    Variability_rh(vertex) = -sum(Probability_rh(vertex,:));
end
save([out_dir filesep 'Variabiltiy.mat'],'Variability_lh','Variability_rh');