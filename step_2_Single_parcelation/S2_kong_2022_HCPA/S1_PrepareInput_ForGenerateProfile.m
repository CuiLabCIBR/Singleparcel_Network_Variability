clear;clc;
load('config.mat');
system(['rm -rf ' ProjectFolder  '/*']);
mkdir(fMRIListFolder);
mkdir(censorListFolder);
mkdir(surfaceListFolder);
IDs = csvread(idFile,1);
%%%disp(mfilename('fullpath'));
 %% make func file list
for i = 1:total_subs
    ID_Str = num2str(IDs(i,1));
    %%rest1_LR
    FilePath = [fMRIListFolder '/sub' num2str(i) '_sess' num2str(1) '.txt'];
   % delete(FilePath);
    cmd = ['echo ' SubjectsFolder '/rest_1_xcp_abcd/xcp_abcd/sub-' ID_Str '/func/sub-' ID_Str '_task-REST1' ...
           '_acq-LR_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii >> ' FilePath];
    a(1) = exist([SubjectsFolder '/rest_1_xcp_abcd/xcp_abcd/sub-' ID_Str '/func/sub-' ID_Str '_task-REST1' ...
           '_acq-LR_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii'],'file');
    system(cmd);
    %%rest1_RL
    FilePath = [fMRIListFolder '/sub' num2str(i) '_sess' num2str(1) '.txt'];
   % delete(FilePath);
    cmd = ['echo ' SubjectsFolder '/rest_1_xcp_abcd/xcp_abcd/sub-' ID_Str '/func/sub-' ID_Str '_task-REST1' ...
           '_acq-RL_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii >> ' FilePath];
    system(cmd);
    %%rest2_LR
    FilePath = [fMRIListFolder '/sub' num2str(i) '_sess' num2str(2) '.txt'];
    %delete(FilePath);
    cmd = ['echo ' SubjectsFolder '/rest_2_xcp_abcd/xcp_abcd/sub-' ID_Str '/func/sub-' ID_Str '_task-REST2' ...
           '_acq-LR_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii >> ' FilePath];
    system(cmd);
    %%rest2_RL
    FilePath = [fMRIListFolder '/sub' num2str(i) '_sess' num2str(2) '.txt'];
   % delete(FilePath);
    cmd = ['echo ' SubjectsFolder '/rest_2_xcp_abcd/xcp_abcd/sub-' ID_Str '/func/sub-' ID_Str '_task-REST2' ...
           '_acq-RL_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii >> ' FilePath];
    system(cmd);
    i
end

%% make censor list txt
for i = 1:total_subs
    ID_Str = num2str(IDs(i,1));
    censor_vector = ones(1200,1);
    %%rest1_LR
    censor_run1 = [SubjectsFolder '/rest_1_xcp_abcd/xcp_abcd/sub-' ID_Str '/func/sub-' ID_Str '_task-REST1' ...
           '_acq-LR_space-fsLR_den-91k_desc-residual_smooth_bold_censor.txt'];
    fid = fopen(censor_run1,'wt');
    fprintf(fid,'%g\n',censor_vector);
    fclose(fid);
%     
     FilePath = [censorListFolder '/sub' num2str(i) '_sess' num2str(1) '.txt'];
     %delete(FilePath);
     cmd = ['echo ' censor_run1 ' >> ' FilePath];
     system(cmd);
%     
%     %%rest1_RL
    censor_run2 = [SubjectsFolder '/rest_1_xcp_abcd/xcp_abcd/sub-' ID_Str '/func/sub-' ID_Str '_task-REST1' ...
           '_acq-RL_space-fsLR_den-91k_desc-residual_smooth_bold_censor.txt'];
    fid = fopen(censor_run2,'wt');
    fprintf(fid,'%g\n',censor_vector);
    fclose(fid);

    FilePath = [censorListFolder '/sub' num2str(i) '_sess' num2str(1) '.txt'];
    %delete(FilePath);
    cmd = ['echo ' censor_run2 ' >> ' FilePath];
    system(cmd);
    %%rest2_LR
    censor_run3 = [SubjectsFolder '/rest_2_xcp_abcd/xcp_abcd/sub-' ID_Str '/func/sub-' ID_Str '_task-REST2' ...
           '_acq-LR_space-fsLR_den-91k_desc-residual_smooth_bold_censor.txt'];
    fid = fopen(censor_run3,'wt');
    fprintf(fid,'%g\n',censor_vector);
    fclose(fid);

    FilePath = [censorListFolder '/sub' num2str(i) '_sess' num2str(2) '.txt'];
    %delete(FilePath);
    cmd = ['echo ' censor_run3 ' >> ' FilePath];
    system(cmd);
   %%rest2_RL
    censor_run4 = [SubjectsFolder '/rest_2_xcp_abcd/xcp_abcd/sub-' ID_Str '/func/sub-' ID_Str '_task-REST2' ...
           '_acq-RL_space-fsLR_den-91k_desc-residual_smooth_bold_censor.txt'];
    fid = fopen(censor_run4,'wt');
    fprintf(fid,'%g\n',censor_vector);
    fclose(fid);

    FilePath = [censorListFolder '/sub' num2str(i) '_sess' num2str(2) '.txt'];
    %delete(FilePath);
    cmd = ['echo ' censor_run4 ' >> ' FilePath];
    system(cmd);
    disp(i);
