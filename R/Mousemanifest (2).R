##Libraries
library(minfi)
library(tidyverse)
library(here)

##Read in excel sheet with probe info
manifestFile <- here("MouseMethylation-12v1-0_A2.csv")
if(!file.exists(manifestFile)) {
  cat("Missing files, quitting\n")
  q(save = "no")
}

source(here("R/read.manifest.285k.R"))
maniTmp <- read.manifest.285k(manifestFile)


## Manifest package
manifestList <- maniTmp$manifestList
Mousemanifest <- do.call(IlluminaMethylationManifest,
                                                list(TypeI = manifestList$TypeI,
                                                     TypeII = manifestList$TypeII,
                                                     TypeControl = manifestList$TypeControl,
                                                     TypeSnpI = manifestList$TypeSnpI,
                                                     TypeSnpII = manifestList$TypeSnpII,
                                                     annotation = "IlluminaMousemanifest"))

save(Mousemanifest, compress = "xz",
     file = here("data", "Mousemanifest.rda"))
