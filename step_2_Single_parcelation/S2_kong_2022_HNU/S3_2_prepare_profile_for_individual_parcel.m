clear;
load('config.mat');
addpath(genpath(Utildir));
profile_list = [ProjectFolder '/profile_list/test_set'];
gradient_folder = [ProjectFolder '/gradients'];
if ~exist(profile_list)
    mkdir(profile_list);
end
system(['rm ' profile_list '/*']);

gradient_list = [ProjectFolder '/gradient_list/test_set'];
if ~exist(gradient_list)
    mkdir(gradient_list);
end
system(['rm ' gradient_list '/*']);

Suffix_profile = '_fs_LR_32k_roifs_LR_900.surf2surf_profile.mat';
Suffix_gradient = 'h_emb_100_distance_matrix.mat';
for i = 1:total_subs
    ID_Str = num2str(i);
        for sess=1:str2double(total_sess)
        % session 
            cmd = ['echo ' ProfileFolder '/sub' ID_Str '/sess' num2str(sess)  '/sub'  ID_Str '_sess' num2str(sess) Suffix_profile...
                    ' >> ' profile_list '/sess' num2str(sess)  '.txt'];
            system(cmd);
        end
        
        cmd = ['echo ' gradient_folder '/sub' ID_Str '/l' Suffix_gradient ' >> ' gradient_list '/gradient_list_lh.txt'];
        system(cmd);
        
        cmd = ['echo ' gradient_folder '/sub' ID_Str '/r' Suffix_gradient ' >> ' gradient_list '/gradient_list_rh.txt'];
        system(cmd);
       i 
end

