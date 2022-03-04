function distance_data = distance_cal(mni_gene,MNI_lr_32_L)
   for n_ver = 1:size(MNI_lr_32_L.vertices,1)
        tmp_mni_fsLR = double(MNI_lr_32_L.vertices(n_ver,:));
        distance_data(1,n_ver) = pdist2(mni_gene,tmp_mni_fsLR,'euclidean');
   end
end