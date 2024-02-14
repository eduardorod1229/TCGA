system("cmd.exe", input = paste('"K.R'))
library(DT)
library(data.table)

setwd("K:/Documents/TCGA")


# Read in the transposome dataset
transp <-  read.csv("K.gz" , header = TRUE)

#Merge the raw data

split_tcga_name <-  function(subject_name){
  sp <- strsplit(subject_name,split = "-")[[1]]
  case_id <-  paste("TCGA-",sp[1], "-", sp[2], sep = "")
  tumor_code <-  paste(strsplit(sp[3], split="")[[1]][-3], collapse= "")
  is_tumor_sample <-  ifelse(as.integer(tumor_code)<10, 1, 0)
  return(c(case_id, is_tumor_sample))
}


transp[, c("case_submitter_id_2","is_tumor")] <-  t(sapply(transp$subject, split_tcga_name))


transp_backup <- transp

transp <-  transp_backup
tumor <-  1 # 1 to look at tumor, 0 to look at blood samples
transp$is_tumor <- as.numeric(transp$is_tumor)
saveRDS(transp, 'K:.rds')

transp <-  transp[which(transp$is_tumor==tumor), ]

datatable(transp[,1:15],options <-  list(pageLength = 20))


saveRDS(transp, 'K:.rds')
