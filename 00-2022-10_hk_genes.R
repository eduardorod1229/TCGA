# Formating of housekeeping genes

hk_sub_trnsc <-  read.csv("K.csv", header =  TRUE, skip = 1, sep = '\t')
hk_exomes <- read.csv("K:.csv", header =  TRUE, skip = 1, sep = '\t')
hk_transcripts <- read.csv("K:csv", header =  TRUE, skip = 1, sep = '\t')

#The code below is to change the names of the transcripts (no-subset) file
column_names <- function(data_frame){


  bam_names <-  c(names(data_frame)[endsWith(names(data_frame), 'bam')])
  names(data_frame)[endsWith(names(data_frame), 'bam')] <-
    sapply(strsplit(bam_names, "\\."), function(x)
      paste0(x[c(12,13,14)], collapse = "."))

  colnames(data_frame) <-gsub("\\.", "-",colnames(data_frame))

  X_names <-  c(names(data_frame)[startsWith(names(data_frame), 'X')])
  names(data_frame)[startsWith(names(data_frame), 'X')] <- gsub("X","",X_names)

  print(names(data_frame))
}

colnames(hk_transcripts) <- column_names(hk_transcripts)
colnames(hk_sub_trnsc) <- column_names(hk_sub_trnsc)
colnames(hk_exomes) <- column_names(hk_exomes)

rename_count_columns <- function(df){
  count_columns <- names(df)[-c(1:6)]
  names(df)[-c(1:6)] <-
    sapply(strsplit(names(df)[-c(1:6)], "-"), function(x)
    paste0(x[c(1,2,3)], collapse = "-"))
  print(names(df))
}

colnames(hk_exomes) <- rename_count_columns(hk_exomes)
colnames(hk_sub_trnsc) <- rename_count_columns(hk_sub_trnsc)


saveRDS(hk_exomes, 'K.rds')
saveRDS(hk_sub_trnsc, 'K:.rds')
saveRDS(hk_exomes, 'K:.rds')


transpose_df <- function(data_frame){
  index <- seq(1,length(colnames(data_frame)))
  data_frame <- rbind(names(data_frame),data_frame)
  names(data_frame) <- names(index)
  data_frame <- t(data_frame)
  data_frame <- data.frame(data_frame, row.name = index)
  names(data_frame) <- data_frame[1,]
  return(data_frame)
  print(head(data_frame,15))
}

hk_transcripts_t <- transpose_df(hk_transcripts)
hk_sub_trnsc_t <- transpose_df(hk_sub_trnsc)
hk_exomes_t <- transpose_df(hk_exomes)

hk_transcripts_count <- hk_transcripts_t[-c(1:6),c('Geneid','ALB','ACTB','B2M')]
saveRDS(hk_transcripts_count, 'K.rds')

hk_subt_count <- hk_sub_trnsc_t[-c(1:6),c('Geneid','ALB','ACTB','B2M')]
saveRDS(hk_subt_count, 'K:.rds')

hk_exomes_count <- hk_exomes_t[-c(1:6),c('Geneid','ALB','ACTB','B2M')]
saveRDS(hk_exomes_count, 'K:.rds')

