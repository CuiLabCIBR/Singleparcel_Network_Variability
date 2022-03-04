function [] = save_data(out_dir,data_mat)
   data_pacel = data_mat;
   save(out_dir,'data_pacel');
end