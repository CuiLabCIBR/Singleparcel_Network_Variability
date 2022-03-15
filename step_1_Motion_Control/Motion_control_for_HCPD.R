setwd('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/motion_data/')
#install.packages(bruceR)
#rms indicates the Power FD, not Root Mean Squard
library(bruceR)
motion_all_data <- import('HCP_D_all_sub_file_summary.csv')

motion_all_data %>% ggplot(aes(rms_mean,color=runs,fill=runs))+geom_histogram()+facet_grid(~runs)


motion_all_data %>% filter(runs=='rfMRI_REST1_AP') %>%select(rms_mean) %>% na.omit %>% as.matrix() %>% quantile(0.75) -> Q3_IQR_REST1_AP
Q3_IQR_REST1_AP <- Q3_IQR_REST1_AP*1.5

motion_all_data %>% filter(runs=='rfMRI_REST1_PA') %>%select(rms_mean) %>% na.omit %>% as.matrix() %>% quantile(0.75) -> Q3_IQR_REST1_PA
Q3_IQR_REST1_PA <- Q3_IQR_REST1_PA*1.5

motion_all_data %>% filter(runs=='rfMRI_REST2_AP') %>%select(rms_mean) %>% na.omit %>% as.matrix() %>% quantile(0.75) -> Q3_IQR_REST2_AP
Q3_IQR_REST2_AP <- Q3_IQR_REST2_AP*1.5

motion_all_data %>% filter(runs=='rfMRI_REST2_PA') %>%select(rms_mean) %>% na.omit %>% as.matrix() %>% quantile(0.75) -> Q3_IQR_REST2_PA
Q3_IQR_REST2_PA <- Q3_IQR_REST2_PA*1.5


# filter subjects who exceeds the 1.5 times of 3dr quartlier
motion_all_data %>% filter(runs=="rfMRI_REST1_AP") %>% filter(rms_mean<Q3_IQR_REST1_AP) -> valid_rest1_AP
motion_all_data %>% filter(runs=="rfMRI_REST1_PA") %>% filter(rms_mean<Q3_IQR_REST1_PA) -> valid_rest1_PA
motion_all_data %>% filter(runs=="rfMRI_REST2_AP") %>% filter(rms_mean<Q3_IQR_REST2_AP) -> valid_rest2_AP
motion_all_data %>% filter(runs=="rfMRI_REST2_PA") %>% filter(rms_mean<Q3_IQR_REST2_PA) -> valid_rest2_PA

#ony use all 4 runs valid
length(unique(motion_all_data$sub))
valid_subject_mean_rules <- intersect(valid_rest1_AP$subname,valid_rest1_PA$subname) %>% intersect(valid_rest2_AP$subname) %>% intersect(valid_rest2_PA$subname)
# exclude subjects whose mean FD exceeds 0.2mm
valid_subject_percent_rules <- motion_all_data %>% filter(rms_above_02_valid==FALSE) %>% select(subname,rms_mean) %>% as.matrix()%>% unique()

valid_subject_base_two_rules <- intersect(valid_subject_mean_rules,valid_subject_percent_rules)
motion_valid <- data.frame(subject= gsub("_V1_MR","",valid_subject_base_two_rules))
export(motion_valid,'rest_motion_valid_sub.csv')
print(paste0("we will remain subjects based two rules:",length(valid_subject_base_two_rules)))

#control for the task data
valid_subject_motion_mean <- motion_all_data %>% filter(rms_above_02_valid==FALSE) %>% select(subname,rms_mean) %>% group_by(subname) %>% summarise(mean_motion=mean(rms_mean))

motion_all_data <- import('HCPD_task_motion_summary.csv')

motion_all_data %>% filter(task=='CARIT',direction=='AP') %>%select(RMS_mean) %>% na.omit %>% as.matrix() %>% quantile(0.75) -> Q3_IQR_CARIT_AP
Q3_IQR_CARIT_AP <- Q3_IQR_CARIT_AP*1.5

