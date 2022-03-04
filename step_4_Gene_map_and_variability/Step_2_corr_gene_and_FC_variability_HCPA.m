clear;clc;
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/Single_parcellation_FC_Variability/Functions'));
gene_dir = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/Gene_data';
gene_scheafer_label = load([gene_dir '/schearfer_400_to_yeo_gene.mat']);% use this label to calculate the std map based on yeo 114
gene_scheafer_label = gene_scheafer_label.schearfer_yeo_label;
%%
gene_std_dir = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/SingleParcellation_Kong_HCPA/gene_segement';
%gene_map_std = get_gene_map_within_HCPA(gene_scheafer_label); %get the inter-reg-intra variability from HCPD data
load([gene_std_dir '/Inter_regress_Intra_std.mat']);
whole_brain = gene_map_std;
%% get the PNAS gene map label and corr mat
[gene_have_indx,~,~] = xlsread([gene_dir '/gene_have_indx.xlsx']);
[gene_corr,~,~] = xlsread([gene_dir '/gene_corr.xlsx']);
net_label_gene = gene_corr(:,1);
% get the order of gene have label in gene corr mat
for n =1:length(gene_have_indx)
    gene_have_indx(n,2)=find(net_label_gene==gene_have_indx(n,1));
end
gene_hava_corr = gene_corr(gene_have_indx(:,2),gene_have_indx(:,2));%reorder the gene corr map
gene_scheafer_label_order =unique(gene_scheafer_label(:,2));
for n =1:length(gene_have_indx)
    scheafer_have_indx(n)=find(gene_scheafer_label_order==gene_have_indx(n,1));%get the order of gene map for reordering the variability map
end
%% corr variability and gene map
variability_matrix = whole_brain(scheafer_have_indx(:),scheafer_have_indx(:));
gene_hava_corr_z = atanh(gene_hava_corr);
[label_index,~,label_name] = xlsread([gene_dir '/gene_have_indx.xlsx']);
label_index = label_index(:,2);
limbic_index = find(label_index==5);
no_limbic_indx = setdiff(1:90,limbic_index);
gene_hava_corr_no_lim = gene_hava_corr(no_limbic_indx,no_limbic_indx);
variability_matrix_no_lim = variability_matrix(no_limbic_indx,no_limbic_indx);
no_lim_net_label = label_index(no_limbic_indx);
save([gene_dir '/HCPA_no_lim_net_label.mat'],'no_lim_net_label');
plot_variability_matrix_gene(gene_hava_corr_no_lim,-0.5,0.5)
plot_variability_matrix_gene_FC(variability_matrix_no_lim,0.22,0.24)
%%
gene_corr_set = convet_matrix_to_vector(gene_hava_corr_no_lim);
namask = isnan(gene_corr_set);
variability_set = convet_matrix_to_vector(variability_matrix_no_lim);
gene_corr_set(namask)=[];
variability_set(namask)=[];
[r,p] = corr(gene_corr_set',variability_set','type','spearman')
HCPA.gene_corr_set = gene_corr_set';
HCPA.variability_set = variability_set';
HCPA_gene_FC_var = struct2table(HCPA);
writetable(HCPA_gene_FC_var,[gene_dir '/HCPA_gene_FC.csv'],'FileType','text');
