clear;clc;
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/gifti-master'));
addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/Single_parcellation_FC_Variability/Functions'));
a = cifti_read('HCP_group_parcel_7network1.dlabel.nii');
scheafer_400_17 = cifti_read('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/Single_parcel_label/group_label.dlabel.nii');%this is the HCP group parcel file for singleparcelation project, we use scheafer 400 as initial group parameter, so it is same for HCPD and HCPA 
%% check the gene label and the 17network split label file
gene_dir = '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/Gene_data';
[~,gene_name,~]= xlsread([gene_dir '/gene_mat_label.xlsx']); %this is the label file for PNAS gene correlate map using
yeo_17_114_lh = gifti([gene_dir '/lh.Yeo2011_17Networks_fsLR32k.label.gii']);%load the same space file for vertex calculation, this is lh
yeo_17_114_rh = gifti([gene_dir '/rh.Yeo2011_17Networks_fsLR32k.label.gii']);% this is rh
yeo_17_114_data = [yeo_17_114_lh.cdata;yeo_17_114_rh.cdata;];%get the yeo 17 label, which is used for the PNAS paper
yeo_17_114.name = yeo_17_114_lh.labels.name(2:end)';%get the parcel name of yeo atlas
gene_name = gene_name(2:end);
for n_gene = 1:length(gene_name)
    gene_label = gene_name{n_gene};
    yeo_gene_label{n_gene,1} = find(contains(yeo_17_114.name,gene_label)==1); 
end
%% assign the 17network split label file to scheafer 400
scheafer_name = scheafer_400_17.diminfo{1,2}.maps.table;
c_yeo = 1;
for n_yeo =1:114
    yeo_label_vertex = find(yeo_17_114_data==n_yeo);
    for n_scheafer = 1:400
       scheafer_label_vertex = find(scheafer_400_17.cdata==n_scheafer);
       schearfer_yeo_label(n_scheafer,1)=n_scheafer;
       inter_yeo_sch = numel(intersect(scheafer_label_vertex,yeo_label_vertex));
       if inter_yeo_sch~=0
          schearfer_yeo_label_tmp(n_scheafer,c_yeo)=n_yeo;
          schearfer_yeo_label_number(n_scheafer,c_yeo)=inter_yeo_sch;
          c_yeo=c_yeo+1;
       end
    end
end
%use max vertex overlap as the rule for align yeo 17 and scheafer 400
for n_scheafer=1:400
    indx_yeo_max = find(schearfer_yeo_label_number(n_scheafer,:)==max(schearfer_yeo_label_number(n_scheafer,:)));
    indx_yeo = schearfer_yeo_label_tmp(n_scheafer,indx_yeo_max);
    schearfer_yeo_label(n_scheafer,2)=indx_yeo(1);
end
% check the results of align step
if sum(sum([1:114]==unique(schearfer_yeo_label(:,2))))~=114
   nan_yeo_indx = find(sum([1:114]==unique(schearfer_yeo_label(:,2)))==0);
   gene_none_indx = [14 17 24 39 42 71 74 87 92 94]; %those label was almost nan in PNAS paper
   nan_yeo_indx = setdiff(nan_yeo_indx,gene_none_indx);
    for n=nan_yeo_indx
       [nrow,ncol] = find(schearfer_yeo_label_tmp==n);
       if length(nrow)==1
          schearfer_yeo_label(nrow,2)=n;
          nrow;
       elseif isempty(nrow)
           continue
       else
          for tmp_n = 1:length(nrow)
            contains_ver(tmp_n) = schearfer_yeo_label_number(nrow(tmp_n),ncol(tmp_n));
          end
          [~,max_indx] = max(contains_ver);
%           if nrow(max_indx)==62 || nrow(max_indx)==207
%               max_indx=2;
%           end
          schearfer_yeo_label(nrow(max_indx),2)=n;
          nrow(max_indx)
          clear contains_ver
       end
    end
end
gene_have_label = xlsread([gene_dir '/gene_have_indx.xlsx']);
setdiff(gene_have_label,intersect(gene_have_label,schearfer_yeo_label(:,2)))%if return 0, then all regions were detected
%% align schearfer
save([gene_dir '/schearfer_400_to_yeo_gene.mat'],'schearfer_yeo_label');