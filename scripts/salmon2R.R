# import salmon quant files into R

library(tximport)
library(SummarizedExperiment)
library(DESeq2)
library(dplyr)
library(stringr)

root <- here::here()


## column/sample metadata

col_data <- read.csv(file.path(root, 'Data', 'sample_metadata.csv'))
rownames(col_data) <- col_data$SRAid


## row/transcript metadata

refloc <- file.path(root, 'ref', 'Octopus_bimaculoides_2_ASM119413v2_rna.fna')
fa_lines <- readLines(refloc)
headers <- fa_lines[grep("^>", fa_lines)] |>
  str_replace("PREDICTED: ", "")

row_data <- data.frame(txid = sub("^>([^ ]+).*", "\\1", headers),
                       species = sub("^\\S+\\s+(\\S+\\s+\\S+).*", "\\1", headers),
                       details = sub("^([^ ]+ +){3}(.+) \\(.*", "\\2", headers),
                       geneid = sub(".*?\\((.*?)\\).*", "\\1", headers),
                       type = sub(".*, (.*)$", "\\1", headers))

rownames(row_data) <- row_data$txid


## counts

files <- file.path(root, "results", paste0(col_data$SRAid, "_quant"), 'quant.sf')
names(files) <- col_data$SRAid

# Verify all files exist before proceeding
stopifnot(all(file.exists(files)))

tx2gene <- data.frame(TXNAME = row_data$txid, GENEID = row_data$geneid)
txi <- tximport(files, type = "salmon", tx2gene = tx2gene)

# validation
stopifnot(all.equal(colnames(txi$abundance), col_data$SRAid))

# create our DESeq object
dds <- DESeqDataSetFromTximport(
  txi = txi,
  colData = col_data,
  design = ~ group
)

dds$group <- relevel(dds$group, ref = "warm")

# add row ranges
row_data <- row_data[rownames(dds)]
rownames(dds) <- row_data

# save for local analysis
save(dds, file = file.path(root, 'results', 'DESeqDataSet.RData'))