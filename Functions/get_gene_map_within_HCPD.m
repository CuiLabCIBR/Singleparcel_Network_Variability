function gene_map_std = get_gene_map_within_HCPD(gene_scheafer_label)
    root_dir = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/SingleParcellation_Kong_HCPD_rp2/';
    file_name =  '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/motion_data/task_and_rest_motion_valid_sub.csv';
    sub_motion_valide_all= readtable(file_name);
    sub_motion_valide_all = sub_motion_valide_all.subject;
    OUT_DIR = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/SingleParcellation_Kong_HCPD/gene_segement';
    if ~exist(OUT_DIR,'dir')
        mkdir(OUT_DIR)
    end
    data_all = size(sub_motion_valide_all,1);
    %% within subject variability based on 8 run dataset
    %Mypool = parpool('local',8);sub_std = zeros(data_all,400*399/2);
    for s=1:data_all  % for each subject
        sub = ['sub-' sub_motion_valide_all{s}];
        subname = [root_dir '/ind_parcel_400_8run/' sub filesep 'data_pacel.mat'];    
        subdata = load(subname);subdata = subdata.data_pacel;
        parfor run = 1:8
            ind_parcel_400 = sch_to_gene_yeo(gene_scheafer_label,squeeze(subdata(2:401,:,run)));
            z_corr_data = atanh(corr(ind_parcel_400'));
            all_session(run,:) = convet_matrix_to_vector(z_corr_data);
        end
        sub_std(s,:) = std(all_session,1);
        subname
    end
    all_sub_std = mean(sub_std);
    intra_matrix = squareform(all_sub_std);
    if ~exist([OUT_DIR,'/intra_variability/'],'dir')
        mkdir([OUT_DIR,'/intra_variability/']);
    end
    save([OUT_DIR,'/intra_variability/intra_sub_std.mat'],'intra_matrix');
    %%
    for run = 1:4
        parfor s=1:data_all  % for each subject
            sub = ['sub-' sub_motion_valide_all{s}];
            subname = [root_dir '/ind_parcel_400_4run/' sub filesep 'data_pacel.mat'];    
            subdata = load(subname);subdata = subdata.data_pacel;
            subdata_single_run = subdata{run};
            ind_sub = sch_to_gene_yeo(gene_scheafer_label,subdata_single_run(2:401,:));
            z_corr_data = atanh(corr(ind_sub'));
            sub_std(s,:) = convet_matrix_to_vector(z_corr_data);
            subname
        end
        inter_variability(run,:) = std(sub_std,1);
        inter_std = squareform(std(sub_std,1));
        if ~exist([OUT_DIR,'/inter_variability/'],'dir')
            mkdir([OUT_DIR,'/inter_variability/']);
        end
        save([OUT_DIR,filesep,'/inter_variability/inter_variability_run-',num2str(run),'.mat'],'inter_std');
    end
    mean_inter_variability = squareform(mean(inter_variability));
%% inter regress out intra for each run
    for run_i = 1:4
        runname = [OUT_DIR,'/inter_variability/inter_variability_run-',num2str(run_i),'.mat'];% runs
        CC_Big1 = load(runname);
        run_Variability = CC_Big1.inter_std;
        %-----------------------------------------------------------
        %% inter-individual variability - intra- regression for each session
        %------------------------------------------------------------
        x = load([OUT_DIR,'/intra_variability/intra_sub_std.mat']);
        x = convet_matrix_to_vector(x.intra_matrix);
        y = convet_matrix_to_vector(run_Variability);
        x = bsxfun(@minus, x, mean(x));
        % Regression
        ord = randperm(length(x)); %%shuffle vertices to get rid of spatial correlation
        x = x(ord);
        y = y(ord);
        [n, revOrd]= sort(ord); %% create re-sorting vector
        [b,dev,stats] = glmfit(x,y); %% regression
        con=b(1); %constsant term
        resid=stats.resid;
        trueResid=resid(revOrd); %%re-sort in correct order
        residuals=trueResid+con; %% add back constant term
        whole_brain = squareform(residuals);
        session_name = num2str(run_i);
        out_name = [root_dir,'/whole_' session_name '_Intraregressed_out.mat'];
        save(out_name,'whole_brain');
    end
    %% mean inter-regress_intra_out variability matrix
    for run = 1:4
        vol = load( [root_dir,'/whole_' num2str(run) '_Intraregressed_out.mat']);
        vol = vol.whole_brain;
        Big_mean_Multiregressions(run,:)=convet_matrix_to_vector(vol);
    end
    gene_map_std = squareform(mean(Big_mean_Multiregressions,1));
    save([OUT_DIR,filesep,'/inter_reg_intra_var.mat'],'gene_map_std');
end