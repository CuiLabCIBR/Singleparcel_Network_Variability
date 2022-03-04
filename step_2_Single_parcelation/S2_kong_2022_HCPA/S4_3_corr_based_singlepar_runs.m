clear;clc;
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/cifti-matlab'));
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/gifti-master'));
load('config.mat');
IDs = csvread(idFile,1);
SubjectsFolder = [ProjectFolder '/func_file'];
singparcel_dir = [ProjectFolder '/parcel_400_dlabel'];
out_dir=[ProjectFolder '/ind_parcel_400_12run'];
if ~exist(out_dir,'dir')
   mkdir(out_dir); 
end
total_subs = size(IDs,1);
for i = 1:total_subs
    ID_Str = num2str(IDs(i,1));
    % session 1 contains two runs, REST1 LR and RL
    name_run1_LR_L = [SubjectsFolder '/sub-' ID_Str '/sub-' ID_Str ...
           '_task-REST1_LR.L.func.gii'];
       
    name_run1_LR_R = [SubjectsFolder '/sub-' ID_Str '/sub-' ID_Str ...
           '_task-REST1_LR.R.func.gii'];
       
    name_run1_RL_L = [SubjectsFolder '/sub-' ID_Str '/sub-' ID_Str ...
           '_task-REST1_RL.L.func.gii'];
       
    name_run1_RL_R = [SubjectsFolder '/sub-' ID_Str '/sub-' ID_Str ...
           '_task-REST1_RL.R.func.gii'];
    
    %rest2 contains two runs
    name_run2_LR_L = [SubjectsFolder '/sub-' ID_Str '/sub-' ID_Str ...
           '_task-REST2_LR.L.func.gii'];
       
    name_run2_LR_R = [SubjectsFolder '/sub-' ID_Str '/sub-' ID_Str ...
           '_task-REST2_LR.R.func.gii'];
       
    name_run2_RL_L = [SubjectsFolder '/sub-' ID_Str '/sub-' ID_Str ...
           '_task-REST2_RL.L.func.gii'];
       
    name_run2_RL_R = [SubjectsFolder '/sub-' ID_Str '/sub-' ID_Str ...
           '_task-REST2_RL.R.func.gii'];
       
     
    run1_LR_L = gifti(name_run1_LR_L);run1_LR_R = gifti(name_run1_LR_R);
    run1_LR = [run1_LR_L.cdata;run1_LR_R.cdata;];
    
    run1_RL_L = gifti(name_run1_RL_L);run1_RL_R = gifti(name_run1_RL_R);
    run1_RL = [run1_RL_L.cdata;run1_RL_R.cdata;];
    
    run2_LR_L = gifti(name_run2_LR_L);run2_LR_R = gifti(name_run2_LR_R);
    run2_LR = [run2_LR_L.cdata;run2_LR_R.cdata;];
    
    run2_RL_L = gifti(name_run2_RL_L);run2_RL_R = gifti(name_run2_RL_R);
    run2_RL = [run2_RL_L.cdata;run2_RL_R.cdata;];

    sub_parcel = cifti_read([singparcel_dir filesep 'Ind_parcellation_MSHBM_sub' num2str(i) '_400.dlabel.nii']);
    label_vertex = sub_parcel.cdata;
    label = unique(label_vertex);
    
    run1_sess1_LR = run1_LR(:,1:400);run1_sess2_LR = run1_LR(:,401:800);run1_sess3_LR = run1_LR(:,801:end);
    run1_sess1_RL = run1_RL(:,1:400);run1_sess2_RL = run1_RL(:,401:800);run1_sess3_RL = run1_RL(:,801:end);
    run2_sess1_LR = run2_LR(:,1:400);run2_sess2_LR = run2_LR(:,401:800);run2_sess3_LR = run2_LR(:,801:end);
    run2_sess1_RL = run2_RL(:,1:400);run2_sess2_RL = run2_RL(:,401:800);run2_sess3_RL = run2_RL(:,801:end);
    
    data_pacel(:,:,1) = compute_mat_base_label(run1_sess1_LR,label,label_vertex);
    data_pacel(:,:,2) = compute_mat_base_label(run1_sess2_LR,label,label_vertex);
    data_pacel(:,:,3) = compute_mat_base_label(run1_sess3_LR,label,label_vertex);
    
    data_pacel(:,:,4) = compute_mat_base_label(run1_sess1_RL,label,label_vertex);
    data_pacel(:,:,5) = compute_mat_base_label(run1_sess2_RL,label,label_vertex);
    data_pacel(:,:,6) = compute_mat_base_label(run1_sess3_RL,label,label_vertex);
    
    data_pacel(:,:,7) = compute_mat_base_label(run2_sess1_LR,label,label_vertex);
    data_pacel(:,:,8) = compute_mat_base_label(run2_sess2_LR,label,label_vertex);
    data_pacel(:,:,9) = compute_mat_base_label(run2_sess3_LR,label,label_vertex);
    
    data_pacel(:,:,10) = compute_mat_base_label(run2_sess1_RL,label,label_vertex);
    data_pacel(:,:,11) = compute_mat_base_label(run2_sess2_RL,label,label_vertex);
    data_pacel(:,:,12) = compute_mat_base_label(run2_sess3_RL,label,label_vertex);
    
    out_sub = [out_dir filesep 'sub-' ID_Str];
    if ~exist(out_sub)
        mkdir(out_sub);
    end
    save_data([out_sub filesep 'data_pacel.mat'],data_pacel);
    disp(ID_Str);
