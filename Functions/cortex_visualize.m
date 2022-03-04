function cortex_visualize(variability_matrix,name)
    addpath(genpath('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/cifti-matlab'))
    dlabel_tem = cifti_read('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/Yeo2011_17Networks_N1000.dscalar.nii');
    dlabel = cifti_read('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/Single_parcel_label/group_label.dlabel.nii');
    load('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/Single_parcel_label/7_net_group_tabel.mat');
    limbic_label = cellfun(@(x) (x==5),{new_tabel.yeolabel},'UniformOutput', false);
    limbic_label_mask = find(cell2mat(limbic_label)==1);
    label_all = dlabel.cdata;
    label = unique(label_all);
    for l = 1:length(label)  
         label_vertex{l,1} = label(l);
         label_vertex{l,2} = find(label_all==label(l));
    end

    for n = 1:401
        if label_vertex{n,1}==0 || numel(intersect(limbic_label_mask,n))>0
           indx = label_vertex{n,2}; 
           label_all(indx) = zeros(length(indx),1);
        else
            indx = label_vertex{n,2};
            ver_profile = variability_matrix(:,n-1);
            ver_profile(n-1)=[];
            label_all(indx) = mean(ver_profile);
        end
    end
    dlabel_tem.cdata(:,1) = label_all;
    cifti_write(dlabel_tem,name);
end






