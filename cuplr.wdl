version 1.0

workflow cuplr {
  input {
    String inputSampleName
    File inputPurpleSomaticVcf
    File inputPurpleCnvSomaticTsv
    File inputPurplePurityTsv
    File inputLinxDriverCatalogTsv
    File inputLinxFusionTsv
    File inputLinxVisSvDataTsv
    File inputLinxViralInsertsTsv
  }
	
  parameter_meta {
      inputSampleName: "name of sample"
      inputPurpleSomaticVcf: "input somatic VCF file (from Purple)"
      inputPurpleCnvSomaticTsv: "input CNV file with copy number profile of all (contiguous) segments of the tumor sample (from PURPLE)"
      inputPurplePurityTsv: "input TSV file which contains a single row with a summary of the purity fit (from PURPLE)"
      inputLinxDriverCatalogTsv: "input TSV file which contains significant amplifications (minimum exonic copy number > 3 * sample ploidy) and deletions (minimum exonic copy number < 0.5) that occur in the HMF gene panel (from LINX)"
      inputLinxFusionTsv: "input TSV file which contains all inframe and out of frame fusions predicted in the sample including HMF fusion knowledgebase annotations (from LINX)"
      inputLinxVisSvDataTsv: "input TSV file which contains additional annotations of each non PON filtered breakjunction (from LINX)"
      inputLinxViralInsertsTsv: "input TSV file which currently only contains a header (supposed to be from LINX)"
  }

  call runCuplr {
    input: 
      inputSampleName = sampleName
      inputPurpleSomaticVcf = purpleSomaticVcf
      inputPurpleCnvSomaticTsv = purpleCnvSomaticTsv
      inputPurplePurityTsv = purplePurityTsv
      inputLinxDriverCatalogTsv = linxDriverCatalogTsv
      inputLinxFusionTsv = linxFusionTsv
      inputLinxVisSvDataTsv = linxVisSvDataTsv
      inputLinxViralInsertsTsv = linxViralInsertsTsv
  }
  
  meta {
    author: "Aqsa Alam"                         
    email: "aalam@oicr.on.ca"
    description: "CUPLR: Cancer of Unknown Primary Location Resolver"
    dependencies: 
    [
      {
        name: "cuplr/1.0",
        url: "https://github.com/UMCUGenetics/CUPLR"
      },
      {
        name: "mutSigExtractor/1.27",
        url: "https://github.com/UMCUGenetics/mutSigExtractor/"
      },
      {
        name: "rfFC/1.0",
        url: "https://rdrr.io/rforge/rfFC/"
      },
      {
        name: "randomForest/4.7-1.1",
        url: "https://cran.r-project.org/web/packages/randomForest/index.html"
      },
      {
        name: "naturalsort/0.1.3",
        url: "https://cran.r-project.org/web/packages/naturalsort/index.html"
      },
      {
        name: "reshape2/0.8.9",
        url: "https://cran.r-project.org/web/packages/reshape/index.html"
      },
      {
        name: "ggplot2/3.4.2",
        url: "https://cran.r-project.org/web/packages/ggplot2/index.html"
      },
      {
        name: "ggrepel/0.9.3",
        url: "https://cran.r-project.org/web/packages/ggrepel/index.html"
      },
      {
        name: "foreach/1.5.2",
        url: "https://cran.r-project.org/web/packages/foreach/index.html"
      },
      {
        name: "doParallel/1.0.17",
        url: "https://cran.r-project.org/web/packages/doParallel/index.html"
      },
      {
        name: "gridExtra/2.3",
        url: "https://cran.r-project.org/web/packages/gridExtra/index.html"
      },
      {
        name: "cowplot/1.1.1",
        url: "https://cran.r-project.org/web/packages/cowplot/index.html"
      },
      {
        name: "devtools/2.4.5",
        url: "https://cran.r-project.org/web/packages/devtools/index.html"
      },
      {
        name: "BSgenome/1.68.0",
        url: "https://bioconductor.org/packages/release/bioc/html/BSgenome.html"
      },
      {
        name: "BSgenome.Hsapiens.UCSC.hg19/1.4.3",
        url: "https://bioconductor.org/packages/release/data/annotation/html/BSgenome.Hsapiens.UCSC.hg19.html"
      },
      {
        name: "BSgenome.Hsapiens.UCSC.hg38/1.4.5",
        url: "https://bioconductor.org/packages/release/data/annotation/html/BSgenome.Hsapiens.UCSC.hg38.html"
      },
      {
        name: "GenomeInfoDb/1.36.1",
        url: "https://bioconductor.org/packages/release/bioc/html/GenomeInfoDb.html"
      },
    ]
    output_meta: {
      chromArm: "Chromosome arm gains/losses compared to the overall genome ploidy (source: PURPLE)",
      fusion: "Presence of gene fusions (source: LINX)",
      gene: "Deep deletions, amplifications, biallelic losses and mutations of cancer associated genes (source: LINX)",
      mutLoad: "Total number of SBSs, DBSs and indels (source: VCF)",
      purple: "Genome properties, including overall ploidy, diploid proportion, gender as derived from copy number data, and presence of whole genome duplication (source: PURPLE)",
      rmd: "Regional mutational density (RMD) profiles as extracted by NMF (source: VCF)",
      sigs: "Relative contribution of SBS, DBS and indel mutational signatures (source: VCF)",
      sv: "Simple and complex structural variants (source: LINX)",
      viralIns: "Presence of viral sequence insertions (source: LINX)",
      armPloidy: "Raw output file",
      rmdBinCounts: "Raw output file",
      smnvContexts: "Raw output file",
      allFeatures: "Summary of all features extracted from LINX and PURPLE to be used to make predictions",
      patientReport:  "Final .png output detailing prediction of cancer of unknown location"
    }
  }
  
  output {

    File chromArm = "~{sampleName}.chrom_arm.txt"
    File fusion = "~{sampleName}.fusion.txt"
    File gene = "~{sampleName}.gene.txt"
    File mutLoad = "~{sampleName}.mut_load.txt"
    File purple = "~{sampleName}.purple.txt"
    File rmd = "~{sampleName}.rmd.txt"
    File sigs = "~{sampleName}.sigs.txt"
    File sv = "~{sampleName}.sv.txt"
    File viralIns = "~{sampleName}.viral_ins.txt"
    File armPloidy = "~{sampleName}.arm_ploidy.txt"
    File rmdBinCounts = "~{sampleName}.rmd_bin_counts.txt"
    File smnvContexts = "~{sampleName}.smnv_contexts.txt"
    File allFeatures = "~{sampleName}.all_features.txt"
    File patientReport = "~{sampleName}.report.png"
  }
}
  
  
  
