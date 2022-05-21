function [] = get_uni_transmodel_var(data_name,data_path,out_name)
        load('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/Single_parcel_label/7_net_group_tabel.mat');
        order=[1 2 3 4 6 7 5]; %1 visual 2 SMN 3 DA 4 SAN 5 limbic 6 FPN 7 Default
        t=[];
        start = 1;        
        lines = [1];
        k = 1;
        mask = cell2mat({new_tabel.yeolabel});
        mask(1)=[];
        for i = 1:length(order)
            order(i)
            add=find(mask==order(i));
            t=[t add];
            start = start + length(add);
            lines(k+1)=start;
            k = k+1;
        end
        root_DIR =  data_path;
        inter_regess_intra = load([root_DIR filesep data_name]);
        struct_name = fieldnames(inter_regess_intra);
        inter_regess_intra = getfield(inter_regess_intra,struct_name{1});
        inter_regess_intra_7net_order = inter_regess_intra(t,t);

        unimodel1 = convet_matrix_to_vector(inter_regess_intra_7net_order(lines(1):lines(2)-1,lines(1):lines(2)-1));
        unimodel2 = convet_matrix_to_vector(inter_regess_intra_7net_order(lines(2):lines(3)-1,lines(2):lines(3)-1));
        unimodel3 = reshape(inter_regess_intra_7net_order(lines(1):lines(2)-1,lines(2):lines(3)-1),1,61*77);
        unimodel = [unimodel1,unimodel2,unimodel3];

        transmodel = convet_matrix_to_vector(inter_regess_intra_7net_order(lines(3):lines(7)-1,lines(3):lines(7)-1));

        uni_trans_area = inter_regess_intra_7net_order(lines(3):lines(7)-1,lines(1):lines(3)-1);
        uni_trans_area = reshape(uni_trans_area,1,236*138);

        save([root_DIR filesep out_name '_unimodel.mat'],'unimodel');
        save([root_DIR filesep out_name '_transmodel.mat'],'transmodel');
        save([root_DIR filesep out_name '_uni_trans_area.mat'],'uni_trans_area');
end

