%single parcellation using gMSHBM
clear;
load('config.mat');
cmd{1} = ['addpath(genpath(''' Utildir '''))'];

for i = 1:total_subs
    ID_Str = num2str(i);
    cmd{2} = ['[lh_labels, rh_labels] = CBIG_ArealMSHBM_gMSHBM_generate_individual_parcellation( ''' out_dir ''',''' ...
            mesh ''',''' num2str(2) ''',''' num2str(400) ''',''' ID_Str ''',''' num2str(30) ''',''' ...
            num2str(30) ''',''' num2str(50) ''',' '''test_set'')'];
    fid = fopen(['single_parcel_' ID_Str '.m'],'wt');
    fprintf(fid,'%s\n',cmd{:});
    fclose(fid);
    pause(2)
    system(['sbatch '  'run_single_parcel.sh ' 'single_parcel_' ID_Str]);
   
end
delete('single_parcel_*.m');
