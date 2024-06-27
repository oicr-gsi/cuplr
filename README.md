# CUPLR

CUPLR: Cancer of Unknown Primary Location Resolver

## Overview

## Dependencies

* [cuplr 1.0](https://github.com/UMCUGenetics/CUPLR)
* [mutSigExtractor 1.27](https://github.com/UMCUGenetics/mutSigExtractor/)
* [rfFC 1.0](https://rdrr.io/rforge/rfFC/)
* [randomForest 4.7-1.1](https://cran.r-project.org/web/packages/randomForest/index.html)
* [naturalsort 0.1.3](https://cran.r-project.org/web/packages/naturalsort/index.html)
* [reshape2 0.8.9](https://cran.r-project.org/web/packages/reshape/index.html)
* [ggplot2 3.4.2](https://cran.r-project.org/web/packages/ggplot2/index.html)
* [ggrepel 0.9.3](https://cran.r-project.org/web/packages/ggrepel/index.html)
* [foreach 1.5.2](https://cran.r-project.org/web/packages/foreach/index.html)
* [doParallel 1.0.17](https://cran.r-project.org/web/packages/doParallel/index.html)
* [gridExtra 2.3](https://cran.r-project.org/web/packages/gridExtra/index.html)
* [cowplot 1.1.1](https://cran.r-project.org/web/packages/cowplot/index.html)
* [devtools 2.4.5](https://cran.r-project.org/web/packages/devtools/index.html)
* [BSgenome 1.68.0](https://bioconductor.org/packages/release/bioc/html/BSgenome.html)
* [BSgenome.Hsapiens.UCSC.hg19 1.4.3](https://bioconductor.org/packages/release/data/annotation/html/BSgenome.Hsapiens.UCSC.hg19.html)
* [BSgenome.Hsapiens.UCSC.hg38 1.4.5](https://bioconductor.org/packages/release/data/annotation/html/BSgenome.Hsapiens.UCSC.hg38.html)
* [GenomeInfoDb 1.36.1](https://bioconductor.org/packages/release/bioc/html/GenomeInfoDb.html)


## Usage

### Cromwell
```
java -jar cromwell.jar run cuplr.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`inputSampleName`|String|name of sample
`inputPurpleSomaticVcf`|File|input somatic VCF file (from Purple)
`inputPurpleCnvSomaticTsv`|File|input CNV file with copy number profile of all (contiguous) segments of the tumor sample (from PURPLE)
`inputPurplePurityTsv`|File|input TSV file which contains a single row with a summary of the purity fit (from PURPLE)
`inputLinxDriverCatalogTsv`|File|input TSV file which contains significant amplifications (minimum exonic copy number > 3 * sample ploidy) and deletions (minimum exonic copy number < 0.5) that occur in the HMF gene panel (from LINX)
`inputLinxFusionTsv`|File|input TSV file which contains all inframe and out of frame fusions predicted in the sample including HMF fusion knowledgebase annotations (from LINX)
`inputLinxVisSvDataTsv`|File|input TSV file which contains additional annotations of each non PON filtered breakjunction (from LINX)
`inputLinxViralInsertsTsv`|File|input TSV file which currently only contains a header (supposed to be from LINX)


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`runCuplr.modules`|String|"cuplr/1.0"|Required environment modules
`runCuplr.cuplrScript`|String|"~/cuplr.R"|.R script containing sigtools
`runCuplr.genomeVersion`|String|"hg38"|version of genome, eg hg38
`runCuplr.jobMemory`|Int|30|Memory allocated for this job (GB)
`runCuplr.threads`|Int|1|Requested CPU threads
`runCuplr.timeout`|Int|2|Hours before task timeout


### Outputs

Output | Type | Description | Labels
---|---|---|---
`chromArm`|File|Chromosome arm gains/losses compared to the overall genome ploidy (source:PURPLE)|vidarr_label: chromArm
`fusion`|File|Presence of gene fusions (source:LINX)|vidarr_label: fusion
`gene`|File|Deep deletions, amplifications, biallelic losses and mutations of cancer associated genes (source:LINX)|vidarr_label: gene
`mutLoad`|File|Total number of SBSs, DBSs and indels (source:VCF)|vidarr_label: mutLoad
`purple`|File|Genome properties, including overall ploidy, diploid proportion, gender as derived from copy number data, and presence of whole genome duplication (source:PURPLE)|vidarr_label: purple
`rmd`|File|Regional mutational density (RMD) profiles as extracted by NMF (source:VCF)|vidarr_label: rmd
`sigs`|File|Relative contribution of SBS, DBS and indel mutational signatures (source:VCF)|vidarr_label: sigs
`sv`|File|Simple and complex structural variants (source:LINX)|vidarr_label: sv
`viralIns`|File|Presence of viral sequence insertions (source:LINX)|vidarr_label: viralIns
`armPloidy`|File|Raw output file|vidarr_label: armPloidy
`rmdBinCounts`|File|Raw output file|vidarr_label: rmdBinCounts
`smnvContexts`|File|Raw output file|vidarr_label: smnvContexts
`allFeatures`|File|Summary of all features extracted from LINX and PURPLE to be used to make predictions|vidarr_label: allFeatures
`patientReport`|File|Final .png output detailing prediction of cancer of unknown location|vidarr_label: patientReport


## Commands
 This section lists command(s) run by cuplr workflow
 
 * Running cuplr
 
 ### Run cuplr
 
 ```
     set -euo pipefail
     Rscript ~{cuplrScript} -s ~{sampleName}
 
 ```
 ## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
