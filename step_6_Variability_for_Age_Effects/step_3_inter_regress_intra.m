clear;clc;
root_dir = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HCPD_single_parcel/';
age_group = [8,10;14,16;19,21];
for age = 1:3
    age1 = age_group(age,1);
    age2 = age_group(age,2);
    OUT_DIR = [root_dir 'hcp_age_' num2str(age1) '_' num2str(age2)];
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
        out_name = [OUT_DIR,'/whole_' session_name '_Intraregressed_out.mat'];
        save(out_name,'whole_brain');
    end
    %% mean inter-regress_intra_out variability matrix
    for run = 1:4
        vol = load( [OUT_DIR,'/whole_' num2str(run) '_Intraregressed_out.mat']);
        vol = vol.whole_brain;
        Big_mean_Multiregressions(run,:)=convet_matrix_to_vector(vol);
    end
    final_matrix = squareform(mean(Big_mean_Multiregressions,1));
    plot_variability_matrix(final_matrix,0.22,0.35)
    h = gcf;
    saveas(h, [OUT_DIR,'/inter_reg_intra_variability.jpg'],'jpg');
    close
   % close;
    cortex_visualize(final_matrix,[OUT_DIR '/mean_inter-reg-intra_variability.dscalar.nii']);
    save([OUT_DIR '/inter_regress_intra_std.mat'],'final_matrix');
end