end
%% make surface txt
surface_file_dir = '/GPFS/cuizaixu_lab_permanent/wuguowei/processing/structral';
for i = 1:total_subs
    ID_Str = num2str(IDs(i,1));
    %%rest1_LR
    FilePath = [surfaceListFolder '/lh_sub' num2str(i) '_sess' num2str(1) '.txt'];
    %delete(FilePath);
    cmd = ['echo ' surface_file_dir '/' ID_Str '/MNINonLinear/fsaverage_LR32k/' ID_Str '.L.midthickness.32k_fs_LR.surf.gii >> ' FilePath];
    system(cmd);
    FilePath = [surfaceListFolder '/rh_sub' num2str(i) '_sess' num2str(1) '.txt'];
    %delete(FilePath);
    cmd = ['echo ' surface_file_dir '/' ID_Str '/MNINonLinear/fsaverage_LR32k/' ID_Str '.R.midthickness.32k_fs_LR.surf.gii >> ' FilePath];
    system(cmd);
    
    %%rest1_RL
    FilePath = [surfaceListFolder '/lh_sub' num2str(i) '_sess' num2str(1) '.txt'];
    %delete(FilePath);
    cmd = ['echo ' surface_file_dir '/' ID_Str '/MNINonLinear/fsaverage_LR32k/' ID_Str '.L.midthickness.32k_fs_LR.surf.gii >> ' FilePath];
    system(cmd);
     FilePath = [surfaceListFolder '/rh_sub' num2str(i) '_sess' num2str(1) '.txt'];
     %delete(FilePath);
     cmd = ['echo ' surface_file_dir '/' ID_Str '/MNINonLinear/fsaverage_LR32k/' ID_Str '.R.midthickness.32k_fs_LR.surf.gii >> ' FilePath];
     system(cmd);
%    %%rest2_LR
     FilePath = [surfaceListFolder '/lh_sub' num2str(i) '_sess' num2str(2) '.txt'];
     %delete(FilePath);
     cmd = ['echo ' surface_file_dir '/' ID_Str '/MNINonLinear/fsaverage_LR32k/' ID_Str '.L.midthickness.32k_fs_LR.surf.gii >> ' FilePath];
     system(cmd);
    FilePath = [surfaceListFolder '/rh_sub' num2str(i) '_sess' num2str(2) '.txt'];
     %delete(FilePath);
    cmd = ['echo ' surface_file_dir '/' ID_Str '/MNINonLinear/fsaverage_LR32k/' ID_Str '.R.midthickness.32k_fs_LR.surf.gii >> ' FilePath];
    system(cmd);
    %%rest2_RL
    FilePath = [surfaceListFolder '/lh_sub' num2str(i) '_sess' num2str(2) '.txt'];
    %delete(FilePath);
    cmd = ['echo ' surface_file_dir '/' ID_Str '/MNINonLinear/fsaverage_LR32k/' ID_Str '.L.midthickness.32k_fs_LR.surf.gii >> ' FilePath];
    system(cmd);
    FilePath = [surfaceListFolder '/rh_sub' num2str(i) '_sess' num2str(2) '.txt'];
    %delete(FilePath);
    cmd = ['echo ' surface_file_dir '/' ID_Str '/MNINonLinear/fsaverage_LR32k/' ID_Str '.R.midthickness.32k_fs_LR.surf.gii >> ' FilePath];
   system(cmd);
    i
end
