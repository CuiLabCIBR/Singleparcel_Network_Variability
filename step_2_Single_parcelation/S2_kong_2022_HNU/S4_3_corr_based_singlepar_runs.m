clear;clc;
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/Single_parcellation_FC_Variability/Functions'));
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/cifti-matlab'));
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/gifti-master'));
load('config.mat');
IDs = readtable(idFile);
IDs = table2cell(IDs);
SubjectsFolder_gii = [ProjectFolder filesep 'func_gii'];
singparcel_dir = [ProjectFolder '/parcel_400_dlabel'];
out_dir_10run = [ProjectFolder '/ind_parcel_400_10run'];
if ~exist(out_dir_10run,'dir')
   mkdir(out_dir_10run);
end
for i = 1:total_subs
    ID_Str = IDs{i};
    sub_parcel = cifti_read([singparcel_dir filesep 'Ind_parcellation_MSHBM_sub' num2str(i) '_400.dlabel.nii']);
    label_vertex = sub_parcel.cdata;
    label = unique(label_vertex);

    for ses_n=1:10 
    % session 
        name_run_L = [SubjectsFolder_gii '/' ID_Str '/' ID_Str ...
               '_task-rest_run-' num2str(ses_n) '.L.func.gii'];

        name_run_R = [SubjectsFolder_gii '/' ID_Str '/' ID_Str ...
               '_task-rest_run-' num2str(ses_n) '.R.func.gii'];

        run1_LR_L = gifti(name_run_L);run1_LR_R = gifti(name_run_R);
        run1_LR = [run1_LR_L.cdata;run1_LR_R.cdata;];


        data_pacel(:,:,ses_n) = compute_mat_base_label(run1_LR,label,label_vertex);

        out_sub = [out_dir_10run filesep ID_Str];
        if ~exist(out_sub)
            mkdir(out_sub);
        end
        save_data([out_sub filesep  'data_pacel.mat'],data_pacel);
    end
    disp(ID_Str);
end
