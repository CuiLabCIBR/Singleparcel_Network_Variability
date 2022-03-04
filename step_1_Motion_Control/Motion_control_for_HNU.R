hnu_path <- '/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/code/repeat_code/motion_data/'
motion_hnu <- import(paste0(hnu_path,'HNU_motion_summary.csv'))
motion_hnu$Runs <- factor(motion_hnu$Runs )
num_iter<-1
Q3_IQR_ALL_RUN <- vector()

for (run in levels(motion_hnu$Runs)) {
  motion_hnu %>% filter(Runs==run) %>%select(RMS_mean) %>% na.omit %>% as.matrix() %>% quantile(0.75)-> Q3_IQR
  Q3_IQR_ALL_RUN[num_iter] <- Q3_IQR*1.5
  num_iter <- num_iter+1
}

num_iter<-1
valid_subject_mean_rules <- list()
for (run in levels(motion_hnu$Runs)) {
  valid_subject_mean_rules[[num_iter]] <- motion_hnu %>% filter(Runs==run,RMS_mean <= Q3_IQR_ALL_RUN[num_iter])%>%
    select(subname,Runs,RMS_mean)
  num_iter <- num_iter+1
}

valid_subject_mean_rules <- inner_join(valid_subject_mean_rules[[1]],
                                       valid_subject_mean_rules[[2]],by="subname")%>%
  inner_join(valid_subject_mean_rules[[3]],by="subname")%>%
  inner_join(valid_subject_mean_rules[[4]],by="subname")%>%
  inner_join(valid_subject_mean_rules[[5]],by="subname")%>%
  inner_join(valid_subject_mean_rules[[6]],by="subname")%>%
  inner_join(valid_subject_mean_rules[[7]],by="subname")%>%
  inner_join(valid_subject_mean_rules[[8]],by="subname")%>%
  inner_join(valid_subject_mean_rules[[9]],by="subname")%>%
  inner_join(valid_subject_mean_rules[[10]],by="subname")%>%   
  select(subname) %>% as.matrix()%>% unique()

valid_subject_percent_rules <- motion_hnu %>% filter(RMS_ab_25_invalid==FALSE) %>% select(subname) %>% as.matrix()%>% unique()

valid_subject_base_two_rules <- intersect(valid_subject_mean_rules,valid_subject_percent_rules)

motion_valid <- data.frame(subname = valid_subject_base_two_rules)
export(motion_valid,'HNU_motion_valid_sub.csv')
print(paste0("we will remain subjects of HNU based two rules:",length(valid_subject_base_two_rules)))