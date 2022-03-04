clear;clc;
load('config.mat');
single_dlabel_dir = [ProjectFolder '/parcel_400_dlabel'];
out_dir = [ProjectFolder '/parcel_400_nii'];
IDs = readtable(idFile);
if ~exist(out_dir)
    mkdir(out_dir);
end
surface_dir = '/GPFS/cuizaixu_lab_permanent/Public_Data/HCPD/rawdata/sMRI_processed_20210514';
total_subs = size(IDs,1);
out_gii = [ProjectFolder '/parcel_400_gii'];
if ~exist(out_gii)
    mkdir(out_gii);
end
parfor n = 1:total_subs
    IDstr = IDs.subject{n};
    %get the single parcel label
    sub_label = [single_dlabel_dir filesep 'Ind_parcellation_MSHBM_sub' num2str(n) '_400.dlabel.nii']; 
    [path,name,exp] = fileparts(sub_label);
    name = strrep(name,'.dlabel','');
    %set up the output name
    out_nii_L = [out_dir filesep name '_L' exp];
    out_nii_R = [out_dir filesep name '_R' exp];
    out_nii_all = [out_dir filesep name '_all' exp];
    % seperate the dlable file
    out_gii_L = [out_gii filesep 'sub-' num2str(n) '_400_ind.L.label.gii'];
    out_gii_R = [out_gii filesep 'sub-' num2str(n) '_400_ind.R.label.gii'];
    
    cmd = ['wb_command -cifti-separate ' sub_label ' COLUMN -label CORTEX_LEFT ' out_gii_L ' -label CORTEX_RIGHT ' out_gii_R];
    unix(cmd);
    % mapping the label file to volume space used by ribbon
    surf_L = [surface_dir filesep IDstr '_V1_MR/MNINonLinear/fsaverage_LR32k/' ...
              IDstr '_V1_MR.L.sphere.32k_fs_LR.surf.gii'];
    surf_R = [surface_dir filesep IDstr '_V1_MR/MNINonLinear/fsaverage_LR32k/' ...
              IDstr '_V1_MR.R.sphere.32k_fs_LR.surf.gii'];
    volume_file = [surface_dir filesep IDstr '_V1_MR/MNINonLinear/T1w_restore.nii.gz'];
    
    white_L = [surface_dir filesep IDstr '_V1_MR/MNINonLinear/fsaverage_LR32k/' ...
              IDstr '_V1_MR.L.white_MSMAll.32k_fs_LR.surf.gii'];
    white_R = [surface_dir filesep IDstr '_V1_MR/MNINonLinear/fsaverage_LR32k/' ...
              IDstr '_V1_MR.R.white_MSMAll.32k_fs_LR.surf.gii'];
          
    pail_L = [surface_dir filesep IDstr '_V1_MR/MNINonLinear/fsaverage_LR32k/' ...
              IDstr '_V1_MR.L.pial_MSMAll.32k_fs_LR.surf.gii'];
    pail_R = [surface_dir filesep IDstr '_V1_MR/MNINonLinear/fsaverage_LR32k/' ...
              IDstr '_V1_MR.R.pial_MSMAll.32k_fs_LR.surf.gii'];  
    %get the left label on volume space
    cmd = ['wb_command -label-to-volume-mapping ' out_gii_L ' ' surf_L ' '...
           volume_file ' ' out_nii_L ' -ribbon-constrained ' white_L ' ' pail_L];
    
    unix(cmd);
    %get the right label on volume space
    cmd = ['wb_command -label-to-volume-mapping ' out_gii_R ' ' surf_R ' '...
           volume_file ' ' out_nii_R ' -ribbon-constrained ' white_R ' ' pail_R];
    
    unix(cmd);
    
    % merge the left and right nii
    cmd = ['fslmaths ' out_nii_L ' -add ' out_nii_R ' ' out_nii_all];
    unix(cmd);
    IDstr
end