end
%% calculate for 4 runs
clear;clc;
load('config.mat');
IDs = csvread(idFile,1);
SubjectsFolder = [ProjectFolder '/func_file'];
singparcel_dir = [ProjectFolder '/parcel_400_dlabel'];
out_dir = [ProjectFolder '/ind_parcel_400_4run'];
if ~exist(out_dir,'dir')
   mkdir(out_dir); 
end
out_num = 1;
for i = 1:total_subs
    
    ID_Str = num2str(IDs(i,1));
    % session 1 contains two runs, REST1 LR and RL
    name_run1_LR_L = [SubjectsFolder '/sub-' ID_Str '/sub-' ID_Str ...
           '_task-REST1_LR.L.func.gii'];
       
    name_run1_LR_R = [SubjectsFolder '/sub-' ID_Str '/sub-' ID_Str ...
           '_task-REST1_LR.R.func.gii'];
       
    name_run1_RL_L = [SubjectsFolder '/sub-' ID_Str '/sub-' ID_Str ...
           '_task-REST1_RL.L.func.gii'];
       
    name_run1_RL_R = [SubjectsFolder '/sub-' ID_Str '/sub-' ID_Str ...
           '_task-REST1_RL.R.func.gii'];
    
    %rest2 contains two runs
    name_run2_LR_L = [SubjectsFolder '/sub-' ID_Str '/sub-' ID_Str ...
           '_task-REST2_LR.L.func.gii'];
       
    name_run2_LR_R = [SubjectsFolder '/sub-' ID_Str '/sub-' ID_Str ...
           '_task-REST2_LR.R.func.gii'];
       
    name_run2_RL_L = [SubjectsFolder '/sub-' ID_Str '/sub-' ID_Str ...
           '_task-REST2_RL.L.func.gii'];
       
    name_run2_RL_R = [SubjectsFolder '/sub-' ID_Str '/sub-' ID_Str ...
           '_task-REST2_RL.R.func.gii'];
       
     
    run1_LR_L = gifti(name_run1_LR_L);run1_LR_R = gifti(name_run1_LR_R);
    run1_LR = [run1_LR_L.cdata;run1_LR_R.cdata;];
    
    run1_RL_L = gifti(name_run1_RL_L);run1_RL_R = gifti(name_run1_RL_R);
    run1_RL = [run1_RL_L.cdata;run1_RL_R.cdata;];
    
    run2_LR_L = gifti(name_run2_LR_L);run2_LR_R = gifti(name_run2_LR_R);
    run2_LR = [run2_LR_L.cdata;run2_LR_R.cdata;];
    
    run2_RL_L = gifti(name_run2_RL_L);run2_RL_R = gifti(name_run2_RL_R);
    run2_RL = [run2_RL_L.cdata;run2_RL_R.cdata;];

    sub_parcel = cifti_read([singparcel_dir filesep 'Ind_parcellation_MSHBM_sub' num2str(i) '_400.dlabel.nii']);
    label_vertex = sub_parcel.cdata;
    label = unique(label_vertex);
    if size(run1_LR,2)==1200 &&  size(run1_LR,2)==1200  && size(run1_LR,2)==1200  && size(run1_LR,2)==1200 
        data_pacel(:,:,1) = compute_mat_base_label(run1_LR,label,label_vertex);
        data_pacel(:,:,2) = compute_mat_base_label(run1_RL,label,label_vertex);
        data_pacel(:,:,3) = compute_mat_base_label(run2_LR,label,label_vertex);
        data_pacel(:,:,4) = compute_mat_base_label(run2_RL,label,label_vertex);

        out_sub = [out_dir filesep 'sub-' ID_Str];
        if ~exist(out_sub)
            mkdir(out_sub);
        end
        save_data([out_sub filesep 'data_pacel.mat'],data_pacel);
        
        
        
    else
        invalid_sub{out_num} = ID_Str;
        out_num = out_num +1 ;
    end
    disp(ID_Str);
end

