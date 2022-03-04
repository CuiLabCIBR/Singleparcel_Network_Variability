clear;clc;
out_path = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/Single_parcel_label/figure1';
mkdir(out_path)
%%
%intra
HCP_Adult_intra = load('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HCPA_single_parcel/intra_variability/intra_sub_std.mat');
HCP_Adult_intra = HCP_Adult_intra.intra_matrix;
min_th = 0.24;
max_th = 0.26;

plot_variability_matrix(HCP_Adult_intra,min_th,max_th);
HCPD_intra = load('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HCPD_single_parcel/intra_variability/intra_sub_std.mat');
HCPD_intra = HCPD_intra.intra_matrix;
plot_variability_matrix(HCPD_intra,min_th,max_th);

min_th = 0.16;
max_th = 0.20;
HNU_intra = load('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HNU_single_parcel/intra_variability/intra_sub_std.mat');
HNU_intra = HNU_intra.intra_matrix;
plot_variability_matrix(HNU_intra,min_th,max_th);
%% inter
min_th = 0.24;
max_th = 0.26;
HCP_Adult_inter = load('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HCPA_single_parcel/inter_variability/inter_sub_std.mat');
HCP_Adult_inter = HCP_Adult_inter.mean_inter_variability;
plot_variability_matrix(HCP_Adult_inter,min_th,max_th);

HCPD_inter = load('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HCPD_single_parcel/inter_variability/inter_sub_std.mat');
HCPD_inter = HCPD_inter.mean_inter_variability;
plot_variability_matrix(HCPD_inter,min_th,max_th);
%% inter reg intra
min_th = 0.22;
max_th = 0.26;
HCP_Adult_inter_reg_intra = load('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HCPA_single_parcel/inter_regress_intra_std.mat');
HCP_Adult_inter_reg_intra = HCP_Adult_inter_reg_intra.final_matrix;
plot_variability_matrix(HCP_Adult_inter_reg_intra,min_th,max_th);

HCPD_inter_reg_intra = load('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HCPD_single_parcel/inter_regress_intra_std.mat');
HCPD_inter_reg_intra = HCPD_inter_reg_intra.final_matrix;
plot_variability_matrix(HCPD_inter_reg_intra,min_th,max_th);