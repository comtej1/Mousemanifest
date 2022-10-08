##Librairies
library(minfi)
library(tidyverse)
library(here)

##Read in excel sheet with probe info
source("data/read.manifest.285k.R")
manifestFile <- here("MouseMethylation-12v1-0_A2.csv")
stopifnot(file.exists(manifestFile))

maniTmp <- read.manifest.285k(manifestFile)

anno <- maniTmp$manifest



## Annotation package

nam <- names(anno)
names(nam) <- nam
nam[c( "AddressA_ID", "AddressB_ID", "AlleleA_ProbeSeq", "AlleleB_ProbeSeq",
            "Infinium_Design_Type", "Next_Base", "Color_Channel")] <-  c( "AddressA", "AddressB",
                                                                         "ProbeSeqA", "ProbeSeqB",
                                                                         "Type", "NextBase", "Color")
names(nam) <- NULL
names(anno) <- nam




rownames(anno) <- anno$Name

Locations <- anno[, c("CHR", "MAPINFO")]
names(Locations) <- c("chr", "pos")
Locations$pos <- as.integer(Locations$pos)
Locations$chr <- paste("chr", Locations$chr, sep = "")
Locations$strand <- ifelse(anno$Strand == "F", "+", "-")
table(Locations$chr, exclude = NULL)
Locations <- as(Locations, "DataFrame")

Manifest <- anno[, c("Name", "AddressA", "AddressB",
                     "ProbeSeqA", "ProbeSeqB", "Type", "NextBase", "Color")]
Manifest <- as(Manifest, "DataFrame")

usedColumns <- c(names(Manifest),
                 c("chr", "MAPINFO", "strand",
                    "Genome_Build", "MFG_Change_Flagged"))
Other <- anno[, setdiff(names(anno), usedColumns)]
Other <- as(Other, "DataFrame")



## Making the package.  First we save all the objects

annoNames <- c("Locations", "Manifest", "Other")

annoStr <- c(array = "Mouse",
             annotation = "ilmn12",
             genomeBuild = "mm10")
defaults <- c("Locations", "Manifest", "Other")
pkgName <- sprintf("%sanno.%s.%s", annoStr["array"], annoStr["annotation"],
                    annoStr["genomeBuild"])

annoObj <- IlluminaMethylationAnnotation(objectNames = annoNames, annotation = annoStr,
                              defaults = defaults, packageName = pkgName)

assign(pkgName, annoObj)

#usethis::use_data(annoObj, Locations, Other, Manifest)
csv <- read.csv("MouseMethylation-12v1-0_A2.csv", head = T, sep = ",")
save(csv, file="data/MouseMethylation-12v1-0_A2.csv.rda")