task cuplr {
  input {
    File purpleSomaticVcf
    File purpleCnvSomaticTsv
    File purplePurityTsv
    File linxDriverCatalogTsv
    File linxFusionTsv
    File linxVisSvDataTsv
    File linxViralInsertsTsv
    String modules = "cuplr/1.0" 
    String cuplrScript = "~/cuplr.R"
    String genomeVersion = "hg38"
    Int jobMemory = 30
    Int threads = 1
    Int timeout = 2
  }
  
  parameter_meta {
    purpleSomaticVcf: "purple somatic .vcf"
    purpleCnvSomaticTsv: "purple somatic CNV .tsv"
    purplePurityTsv: "purple purity .tsv"
    linxDriverCatalogTsv: "linx driver catalog .tsv"
    linxFusionTsv: "linx fusion .tsv"
    linxVisSvDataTsv: "linx vis SV data .tsv"
    linxViralInsertsTsv: "linx viral inserts .tsv"
    cuplrScript: ".R script containing sigtools"
    modules: "Required environment modules"
    genomeVersion: "version of genome, eg hg38"
    jobMemory: "Memory allocated for this job (GB)"
    threads: "Requested CPU threads"
    timeout: "Hours before task timeout"
  }

  command <<<
    set -euo pipefail
    Rscript ~{cuplrScript} -s ~{sampleName}

  >>> 

  runtime {
    modules: "~{modules}"
    memory:  "~{jobMemory} GB"
    cpu:     "~{threads}"
    timeout: "~{timeout}"
  }

  output {
    File patientReport = "~{sampleName}.report.png"
  }
  
  meta {
    output_meta: {
      patientReport : "Final .png output detailing prediction of cancer of unknown location"
    }
  }
}
