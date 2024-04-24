# Workflow_Excercise2
This pipeline is to process a workflow on bacteria raw sequence data. The following diagram shows how this workflow works. Firstly we will take raw paired sequence data into FastP to trim the data. FastQC is implemented before and after FastP to monitor the trimming process. The trimmed data will be assembled using Skesa. 
After Skesa, QUAST and MLST will be conducted parallel. 
<p align="center">
<img src="https://github.com/BoxuanBobLi/Workflow_Excercise2/assets/144747075/7e02fb02-c276-4e8a-b2ff-7ada6fb228e2" />
</p>

### Step 1: Create an environment that contains the required tools for this pipeline

Download the `.yml` file in this repo, and run the following code to build the environment 

```
conda env create -n <ENVNAME> --file ENV.yml
```

Or you can also manually download all the required tools

```
conda create -n <ENVNAME>
conda install -c bioconda -c conda-forge fastqc fastp skesa quast mlst
conda activate -n <ENVNAME>
```

Then you will need to install Nextflow in the environment you previously built using conda with the following command:

```
conda install nextflow
```

### Step 2: Running `main.nf` file

Download the `main.nf` file in this repo. 

To execute `main.nf`, You need to replace the directory in the first line in the `main.nf` file with your current directory.

After changing the directory you can execute `main.nf` with code below:

```
nextflow run main.nf
```

### Step 3: Viewing results

In your current directory, there will be a `results` folder, and in the `results` folder, there are the following folders with corresponding result files:

- FastQC_PreTrim
- FastP
- FastQC_PostTrim
- SKESA
- QUAST
- MLST
