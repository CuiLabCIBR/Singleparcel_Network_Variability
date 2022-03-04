clear;clc;
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/cifti-matlab'));
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/gifti-master'));

load('config.mat');
IDs = readtable(idFile);
IDs = table2cell(IDs);
SubjectsFolder_gii = [ProjectFolder filesep 'func_gii'];
singparcel_dir = [ProjectFolder '/parcel_400_dlabel'];
out_dir_4run = [ProjectFolder '/ind_parcel_400_4run'];
out_dir_8run = [ProjectFolder '/ind_parcel_400_8run'];
if ~exist(out_dir_4run,'dir')
   mkdir(out_dir_8run);
   mkdir(out_dir_4run);
end
task_name = {'REST1';'REST2';'CARIT';'EMOTION';'GUESSING'};
direct_name = {'AP';'PA'};
total_subs = size(IDs,1);
for i = 1:total_subs
    ID_str = ['sub-' IDs{i}];
    n_count=1;
    out_sub_4 = [out_dir_4run filesep ID_str];
    out_sub_8 = [out_dir_8run filesep ID_str];
    
    if ~exist(out_sub_4)
        mkdir(out_sub_4);
        mkdir(out_sub_8)
    end
    if ~exist([out_sub_8 filesep 'data_pacel.mat'],'file') && ~exist([out_sub_4 filesep 'data_pacel.mat'],'file')
        for task = 1:size(task_name)
            task_n = task_name{task};
            for direct = 1:2
               direct_n = direct_name{direct};
               if task==4 && direct==1
                    continue
               else
                    gii_L = [SubjectsFolder_gii filesep ID_str filesep ID_str '_task-' task_n '_' direct_n '.L.func.gii'];
                    gii_R = [SubjectsFolder_gii filesep ID_str filesep ID_str '_task-' task_n '_' direct_n '.R.func.gii'];
                    data_L = gifti(gii_L);data_R = gifti(gii_R);
                    data_run = [data_L.cdata;data_R.cdata;];
                    if n_count ==1
                        all_data = data_run;
                    else
                        all_data = [all_data data_run];
                    end
                    n_count=n_count+1;
               end 
           end
        end

        sub_parcel = cifti_read([singparcel_dir filesep 'Ind_parcellation_MSHBM_sub' num2str(i) '_400.dlabel.nii']);
        label_vertex = sub_parcel.cdata;
        label = unique(label_vertex);

        sess_1 = all_data(:,1:400);sess2 = all_data(:,401:800);sess3 = all_data(:,801:1200);
        sess_4 = all_data(:,1201:1600);sess_5 = all_data(:,1601:2000);sess_6 = all_data(:,2001:2400);
        sess_7 = all_data(:,2401:2800);sess_8 = all_data(:,2801:3200);

        between_sess1 = all_data(:,1:956);between_sess2 = all_data(:,957:1912);
        between_sess3 = all_data(:,1913:2492);between_sess4 = all_data(:,2493:3200);

        data_pacel(:,:,1) = compute_mat_base_label(sess_1,label,label_vertex);
        data_pacel(:,:,2) = compute_mat_base_label(sess2,label,label_vertex);
        data_pacel(:,:,3) = compute_mat_base_label(sess3,label,label_vertex);

        data_pacel(:,:,4) = compute_mat_base_label(sess_4,label,label_vertex);
        data_pacel(:,:,5) = compute_mat_base_label(sess_5,label,label_vertex);
        data_pacel(:,:,6) = compute_mat_base_label(sess_6,label,label_vertex);

        data_pacel(:,:,7) = compute_mat_base_label(sess_7,label,label_vertex);
        data_pacel(:,:,8) = compute_mat_base_label(sess_8,label,label_vertex);

        data_pacel_4run{1} = compute_mat_base_label(between_sess1,label,label_vertex);
        data_pacel_4run{2} = compute_mat_base_label(between_sess2,label,label_vertex);
        data_pacel_4run{3} = compute_mat_base_label(between_sess3,label,label_vertex);
        data_pacel_4run{4} = compute_mat_base_label(between_sess4,label,label_vertex);

        save_data([out_sub_8 filesep 'data_pacel.mat'],data_pacel);
        save_data([out_sub_4 filesep 'data_pacel.mat'],data_pacel_4run);
    end
    disp(ID_str);
end
