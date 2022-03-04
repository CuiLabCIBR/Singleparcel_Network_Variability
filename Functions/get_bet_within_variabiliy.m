function [] = get_bet_within_variabiliy(orginal_path)
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
    all_net = {'Visual','Motor','DAN','VAN','FPN','DMN','Limbic'};
    OUT_DIR = [orginal_path, '/netmatrix_7net'];
    if ~exist(OUT_DIR)
        mkdir(OUT_DIR);
    end
    all_label = 1:400;
    root_DIR =  orginal_path;
    all_matrix = {'intra_variability/intra_sub_std.mat';'inter_variability/inter_sub_std.mat';'inter_regress_intra_std.mat'};
    out_matrix = {'_within_net.mat';'_between_net.mat';'_all_net.mat'};
    for net = 1:size(all_matrix,1)
        data_mat = [root_DIR,filesep,all_matrix{net}];
        cortex_data = load(data_mat);
        name_var = fieldnames(cortex_data);
        cortex_data = eval(['cortex_data.' name_var{1} '(t,t)']);
        for mat = 1:size(out_matrix);
            out_name = [OUT_DIR,filesep,all_matrix{net}(1:9),out_matrix{mat}];
            n=1;
            for i = 1:length(lines)
                if n<8
                n = i+1;
                within  = [lines(i):lines(n)-1];
                between = setdiff(all_label,within);
                    if contains(out_name, 'within')
                        tmp = cortex_data(within,within);
                        tmp = reshape(tmp,1,length(within)*length(within));
                        tmp(tmp==0)=[];
                    elseif contains(out_name, 'between')
                        tmp = cortex_data(between,within);
                        tmp = reshape(tmp,1,length(within)*length(between));
                        tmp(tmp==0)=[];
                    else
                        tmp = cortex_data(all_label,within);
                        tmp = reshape(tmp,1,length(within)*length(all_label));
                        tmp(tmp==0)=[];
                    end
                    net_matrix{1,i} = all_net{i};
                    net_matrix{2,i} = tmp;
                    net_matrix{3,i} = mean(tmp);
                end
                clear tmp
            end
            all_network{net,mat} = net_matrix;
            save(out_name,'net_matrix');
        end
    end
end