motion_all_data %>% filter(task=='CARIT',direction=='PA') %>%select(RMS_mean) %>% na.omit %>% as.matrix() %>% quantile(0.75) -> Q3_IQR_CARIT_PA
Q3_IQR_CARIT_PA <- Q3_IQR_CARIT_PA*1.5

motion_all_data %>% filter(task=='GUESSING',direction=='AP') %>%select(RMS_mean) %>% na.omit %>% as.matrix() %>% quantile(0.75) -> Q3_IQR_GUESSING_AP
Q3_IQR_GUESSING_AP <- Q3_IQR_GUESSING_AP*1.5

motion_all_data %>% filter(task=='GUESSING',direction=='PA') %>%select(RMS_mean) %>% na.omit %>% as.matrix() %>% quantile(0.75) -> Q3_IQR_GUESSING_PA
Q3_IQR_GUESSING_PA <- Q3_IQR_GUESSING_PA*1.5

motion_all_data %>% filter(task=='EMOTION',direction=='PA') %>%select(RMS_mean) %>% na.omit %>% as.matrix() %>% quantile(0.75) -> Q3_IQR_EMOTION_PA
Q3_IQR_EMOTION_PA <- Q3_IQR_EMOTION_PA*1.5


motion_all_data %>% filter(task=='CARIT',direction=='AP') %>% 
  filter(RMS_mean<Q3_IQR_CARIT_AP) -> valid_CARIT_AP
motion_all_data %>% filter(task=='CARIT',direction=='PA') %>% 
  filter(RMS_mean<Q3_IQR_CARIT_PA) -> valid_CARIT_PA

motion_all_data %>% filter(task=='GUESSING',direction=='AP') %>% 
  filter(RMS_mean<Q3_IQR_GUESSING_AP) -> valid_GUESSING_AP
motion_all_data %>% filter(task=='GUESSING',direction=='PA') %>% 
  filter(RMS_mean<Q3_IQR_GUESSING_PA) -> valid_GUESSING_PA

motion_all_data %>% filter(task=='EMOTION',direction=='PA') %>% 
  filter(RMS_mean<Q3_IQR_EMOTION_PA) -> valid_EMOTION_PA


length(unique(motion_all_data$sub))
valid_subject_mean_rules <- intersect(valid_CARIT_AP$subname,valid_CARIT_PA$subname) %>% intersect(valid_GUESSING_AP$subname) %>% intersect(valid_GUESSING_PA$subname) %>% intersect(valid_EMOTION_PA$subname)

valid_subject_percent_rules <- motion_all_data %>% filter(RMS_ab_25_invalid==FALSE) %>% select(subname,RMS_mean) %>% as.matrix()%>% unique()

valid_subject_base_two_rules <- intersect(valid_subject_mean_rules,valid_subject_percent_rules)
motion_valid <- data.frame(subject= gsub("_V1_MR","",valid_subject_base_two_rules))

all_data <- rio::import('ndar_subject01.txt')
sub_info <- all_data %>% filter(sex != 'Sex of the subject')%>%
  select(src_subject_id,interview_age,sex) %>% 
  mutate(years = round(as.numeric(interview_age)/12,2)) %>% filter(years>=8)

motion_valid %>% export('task_and_rest_motion_valid_sub.csv')
names(sub_info)[1] <- "subject"
age_group1 <- motion_valid %>% inner_join(sub_info,"subject") %>% filter(years<11)
age_group2 <- motion_valid %>% inner_join(sub_info,"subject") %>% filter(years>13 & years<17)
age_group3 <- motion_valid %>% inner_join(sub_info,"subject") %>% filter(years>18)

age_group1 %>% export('task_and_rest_motion_valid_age_8_10.xlsx')
age_group2 %>% export('task_and_rest_motion_valid_age_14_16.xlsx')
age_group3 %>% export('task_and_rest_motion_valid_age_19_21.xlsx')
