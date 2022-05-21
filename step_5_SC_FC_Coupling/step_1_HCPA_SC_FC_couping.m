clear;clc;
struct_parcel_dir = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/SC_strength/';
struct_connect = load([struct_parcel_dir filesep 'SC_HCP_233.mat']);
sub_name = struct_connect.SC.subID;
sub_list = cellfun(@(x) x(93:98),sub_name,'UniformOutput',false);
struct_connect_dat = struct_connect.SC.dat;
%% plot SC and FC correlation
load('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HCPA_single_parcel/inter_regress_intra_std.mat');
whole_brain = final_matrix;
threshold_use = [1,exp(-20)]; 
%[r,p] = matrixCorr({mean(struct_connect_dat,3),whole_brain},'spearman',threshold_use)
%% make the 7 net order
load('netorder');
t = netorder.t;
lines = netorder.lines;
%% get the correlation between SC and FC
struct_mean_strength = mean(struct_connect_dat,3);
struct_mean_strength_7net = struct_mean_strength(t,t);
whole_brain_FC_7net = whole_brain(t,t);
struct_mean_strength_6net = struct_mean_strength_7net(1:374,1:374);
whole_brain_FC_6net = whole_brain_FC_7net(1:374,1:374);

input = {struct_mean_strength_6net,whole_brain_FC_6net};
threshold_mask = input{1} > threshold_use(2);
calcUse_1_temp = input{1} .* threshold_mask;
calcUse_2_temp = input{2} .* threshold_mask;

calcUse{1} = convet_matrix_to_vector(calcUse_1_temp);
calcUse{2} = convet_matrix_to_vector(calcUse_2_temp);

withDirectConn = find(calcUse{1}~=0);

useADJ_1 = calcUse{1}(withDirectConn)';
useADJ_2 = calcUse{2}(withDirectConn)';
corrMethod = 'spearman';
[r,p] = corr(useADJ_1,useADJ_2,'type',corrMethod)

sc_fc_coupling.sc = useADJ_1;
sc_fc_coupling.fc = useADJ_2;
sc_fc_coupling = struct2table(sc_fc_coupling);
writetable(sc_fc_coupling,'/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/SC_strength/HCPA_SC_FC.csv')
%%
struct_mean_connectivety = log(mean(struct_connect_dat,3));
plot_variability_matrix(whole_brain,0.22,0.24)
plot_variability_matrix_sc(struct_mean_connectivety,-3,0)
save('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/SC_strength/HCPA_SC_strenth.mat','struct_mean_connectivety');
