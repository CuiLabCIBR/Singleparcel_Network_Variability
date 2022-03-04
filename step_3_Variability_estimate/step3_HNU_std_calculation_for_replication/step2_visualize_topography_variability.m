clear;clc;
group_dlabel = cifti_read('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/Single_parcel_label/group_label.dlabel.nii');
topo_variability = load('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HNU_single_parcel/Variabiltiy.mat');
whole_cortex = [topo_variability.Variability_lh';topo_variability.Variability_rh';];
for label = 1:400
    tmp_index = find(group_dlabel.cdata==label); 
    mean_variability(label,1) = mean(whole_cortex(tmp_index));
    whole_cortex_new(tmp_index) = mean_variability(label,1);
end
dlabel_tem = cifti_read('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/Yeo2011_17Networks_N1000.dscalar.nii');
dlabel_tem.cdata = whole_cortex_new';
cifti_write(dlabel_tem,'/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HNU_single_parcel/Variabiltiy_topo_final.dscalar.nii');