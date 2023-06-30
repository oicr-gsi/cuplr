version 1.0

workflow cuplr {
  input {
    File inputPurpleSomaticVcf
    File inputPurpleCnvSomaticTsv
    File inputPurplePurityTsv
    File inputLinxDriverCatalogTsv
    File inputLinxFusionTsv
    File inputLinxVisSvDataTsv
    !!! File inputLinxViralInsertsTsv !!! <-- GENERATE LATER
  }
