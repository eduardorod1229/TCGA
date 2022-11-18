#system("cmd.exe", input = paste('"K:\\Software\\R-4.1.2\\bin\\Rscript.exe" K:\\Documents\\TCGA\\Scripts\\02-2022-10_Normalizing.R'))

library(stringr)

covs <-  read.csv("K:/Documents/TCGA/TCGA.Glioma.metadata.tsv", header = TRUE, sep = "\t")
covs_backup <-  covs

normal_df <- readRDS("K:/Documents/TCGA/Data/normalized_re.rds")

#Getting the ids in the same format
covs$id_2 <- str_sub(covs$case_submitter_id,6,nchar(covs$case_submitter_id))

normal_df$id_2 <- str_sub(normal_df$subject,1,nchar(normal_df$subject)-4)

#Including only those in the transp file
print(nrow(covs))
print(nrow(normal_df))

covs <-  covs[which(covs$id_2 %in% normal_df$id_2), ]
print(nrow(covs))

#including only those in the covs file
nrow(normal_df)
normal_df <-  normal_df[which(normal_df$id_2 %in% covs$id_2),]
nrow(normal_df)

#Matching the order of the file
col_order<- match(as.character(covs$id_2), as.character(normal_df$id_2))
covs[,"is_tumor"] <- normal_df[col_order, which(colnames(normal_df)=="is_tumor")]


surv_variables <- colnames(normal_df)[c(2:121)]
surv_variables <- append(surv_variables, colnames(normal_df)[2],2)
head(surv_variables,20)
print(length(surv_variables))

for(i in c(1:length(surv_variables))){
  covs[, surv_variables[i]] <-  normal_df[col_order, which(colnames(normal_df)==surv_variables[i])]
}


datatable(covs,options = list(pageLength = 20))

merged_df <- covs

rm(covs)
rm(surv_variables)
rm(covs_backup)

saveRDS(merged_df, 'K:/Documents/TCGA/Data/normal_data.rds')