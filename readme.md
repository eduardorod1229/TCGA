# Normalization with new house keeping genes

This repository is to perform normalization for Retro element counts using ALb, ACTB and B2M as housekeeping genes to provide normalization.

The pipeline runs as follows: 

* Imports data from the housekeeping genes by subject
* Renames columns to match existing data with demographics in other dataset
* Merges datasets with count of housekeeping genes
* Exports data with a normalized matrix (Normalized count is using Q20)
* The final file is `normalized_re.rds`