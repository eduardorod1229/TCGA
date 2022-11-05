
system("cmd.exe", input = paste('"K:\\Software\\R-4.1.2\\bin\\Rscript.exe" K:\\Documents\\TCGA\\Scripts\\001-2022-10_REdata.R'))
library(DT)
library(data.table)
transp <- readRDS("K:/Documents/TCGA/Data/transp.rds")
hk_subt_count <- readRDS("K:/Documents/TCGA/Data/hk_subtranscripts_count.rds")
hk_exomes_count <- readRDS("K:/Documents/TCGA/Data/hk_exomes_count.rds")


#There are only 125 subjects in the housekeeping genes and 312 in the transposome dataframe
# We need to filter by the Housekeeping genes

hk_exomes_count <- hk_exomes_count[which(transp$subject %in% hk_exomes_count$Geneid),]
hk_exomes_count <- hk_exomes_count[order(hk_exomes_count$Geneid,decreasing = FALSE), ]
colnames(hk_exomes_count)[1] <- 'subject'

transp <- transp[which(hk_exomes_count$subject %in% transp$subject),]
transp <- transp[order(transp$subject,decreasing = FALSE), ]

re_count_df <- data.frame(transp[c(1,2,3, 18, 25, 40, #HERV13
                                 47,62,69,84, #SVA_A
                                 91,106,113,128, #SVA_B
                                 135,150,157,172, #SVA_C
                                 179,194,201,216,  # SVA_D
                                 223,238,245,260,   #SVA_E
                                 267,282,289,304, #SVA_F
                                 312)])

re_count_df <- merge(re_count_df, hk_exomes_count, by='subject')

re_count_df[c(32:34)] <- sapply(re_count_df[c(32:34)], function(x) (as.integer(x)))

hervk_count <- re_count_df[c(1:6,31:34)]
svaA_count <- re_count_df[c(1,2,31:34,7:10)]
svaB_count <- re_count_df[c(1,2,31:34,11:14)]
svaC_count <- re_count_df[c(1,2,31:34,15:18)]
svaD_count <- re_count_df[c(1,2,31:34,19:22)]
svaE_count <- re_count_df[c(1,2,31:34,23:26)]
svaF_count <- re_count_df[c(1,2,31:34,27:30)]





normalize_count <- function(df){
       for (j in (names(df))){
           if (grepl('aligned|.count',j)){
             df[c(paste0('ALB_normal_',j),
                  paste0('ACTB_normal_',j),
                  paste0('B2M_normal_',j))] <-
               sapply(df[j], function(x)
                  (c(x/df['B2M'],x/df['ACTB'], x/df['ALB'])))

           }
           else{
             print('no')
           }
       }
  return(df)
}

normal_df <- normalize_count(re_count_df)

saveRDS(normal_df,'K:/Documents/TCGA/Data/normalized_re.rds')

save.image('K:/Documents/TCGA/Scripts/RE_normalized_image.rds')