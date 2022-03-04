clear;clc;
%% we use the scheafer group label as the group reference label
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/cifti-matlab'))
group_data_name = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/SingleParcellation_Kong_HCPA/group/group.mat';
dlabel_tem = cifti_read('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/Yeo2011_17Networks_N1000.dlabel.nii');
dlabel = cifti_read(['/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/Yeo2011_7Networks_N1000.dlabel.nii']);
dlabel_table = dlabel.diminfo{1,2}.maps.table;
yeo_label_tabel = {dlabel_table.rgba};
yeo_label_all = dlabel.cdata;
yeo_label = unique(yeo_label_all);
for label = 1:length(yeo_label)  
     yeo_label_vertex{label,1} = yeo_label(label);
     yeo_label_vertex{label,2} = find(yeo_label_all==yeo_label(label));
end
out_dir = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/Single_parcel_label/';
if ~exist(out_dir)
    mkdir(out_dir);
end

load(group_data_name);
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
    if ver==29
        real_yeo_label = 8;
    end
    new_tabel(ver).name = ['singleparcel_net_0',num2str(sub_lable(ver))];
    new_tabel(ver).key = sub_lable(ver);
    new_tabel(ver).rgba = yeo_label_tabel{real_yeo_label}';
end
dlabel_tem.cdata(1:32492,1) = lh_labels;
dlabel_tem.cdata(32493:64984,1) = rh_labels;
dlabel_tem.diminfo{1,2}.maps.table = new_tabel;
out_name = [out_dir '/group_label.dlabel.nii'];
cifti_write(dlabel_tem,out_name);

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
    if ver==29
        real_yeo_label = 8;
    end
    new_tabel(ver).name = ['singleparcel_net_0',num2str(sub_lable(ver))];
    new_tabel(ver).key = sub_lable(ver);
    new_tabel(ver).rgba = yeo_label_tabel{real_yeo_label}';
    new_tabel(ver).yeolabel = real_yeo_label-1;
end
save([out_dir '/7_net_group_tabel.mat'],'new_tabel');
