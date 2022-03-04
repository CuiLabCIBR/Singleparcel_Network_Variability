clear;clc;
load('config.mat');
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/cifti-matlab/'));
data_all = dir([ProjectFolder '/ind_parcellation_gMSHBM/test_set/2_sess/beta50/Ind_parcellation_MSHBM_*.mat']);
dlabel_tem = cifti_read('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/code/S1_kong_2022/Yeo2011_17Networks_N1000.dlabel.nii');
dlabel = load('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/CBIG/stable_projects/brain_parcellation/Kong2019_MSHBM/replication/results/HCP/group/group.mat');
yeo_label_tabel = dlabel.colors/255;
yeo_label_all = [dlabel.lh_labels';dlabel.rh_labels';];
yeo_label = unique(yeo_label_all);
for label = 1:length(yeo_label)  
     yeo_label_vertex{label,1} = yeo_label(label);
     yeo_label_vertex{label,2} = find(yeo_label_all==yeo_label(label));
end
out_dir = [ProjectFolder '/parcel_400_dlabel'];
if ~exist(out_dir)
    mkdir(out_dir);
end

for n = 1:size(data_all,1)
    data_name = [data_all(n).folder filesep data_all(n).name];
    load(data_name);   
    all_cortex_label = [lh_labels;rh_labels];
    sub_mask = find(all_cortex_label==0);
    yeo_mask = find(yeo_label_all==0);
    mask = setdiff(yeo_mask,sub_mask);
    sub_lable = unique(all_cortex_label);
    for ver = 1:length(sub_lable)
        real_label = find(all_cortex_label==sub_lable(ver));
        for n_label = 1:length(yeo_label)
            label_all(n_label) = length(intersect(real_label,yeo_label_vertex{n_label,2}));
        end
        real_yeo_label = find(label_all==max(label_all));
        if length(real_yeo_label)>1
            real_yeo_label = real_yeo_label(1);
        end
        new_tabel(ver).name = ['singleparcel_net_0',num2str(sub_lable(ver))];
        new_tabel(ver).key = sub_lable(ver);
        new_tabel(ver).rgba = [yeo_label_tabel(real_yeo_label,:)';1];
    end
    dlabel_tem.cdata(1:32492,1) = lh_labels;
    dlabel_tem.cdata(32493:64984,1) = rh_labels;
    dlabel_tem.diminfo{2}.maps.table = new_tabel;
    out_name = strrep(data_all(n).name,'.mat','.dlabel.nii');
    out_name = strrep(out_name,'_w30_MRF30_beta50','_400');
    out_nii = [out_dir filesep out_name];
    cifti_write(dlabel_tem,out_nii)
    disp(n);
end






