
%
%%% create work environment.
%
clear;clc;
% set up CBIG
system('source ~/DATA/python_code/setup/CBIG_MSHBM_tested_config.sh');

%%% open workdir [CHANGE]
Workdir = '/home/cuizaixu_lab/wuguowei/DATA/python_code';
Codedir = [Workdir '/repeat_code/Single_parcellation_FC_Variability/step_2_Single_parcelation/S2_kong_2022_HNU'];
if ~exist(Codedir)
    mkdir(Codedir);
end
cd(Codedir);

%%% utils: [CHANGE]
matlab = '/usr/nzx-cluster/apps/MATLAB/MATLAB2018b/bin/matlab';
wb_command = '/usr/nzx-cluster/apps/connectome-workbench/workbench/bin_rh_linux64/wb_command';
Utildir =  '/home/cuizaixu_lab/wuguowei/DATA/python_code/CBIG';
Ciftidir = '/home/cuizaixu_lab/wuguowei/DATA/python_code/cifti-matlab-master';

%%% inputs: [CHANGE] these are the files you should have ready.
SubjectsFolder = '/GPFS/cuizaixu_lab_permanent/wuguowei/HNU/xcp_abcd';
idFile = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/code/repeat_code/motion_data/HNU_motion_valid_sub.csv';

TemplateFolder = [Workdir '/data'];
yeoAtlas = [TemplateFolder '/YeoAtlas/RSN-networks.32k_fs_LR.dlabel.nii'];

%%% output sturctures
ProjectFolder = [Workdir '/project/SingleParcellation_Kong_HNU_rp'];
DataListFolder = [ProjectFolder '/data_list'];
fMRIListFolder = [DataListFolder '/fMRI_list'];
censorListFolder = [DataListFolder '/censor_list'];
surfaceListFolder = [DataListFolder '/surface_list'];


LogFolder = [ProjectFolder '/logs'];
ProfileFolder = [ProjectFolder '/profiles'];
TrainingFolder = [ProjectFolder '/profile_list/training_set'];
IndiParcFolder = [ProjectFolder '/individual_parcellation_400_30'];

%%% parameters
seed_mesh = 'fs_LR_900';
targ_mesh = 'fs_LR_32k';
mesh = 'fs_LR_32k';
out_dir = ProjectFolder;
total_sess = '10';
all_sub = readtable(idFile);
total_subs = size(all_sub.subname,1);

%%% save paths
allPathsMat = [Codedir '/config.mat'];
save(allPathsMat,'matlab','wb_command','Workdir','Utildir','Ciftidir','Codedir', ...
'SubjectsFolder', 'idFile', 'TemplateFolder', 'yeoAtlas', 'ProjectFolder', 'DataListFolder', 'fMRIListFolder', 'censorListFolder','surfaceListFolder', ... 
'LogFolder', 'ProfileFolder', 'TrainingFolder', 'IndiParcFolder', 'seed_mesh', 'mesh','targ_mesh', 'out_dir', 'total_sess','total_subs');
