function normed_datat = min_max_norm(or_matrix)
    if numel(or_matrix)>1
        normed_datat = (or_matrix - min(min(or_matrix)))/(max(max(or_matrix))-min(min(or_matrix)));
    else
        normed_datat = (or_matrix - min(or_matrix))/(max(or_matrix)-min(or_matrix));
    end
end