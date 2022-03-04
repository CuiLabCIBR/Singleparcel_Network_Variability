clear;clc;
load('config.mat');
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/spm12'));
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/code/repeat_code/Single_parcellation_FC_Variability/Functions'));
nii_path = [ProjectFolder '/parcel_400_nii'];
all_nii = dir([nii_path filesep '*all.nii.gz']);
parfor n=1:size(all_nii,1)
    file_nii = [nii_path filesep all_nii(n).name];
    cmd = ['gunzip ' file_nii];
    unix(cmd);
    file_nii_name = strrep(file_nii,'.gz','');
    check_label(file_nii_name);
    n
end


