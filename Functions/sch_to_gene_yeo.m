function scheafer_yeo=sch_to_gene_yeo(gene_scheafer_label,scheafer400)
    unique_label =  unique(gene_scheafer_label(:,2));
    for n = 1:length(unique_label)
        n_inx = unique_label(n);
        indx = find(gene_scheafer_label(:,2)==n_inx);
        if length(indx)>1
           scheafer_yeo(n,:) = mean(scheafer400(indx,:));
        else
           scheafer_yeo(n,:) = scheafer400(indx,:);
        end
    end
end