setwd('E:/MRI/varialibity_ind_project/HCPD/variability/hcp_age_8_10/netmatrix_7net/')
library(bruceR)
library(zoo)

get_net_variability_tabel <- function(net7_bet_within_dir,type_net){
  net_b_tyep <- c("inter_reg_between_net.mat","intra_var_between_net.mat")
  net_data <- rio::import(paste0(net7_bet_within_dir,'/netmatrix_7net/',net_b_tyep[type_net]))
  visual <- net_data$net_matrix[[2]][[1]]
  Motor <- net_data$net_matrix[[2]][[2]]
  DAN<- net_data$net_matrix[[2]][[3]]
  VAN  <- net_data$net_matrix[[2]][[4]]
  FPN <- net_data$net_matrix[[2]][[5]]
  DMN <- net_data$net_matrix[[2]][[6]]
  
  
  network1 <- c(rep('Visual',length(visual)),
                rep('Somatomotor',length(Motor)),
                rep('Dorsal Attention',length(DAN)),
                rep('Ventral Attention',length(VAN)),
                rep('Frontoparietal',length(FPN)),
                rep('Default Mode',length(DMN)))
  between_std_value <- c(visual,Motor,DAN,VAN,FPN,DMN)
  
  #
  net_w_tyep <- c("inter_reg_within_net.mat","intra_var_within_net.mat")
  net_data <- rio::import(paste0(net7_bet_within_dir,'/netmatrix_7net/',net_w_tyep[type_net]))
  visual <- net_data$net_matrix[[2]][[1]]
  Motor <- net_data$net_matrix[[2]][[2]]
  DAN<- net_data$net_matrix[[2]][[3]]
  VAN  <- net_data$net_matrix[[2]][[4]]
  FPN <- net_data$net_matrix[[2]][[5]]
  DMN <- net_data$net_matrix[[2]][[6]]
  
  
  network2 <- c(rep('Visual',length(visual)),
                rep('Somatomotor',length(Motor)),
                rep('Dorsal Attention',length(DAN)),
                rep('Ventral Attention',length(VAN)),
                rep('Frontoparietal',length(FPN)),
                rep('Default Mode',length(DMN)))
  within_std_value <- c(visual,Motor,DAN,VAN,FPN,DMN)
  
  
  
  beteen_std_network <- data.frame(network1,between_std_value)
  within_std_network <- data.frame(network2,within_std_value)
  all_tabel <- beteen_std_network %>% 
    rename(network = network1) %>% 
    mutate(net_label='Between') %>% rename( std_value = between_std_value)
  final_tabel <- within_std_network %>% 
    rename(network = network2) %>%  
    mutate(net_label='Within') %>% rename(std_value = within_std_value)%>% rbind(all_tabel) 
  return(final_tabel)
}

age1_group <- get_net_variability_tabel('E:/MRI/varialibity_ind_project/HCPD/variability/hcp_age_8_10/',1)
age2_group <- get_net_variability_tabel('E:/MRI/varialibity_ind_project/HCPD/variability/hcp_age_14_16/',1)
age3_group <- get_net_variability_tabel('E:/MRI/varialibity_ind_project/HCPD/variability/hcp_age_19_21/',1)

age1_group %>% mutate(Group = rep("age8_10",nrow(age1_group))) -> age1_group
age2_group %>% mutate(Group = rep("age14_16",nrow(age2_group))) -> age2_group
age3_group %>% mutate(Group = rep("age19_21",nrow(age3_group))) -> age3_group



all_age_g <- rbind(age1_group,age2_group) %>% rbind(age3_group)

library(ggridges)
library(ggplot2)
library(viridis)
library(hrbrthemes)
all_age_g$Group <- factor(all_age_g$Group,levels = c("age8_10","age14_16","age19_21"),ordered = TRUE)
all_age_g$network <- factor(all_age_g$network,levels = c("Visual","Somatomotor","Dorsal Attention",
                                                         "Ventral Attention","Frontoparietal","Default Mode"),ordered = TRUE)
#plot within network variability
all_age_g %>% filter(net_label=="Within") %>% na.omit() %>%  ggplot(aes(x = std_value, y = Group)) +
  geom_density_ridges_gradient(aes(fill=Group,color=Group),scale = 0.5, rel_min_height = 0.01,position = position_nudge(x=0,y=0.2))+
  stat_summary(aes(fill = Group),alpha = 0.5,
               fun.max = function(x){boxplot.stats(x)$stats[4]},
               fun.min = function(x){boxplot.stats(x)$stats[1]},
               fun = function(x){boxplot.stats(x)$stats[2]},
               position = position_nudge(x=0,y=0),
               geom = "crossbar",
               width = 0.3)+theme_classic() +
  theme(legend.position="none",
        panel.spacing = unit(0.15, "lines"),
        axis.text = element_text(size = 10,color="black",family="serif",angle = 30,hjust = 1),
        strip.text.x = element_text(size = 10,color="black",family="serif")
  )+coord_flip()+
  ylab("")+xlab("")+facet_grid(~network)+stat_summary(fun = function(x){boxplot.stats(x)$stats[2]},aes(group=1),geom = "line")+
  scale_fill_manual(values = c("#fee0d2","#fc9272","#de2d26"))+scale_color_manual(values = c("#fee0d2","#fc9272","#de2d26"))+xlim(0.15,0.4)

#plot between network variability
all_age_g %>% filter(net_label=="Between") %>% na.omit() %>%  ggplot(aes(x = std_value, y = Group)) +
  geom_density_ridges_gradient(aes(fill=Group,color=Group),scale = 0.5, rel_min_height = 0.01,position = position_nudge(x=0,y=0.2))+
  stat_summary(aes(fill = Group),alpha = 0.5,
               fun.max = function(x){boxplot.stats(x)$stats[4]},
               fun.min = function(x){boxplot.stats(x)$stats[1]},
               fun = function(x){boxplot.stats(x)$stats[2]},
               position = position_nudge(x=0,y=0),
               geom = "crossbar",
               width = 0.3)+theme_classic() +
  theme(legend.position="none",
        panel.spacing = unit(0.15, "lines"),
        axis.text = element_text(size = 10,color="black",family="serif",angle = 30,hjust = 1),
        strip.text.x = element_text(size = 10,color="black",family="serif")
  )+coord_flip()+
  ylab("")+xlab("")+facet_grid(~network)+stat_summary(fun = function(x){boxplot.stats(x)$stats[2]},aes(group=1),geom = "line")+
  scale_fill_manual(values = c("#fee0d2","#fc9272","#de2d26"))+scale_color_manual(values = c("#fee0d2","#fc9272","#de2d26"))+xlim(0.15,0.4)