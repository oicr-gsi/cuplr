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
      sampleName = inputSampleName,
      purpleSomaticVcf = inputPurpleSomaticVcf,
      purpleCnvSomaticTsv = inputPurpleCnvSomaticTsv,
      purplePurityTsv = inputPurplePurityTsv,
      linxDriverCatalogTsv = inputLinxDriverCatalogTsv,
      linxFusionTsv = inputLinxFusionTsv,
      linxVisSvDataTsv = inputLinxVisSvDataTsv,
      linxViralInsertsTsv = inputLinxViralInsertsTsv
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
      }
    ]
    output_meta: {
    chromArm: {
        description: "Chromosome arm gains/losses compared to the overall genome ploidy (source:PURPLE)",
        vidarr_label: "chromArm"
    },
    fusion: {
        description: "Presence of gene fusions (source:LINX)",
        vidarr_label: "fusion"
    },
    gene: {
        description: "Deep deletions, amplifications, biallelic losses and mutations of cancer associated genes (source:LINX)",
        vidarr_label: "gene"
    },
    mutLoad: {
        description: "Total number of SBSs, DBSs and indels (source:VCF)",
        vidarr_label: "mutLoad"
    },
    purple: {
        description: "Genome properties, including overall ploidy, diploid proportion, gender as derived from copy number data, and presence of whole genome duplication (source:PURPLE)",
        vidarr_label: "purple"
    },
    rmd: {
        description: "Regional mutational density (RMD) profiles as extracted by NMF (source:VCF)",
        vidarr_label: "rmd"
    },
    sigs: {
        description: "Relative contribution of SBS, DBS and indel mutational signatures (source:VCF)",
        vidarr_label: "sigs"
    },
    sv: {
        description: "Simple and complex structural variants (source:LINX)",
        vidarr_label: "sv"
    },
    viralIns: {
        description: "Presence of viral sequence insertions (source:LINX)",
        vidarr_label: "viralIns"
    },
    armPloidy: {
        description: "Raw output file",
        vidarr_label: "armPloidy"
    },
    rmdBinCounts: {
        description: "Raw output file",
        vidarr_label: "rmdBinCounts"
    },
    smnvContexts: {
        description: "Raw output file",
        vidarr_label: "smnvContexts"
    },
    allFeatures: {
        description: "Summary of all features extracted from LINX and PURPLE to be used to make predictions",
        vidarr_label: "allFeatures"
    },
    patientReport: {
        description: "Final .png output detailing prediction of cancer of unknown location",
        vidarr_label: "patientReport"
    }
}
  }
  
  output {

    File chromArm = "~{inputSampleName}.chrom_arm.txt"
    File fusion = "~{inputSampleName}.fusion.txt"
    File gene = "~{inputSampleName}.gene.txt"
    File mutLoad = "~{inputSampleName}.mut_load.txt"
    File purple = "~{inputSampleName}.purple.txt"
    File rmd = "~{inputSampleName}.rmd.txt"
    File sigs = "~{inputSampleName}.sigs.txt"
    File sv = "~{inputSampleName}.sv.txt"
    File viralIns = "~{inputSampleName}.viral_ins.txt"
    File armPloidy = "~{inputSampleName}.arm_ploidy.txt"
    File rmdBinCounts = "~{inputSampleName}.rmd_bin_counts.txt"
    File smnvContexts = "~{inputSampleName}.smnv_contexts.txt"
    File allFeatures = "~{inputSampleName}.all_features.txt"
    File patientReport = "~{inputSampleName}.report.png"
  }
}
  
  
  
task runCuplr {
  input {
    File purpleSomaticVcf
    File purpleCnvSomaticTsv
    File purplePurityTsv
    File linxDriverCatalogTsv
    File linxFusionTsv
    File linxVisSvDataTsv
    File linxViralInsertsTsv
    String sampleName
    String modules = "cuplr/1.0" 
    String cuplrScript = "~/cuplr.R"
    String genomeVersion = "hg38"
    Int jobMemory = 30
    Int threads = 1
    Int timeout = 2
  }
  
  parameter_meta {
    sampleName: "Sample id"
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
