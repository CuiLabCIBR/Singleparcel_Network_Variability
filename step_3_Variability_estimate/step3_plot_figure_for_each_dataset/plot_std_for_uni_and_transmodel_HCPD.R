unimodel <- as.matrix(rio::import("/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HCPD_single_parcel/unimodel.mat"))
trans_model <- as.matrix(rio::import("/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HCPD_single_parcel/transmodel.mat"))
trans_uni_model <- as.matrix(rio::import("/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/project/HCPA_single_parcel/uni_trans_area.mat"))
all_tabel <- data.frame(type=c(rep("Unimodel",nrow(unimodel)),
                               rep("Transmodel",nrow(trans_model)),
                               rep("Uni_to_Trans",nrow(trans_uni_model))),
                        variability = c(unimodel,trans_model,trans_uni_model))



all_tabel  %>% 
  ggplot( aes(x = variability, y = reorder(type,variability))) +
  geom_density_ridges_gradient(aes(fill=type,color=type),scale = 0.5, rel_min_height = 0.01,position = position_nudge(x=0,y=0.2))+
  stat_summary(aes(fill = type),alpha = 0.5,
               fun.max = function(x){boxplot.stats(x)$stats[4]},
               fun.min = function(x){boxplot.stats(x)$stats[1]},
               fun = function(x){boxplot.stats(x)$stats[2]},
               position = position_nudge(x=0,y=0),
               geom = "crossbar",
               width = 0.3) +
  theme_classic() +
  theme(legend.position="none",
        panel.spacing = unit(0.15, "lines"),
        axis.text = element_text(size = 10,color="black",family="serif"),
        strip.text.x = element_text(size = 20,color="black",family="serif")
  )+coord_flip()+
  ylab("")+xlab("")+xlim(0.15,0.4)