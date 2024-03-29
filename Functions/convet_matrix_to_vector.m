function ma2vec = convet_matrix_to_vector(or_matrix)
% input: M*M symmetrical matrix
% output: a vector can be invert back to original matrix by squareform
%usage: ma2vec = convet_matrix_to_vector(or_matrix)
    upper = or_matrix;
    ma2vec=[];
    for n =1:size(upper,1)
          tmp = upper(n,n+1:end);
           ma2vec = [ma2vec,tmp;];
    end
end
