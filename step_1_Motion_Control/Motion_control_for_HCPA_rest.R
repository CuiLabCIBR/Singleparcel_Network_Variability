setwd('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/code/repeat_code/motion_data/')
library(bruceR)
motion_all_data <- import('HCPA_motion_summary.csv')


motion_all_data %>% filter(task=='REST1',directions=="RL") %>%select(RMS_mean) %>% na.omit %>% as.matrix() %>% quantile(0.75) -> Q3_IQR_REST1_RL
Q3_IQR_REST1_RL <- Q3_IQR_REST1_RL*1.5

motion_all_data %>% filter(task=='REST1',directions=="LR") %>%select(RMS_mean) %>% na.omit %>% as.matrix() %>% quantile(0.75) -> Q3_IQR_REST1_LR
Q3_IQR_REST1_LR <- Q3_IQR_REST1_LR*1.5

motion_all_data %>% filter(task=='REST2',directions=="RL") %>%select(RMS_mean) %>% na.omit %>% as.matrix() %>% quantile(0.75) -> Q3_IQR_REST2_RL
Q3_IQR_REST2_RL <- Q3_IQR_REST2_RL*1.5

motion_all_data %>% filter(task=='REST2',directions=="LR") %>%select(RMS_mean) %>% na.omit %>% as.matrix() %>% quantile(0.75) -> Q3_IQR_REST2_LR
Q3_IQR_REST2_LR <- Q3_IQR_REST2_LR*1.5



motion_all_data %>% filter(task=='REST1',directions=="RL") %>% filter(RMS_mean<Q3_IQR_REST1_RL) -> valid_rest1_RL
motion_all_data %>% filter(task=='REST1',directions=="LR") %>% filter(RMS_mean<Q3_IQR_REST1_LR) -> valid_rest1_LR
motion_all_data %>% filter(task=='REST2',directions=="RL") %>% filter(RMS_mean<Q3_IQR_REST2_RL) -> valid_rest2_RL
motion_all_data %>% filter(task=='REST2',directions=="LR") %>% filter(RMS_mean<Q3_IQR_REST2_LR) -> valid_rest2_LR


valid_subject_mean_rules <- intersect(valid_rest1_RL$subname,valid_rest1_LR$subname) %>% intersect(valid_rest2_RL$subname) %>% intersect(valid_rest2_LR$subname)
valid_subject_percent_rules <- motion_all_data %>% filter(RMS_ab_25_invalid==FALSE) %>% select(subname,RMS_mean) %>% as.matrix()%>% unique() %>%
valid_subject_base_two_rules <- intersect(valid_subject_mean_rules,valid_subject_percent_rules)
length_invalid_subject <- c(154532,769064,966975)

print(paste0("we will remain subjects based two rules for HCP-adults rest:",length(valid_subject_base_two_rules)))
motion_valid<- data.frame(subname=valid_subject_base_two_rules)
export(motion_valid,'HCP_Adults_motion_valid.csv')
