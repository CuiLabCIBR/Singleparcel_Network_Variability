clear;clc;
root_dir = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/SingleParcellation_Kong_HCPD_rp2/';
data_dir = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/motion_data';
age_group = [8,10;14,16;19,21];
for age = 1:3
    age1 = age_group(age,1);
    age2 = age_group(age,2);
    file_name = [data_dir filesep 'task_and_rest_motion_valid_age_' num2str(age1) '_' num2str(age2) '.xlsx'];
    [~,~,sub_motion_valide_all]= xlsread(file_name);
    sub_motion_valide_all = sub_motion_valide_all(2:end,1);
    OUT_DIR = ['/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HCPD_single_parcel/' 'hcp_age_' num2str(age1) '_' num2str(age2)];
    if ~exist(OUT_DIR,'dir')
        mkdir(OUT_DIR)
    end
    data_all = size(sub_motion_valide_all,1);
    if ~exist([OUT_DIR,'/inter_variability/'],'dir')
        mkdir([OUT_DIR,'/inter_variability/'])
    end
    %% between subject variability based on 4 run dataset
    %Mypool = parpool('local',8);sub_std = zeros(data_all,400*399/2);
    for run = 1:4
        for s=1:data_all  % for each subject
            sub = ['sub-' sub_motion_valide_all{s}];
            subname = [root_dir '/ind_parcel_400_4run/' sub filesep 'data_pacel.mat'];    
            subdata = load(subname);subdata = subdata.data_pacel;
            ind_parcel_400 = squeeze(subdata{run});
            z_corr_data = atanh(corr(ind_parcel_400(2:401,:)'));
            all_sub(s,:) = convet_matrix_to_vector(z_corr_data);
        end
        all_sess(run,:) = std(all_sub,1);
        inter_std = squareform(std(all_sub,1));
        runname = [OUT_DIR,'/inter_variability/inter_variability_run-',num2str(run),'.mat'];
        save(runname,'inter_std');
        subname
    end
    all_sub_std = mean(all_sess);
    inter_matrix = squareform(all_sub_std);
    plot_variability_matrix(inter_matrix,0.24,0.28);
    h = gcf;
    set(h,'PaperUnits','inches','PaperPosition',[0 0 50 50]);
    saveas(h, [OUT_DIR,'/inter_variability.jpg'],'jpg');
    close;
    save([OUT_DIR,'/inter_variability/inter_sub_std.mat'],'inter_matrix');
    cortex_visualize(inter_matrix,[OUT_DIR,'/inter_variability.dscalar.nii']);
end