# Workflow_Excercise2
This pipeline is to process a workflow on bacteria raw sequence data. The following diagram shows how this workflow works. Firstly we will take raw paired sequence data into FastP to trim the data. FastQC is implemented before and after FastP to monitor the trimming process. The trimmed data will be assembled using Skesa. 
After Skesa, QUAST and MLST will be conducted parallel. 
<p align="center">
![workflow2 drawio](https://github.com/BoxuanBobLi/Workflow_Excercise2/assets/144747075/7e02fb02-c276-4e8a-b2ff-7ada6fb228e2) 
</p>

### Step 1: Creating a phylogenetic tree using parsnp
