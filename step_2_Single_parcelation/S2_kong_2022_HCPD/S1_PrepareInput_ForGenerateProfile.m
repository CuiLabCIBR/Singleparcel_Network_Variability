clear;clc;
load('config.mat');
system(['rm -rf ' ProjectFolder  '/*']);
mkdir(fMRIListFolder);
mkdir(censorListFolder);
%mkdir(surfaceListFolder)
IDs = table2cell(readtable(idFile));
rest_path = [SubjectsFolder  'rsfMRI/xcp_abcd_rest_no_MSM'];
task_path = [SubjectsFolder  'rsfMRI/xcp_abcd_task_no_MSM'];
addpath(genpath(Ciftidir));
 %% make func file list
for i = 1:total_subs
    ID_Str = IDs{i};
    %%rest1_AP
    FilePath = [fMRIListFolder '/sub' num2str(i) '_sess' num2str(1) '.txt'];
    cmd = ['echo ' rest_path '/sub-' ID_Str '/func/sub-' ID_Str '_task-REST1' ...
           '_acq-AP_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii >> ' FilePath];
    system(cmd);
    %%rest1_PA
    FilePath = [fMRIListFolder '/sub' num2str(i) '_sess' num2str(1) '.txt'];
    cmd = ['echo ' rest_path '/sub-' ID_Str '/func/sub-' ID_Str '_task-REST1' ...
           '_acq-PA_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii >> ' FilePath];
    system(cmd);
    %%rest2_AP
    FilePath = [fMRIListFolder '/sub' num2str(i) '_sess' num2str(2) '.txt'];
    cmd = ['echo ' rest_path '/sub-' ID_Str '/func/sub-' ID_Str '_task-REST2' ...
           '_acq-AP_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii >> ' FilePath];
    system(cmd);
    %%rest2_PA
    FilePath = [fMRIListFolder '/sub' num2str(i) '_sess' num2str(2) '.txt'];
    cmd = ['echo ' rest_path '/sub-' ID_Str '/func/sub-' ID_Str '_task-REST2' ...
           '_acq-PA_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii >> ' FilePath];
    system(cmd);
    %regressed task
    FilePath = [fMRIListFolder '/sub' num2str(i) '_sess' num2str(3) '.txt'];
    cmd = ['echo ' task_path '/sub-' ID_Str '/sub-' ID_Str '_task-CARIT' ...
           '_acq-PA_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii >> ' FilePath];
    system(cmd);
    FilePath = [fMRIListFolder '/sub' num2str(i) '_sess' num2str(3) '.txt'];
    cmd = ['echo ' task_path '/sub-' ID_Str '/sub-' ID_Str '_task-CARIT' ...
           '_acq-AP_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii >> ' FilePath];
    system(cmd);
    FilePath = [fMRIListFolder '/sub' num2str(i) '_sess' num2str(3) '.txt'];
    cmd = ['echo ' task_path '/sub-' ID_Str '/sub-' ID_Str '_task-GUESSING' ...
           '_acq-PA_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii >> ' FilePath];
    system(cmd);
    FilePath = [fMRIListFolder '/sub' num2str(i) '_sess' num2str(3) '.txt'];
    cmd = ['echo ' task_path '/sub-' ID_Str '/sub-' ID_Str '_task-GUESSING' ...
           '_acq-AP_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii >> ' FilePath];
    system(cmd);
    FilePath = [fMRIListFolder '/sub' num2str(i) '_sess' num2str(3) '.txt'];
    cmd = ['echo ' task_path '/sub-' ID_Str '/sub-' ID_Str '_task-EMOTION' ...
           '_acq-PA_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii >> ' FilePath];
    system(cmd);
    i
end

