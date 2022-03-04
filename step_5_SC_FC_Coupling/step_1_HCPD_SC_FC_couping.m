clear;clc;
struct_parcel_dir = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/SC_strength/';
struct_connect = load([struct_parcel_dir filesep 'SC_HCPD_410.mat']);
struct_connect_dat = struct_connect.sc_matrix_hcd;
%% plot SC and FC correlation
load('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HCPD_single_parcel/inter_regress_intra_std.mat');
whole_brain = final_matrix;
threshold_use = [1,exp(-20)]; 
%[r,p] = matrixCorr({mean(struct_connect_dat,3),whole_brain},'spearman',threshold_use)
%%
load('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/Single_parcel_label/7_net_group_tabel.mat');
order=[1 2 3 4 6 7 5]; %1 visual 2 SMN 3 DA 4 SAN 5 limbic 6 FPN 7 Default
t=[];
start = 1;        
lines = [1];
k = 1;
mask = cell2mat({new_tabel.yeolabel});
mask(1)=[];
for i = 1:length(order)
    add=find(mask==order(i));
    t=[t add];
    start = start + length(add);
    lines(k+1)=start;
    k = k+1;
end
%%
struct_mean_strength = mean(struct_connect_dat,3);
struct_mean_strength_7net = struct_mean_strength(t,t);
whole_brain_7net = whole_brain(t,t);
struct_mean_strength_6net = struct_mean_strength_7net(1:374,1:374);
whole_brain_6net = whole_brain_7net(1:374,1:374);
input = {struct_mean_strength_6net,whole_brain_6net};
threshold_mask = input{threshold_use(1)} > threshold_use(2);
calcUse_1_temp = input{1} .* threshold_mask;
calcUse_2_temp = input{2} .* threshold_mask;

templateMatrix = ones(size(calcUse_1_temp));
extractIndex = find([triu(templateMatrix)-diag(diag(templateMatrix))]);
calcUse{1} = calcUse_1_temp(extractIndex);calcUse{2} = calcUse_2_temp(extractIndex);

withDirectConn = find(calcUse{threshold_use(1)}~=0);

useADJ_1 = calcUse{1}(withDirectConn);
useADJ_2 = calcUse{2}(withDirectConn);

mask = useADJ_2>0.5 | useADJ_2<0.1;% threshold
useADJ_1(mask)=[];
useADJ_2(mask)=[];
corrMethod = 'spearman';
[r,p] = corr(useADJ_1,useADJ_2,'type',corrMethod)
sc_fc_coupling.sc = useADJ_1;
sc_fc_coupling.fc = useADJ_2;
sc_fc_coupling = struct2table(sc_fc_coupling);
writetable(sc_fc_coupling,'/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/SC_strength/HCPD_SC_FC.csv')
%%
struct_mean_connectivety = log(mean(struct_connect_dat,3));
plot_variability_matrix(whole_brain,0.24,0.26)
plot_variability_matrix_sc(struct_mean_connectivety,-4,0)
save('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/SC_strength/HCPD_SC_strenth.mat','struct_mean_connectivety');