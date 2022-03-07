function []=check_label(nii_name)
% this function check the surface-volume transfor step, the input is a nii data that produced by wb_command -label-to-volume-mapping
data_vol = spm_vol(nii_name);
data_vols = spm_read_vols(data_vol);
data_vols(data_vols>400)=0;
data_vols(data_vols<0)=0;
label_check = unique(data_vols);
    if sum(sum(label_check==[0:400]))==401
        spm_write_vol(data_vol,data_vols)
    else
        disp('labels of this file are wrong');
    end
end