%% make censor list txt
for i = 1:total_subs
    ID_Str = IDs{i};
    %% rest1_AP
    filename = [rest_path '/sub-' ID_Str '/func/sub-' ID_Str '_task-REST1' ...
           '_acq-AP_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii'];
    data = cifti_read(filename);
    censor_vector = ones(size(data.cdata,2),1);
    
    censor_run1 = strrep(filename,'dtseries.nii','txt');
    fid = fopen(censor_run1,'wt');
    fprintf(fid,'%g\n',censor_vector);
    fclose(fid);
    
    FilePath = [censorListFolder '/sub' num2str(i) '_sess' num2str(1) '.txt'];
    cmd = ['echo ' censor_run1 ' >> ' FilePath];
    system(cmd);
    %% rest1 PA
    filename = [rest_path '/sub-' ID_Str '/func/sub-' ID_Str '_task-REST1' ...
           '_acq-PA_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii'];
    data = cifti_read(filename);
    censor_vector = ones(size(data.cdata,2),1);
    %%rest1_LR
    censor_run1 = strrep(filename,'dtseries.nii','txt');
    fid = fopen(censor_run1,'wt');
    fprintf(fid,'%g\n',censor_vector);
    fclose(fid);
    
    FilePath = [censorListFolder '/sub' num2str(i) '_sess' num2str(1) '.txt'];
    cmd = ['echo ' censor_run1 ' >> ' FilePath];
    system(cmd);
    %% rest2 AP
     filename = [rest_path '/sub-' ID_Str '/func/sub-' ID_Str '_task-REST2' ...
           '_acq-AP_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii'];
    data = cifti_read(filename);
    censor_vector = ones(size(data.cdata,2),1);

    censor_run1 = strrep(filename,'dtseries.nii','txt');
    fid = fopen(censor_run1,'wt');
    fprintf(fid,'%g\n',censor_vector);
    fclose(fid);
    
    FilePath = [censorListFolder '/sub' num2str(i) '_sess' num2str(2) '.txt'];
    cmd = ['echo ' censor_run1 ' >> ' FilePath];
    system(cmd);
    %% rest2 PA
     filename = [rest_path '/sub-' ID_Str '/func/sub-' ID_Str '_task-REST2' ...
           '_acq-PA_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii'];
    data = cifti_read(filename);
    censor_vector = ones(size(data.cdata,2),1);

    censor_run1 = strrep(filename,'dtseries.nii','txt');
    fid = fopen(censor_run1,'wt');
    fprintf(fid,'%g\n',censor_vector);
    fclose(fid);
    
    FilePath = [censorListFolder '/sub' num2str(i) '_sess' num2str(2) '.txt'];
    cmd = ['echo ' censor_run1 ' >> ' FilePath];
    system(cmd);
    %% task 
     filename = [task_path '/sub-' ID_Str '/sub-' ID_Str '_task-CARIT' ...
           '_acq-PA_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii'];
    data = cifti_read(filename);
    censor_vector = ones(size(data.cdata,2),1);
    censor_run1 = strrep(filename,'dtseries.nii','txt');
    fid = fopen(censor_run1,'wt');
    fprintf(fid,'%g\n',censor_vector);
    fclose(fid);   
    FilePath = [censorListFolder '/sub' num2str(i) '_sess' num2str(3) '.txt'];
    cmd = ['echo ' censor_run1 ' >> ' FilePath];
    system(cmd);
    
     filename = [task_path '/sub-' ID_Str '/sub-' ID_Str '_task-CARIT' ...
           '_acq-AP_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii'];
    data = cifti_read(filename);
    censor_vector = ones(size(data.cdata,2),1);
    censor_run1 = strrep(filename,'dtseries.nii','txt');
    fid = fopen(censor_run1,'wt');
    fprintf(fid,'%g\n',censor_vector);
    fclose(fid);   
    FilePath = [censorListFolder '/sub' num2str(i) '_sess' num2str(3) '.txt'];
    cmd = ['echo ' censor_run1 ' >> ' FilePath];
    system(cmd);
    
     filename = [task_path '/sub-' ID_Str '/sub-' ID_Str '_task-GUESSING' ...
           '_acq-PA_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii'];
    data = cifti_read(filename);
    censor_vector = ones(size(data.cdata,2),1);
    censor_run1 = strrep(filename,'dtseries.nii','txt');
    fid = fopen(censor_run1,'wt');
    fprintf(fid,'%g\n',censor_vector);
    fclose(fid);   
    FilePath = [censorListFolder '/sub' num2str(i) '_sess' num2str(3) '.txt'];
    cmd = ['echo ' censor_run1 ' >> ' FilePath];
    system(cmd);
    
     filename = [task_path '/sub-' ID_Str '/sub-' ID_Str '_task-GUESSING' ...
           '_acq-AP_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii'];
    data = cifti_read(filename);
    censor_vector = ones(size(data.cdata,2),1);
    censor_run1 = strrep(filename,'dtseries.nii','txt');
    fid = fopen(censor_run1,'wt');
    fprintf(fid,'%g\n',censor_vector);
    fclose(fid);   
    FilePath = [censorListFolder '/sub' num2str(i) '_sess' num2str(3) '.txt'];
    cmd = ['echo ' censor_run1 ' >> ' FilePath];
    system(cmd);
    
     filename = [task_path '/sub-' ID_Str '/sub-' ID_Str '_task-EMOTION' ...
           '_acq-PA_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii'];
    data = cifti_read(filename);
    censor_vector = ones(size(data.cdata,2),1);
    censor_run1 = strrep(filename,'dtseries.nii','txt');
    fid = fopen(censor_run1,'wt');
    fprintf(fid,'%g\n',censor_vector);
    fclose(fid);   
    FilePath = [censorListFolder '/sub' num2str(i) '_sess' num2str(3) '.txt'];
    cmd = ['echo ' censor_run1 ' >> ' FilePath];
    system(cmd);    
  
    disp(i);
end


