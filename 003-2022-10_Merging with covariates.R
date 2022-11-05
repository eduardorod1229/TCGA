system("cmd.exe", input = paste('"K:\\Software\\R-4.1.2\\bin\\Rscript.exe" K:\\Documents\\TCGA\\Scripts\\02-2022-10_Normalizing.R'))

covs <-  read.csv("K:/Documents/TCGA/TCGA.Glioma.metadata.tsv", header = TRUE, sep = "\t")
covs_backup <-  covs


#Including only those in the transp file
print(nrow(covs))
covs <-  covs[which(covs$case_submitter_id %in% transp$case_submitter_id_2), ]
print(nrow(covs))

#including only those in the covs file
nrow(transp)
transp <-  transp[which(transp$case_submitter_id_2 %in% covs$case_submitter_id),]
nrow(transp)

#Matching the order of the file
col_order<- match(as.character(covs$case_submitter_id), as.character(transp$case_submitter_id_2))
covs[,"is_tumor"] <- transp[col_order, which(colnames(transp)=="is_tumor")]


surv_variables <- colnames(transp)[c(311:ncol(transp))]
surv_variables <- append(surv_variables, colnames(transp)[2],2)
head(surv_variables,20)
print(length(surv_variables))

for(i in c(1:length(surv_variables))){
  covs[, surv_variables[i]] <-  transp[col_order, which(colnames(transp)==surv_variables[i])]
}


datatable(covs,options = list(pageLength = 20))

merged_df <- covs

rm(c(covs, surv_variables))

saveRDS(merged_df, 'K:/Documents/TCGA/Data/normal_data.rds')