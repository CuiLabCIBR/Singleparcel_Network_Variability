clear;clc;
root_dir = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HCPD_single_parcel/'
age_1 = load([root_dir '/hcp_age_8_10/inter_regress_intra_std.mat']);
age_1_v = convet_matrix_to_vector(age_1.final_matrix);
age_2 = load([root_dir '/hcp_age_14_16/inter_regress_intra_std.mat']);
age_2_v = convet_matrix_to_vector(age_2.final_matrix);
age_3 = load([root_dir '/hcp_age_19_21/inter_regress_intra_std.mat']);
age_3_v = convet_matrix_to_vector(age_3.final_matrix);
figure;h1=histfit(age_1_v,[],'kernel');hold on; h2=histfit(age_2_v,[],'kernel');hold on; h3=histfit(age_3_v,[],'kernel');
h1(1).FaceAlpha = 0.2;h2(1).FaceAlpha = 0.2;h3(1).FaceAlpha = 0.2;
h1(2).Color = [.2 .2 .2];h2(2).Color = [.2 .2 .2];h3(2).Color = [.2 .2 .2];

orginal_path = [root_dir '/hcp_age_8_10'];
get_bet_within_variabiliy(orginal_path)

orginal_path = [root_dir '/hcp_age_14_16/'];
get_bet_within_variabiliy(orginal_path)


orginal_path = [root_dir '/hcp_age_19_21/'];
get_bet_within_variabiliy(orginal_path)

%%
age_1 = age_1.final_matrix;
age_2 = age_2.final_matrix;
age_3 = age_3.final_matrix;

plot_variability_matrix(age_1,0.24,0.3)
plot_variability_matrix(age_2,0.24,0.3)
plot_variability_matrix(age_3,0.24,0.3)







