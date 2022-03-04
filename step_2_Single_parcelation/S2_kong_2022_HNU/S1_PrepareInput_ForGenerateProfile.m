clear;clc;
load('config.mat');
system(['rm -rf ' ProjectFolder  '/*']);
mkdir(fMRIListFolder);
mkdir(censorListFolder);
mkdir(surfaceListFolder)
IDs = readtable(idFile);
 %%%disp(mfilename('fullpath'));
 %% make func file list
for i = 1:total_subs
    ID_Str = IDs.subname{i};
    for ses_n = 1:10
    %%rest1_LR
        FilePath = [fMRIListFolder '/sub' num2str(i) '_sess' num2str(ses_n) '.txt'];
        cmd = ['echo ' SubjectsFolder '/' ID_Str '/func/' ID_Str '_task-rest_run-' ...
               num2str(ses_n) '_space-fsLR_den-91k_desc-residual_smooth_den-91k_bold.dtseries.nii >> ' FilePath];
        system(cmd);
    end
    %
end

%% make censor list txt
for i = 1:total_subs
    ID_Str = IDs.subname{i};
    censor_vector = ones(300,1);
    for ses_n = 1:10
    %%rest1_LR
        censor_run = [SubjectsFolder '/' ID_Str '/func/' ID_Str '_task-rest' ...
               '_space-fsLR_den-91k_smooth_bold_censor.txt'];
        fid = fopen(censor_run,'wt');
        fprintf(fid,'%g\n',censor_vector);
        fclose(fid);

        FilePath = [censorListFolder '/sub' num2str(i) '_sess' num2str(ses_n) '.txt'];
        cmd = ['echo ' censor_run ' >> ' FilePath];
        system(cmd);
    
    end
    disp(i);
end

