Mouse Methylation 285k Manifest and Annotation for the minfi Package

Overview:
  Upon release, the only packages available to analyze data from the Illumina Mouse DNA methylation array was
sesame, which was designed by the same group  who created the array. However, many groups experienced with using human
microarray data and who might expect to analyze mouse array data in the future have become accustomed to using the minfi
package. Minfi requires specifically formatted annotation and manifest files, which we have created and explain here.



Methods:
  We based the new annotation and manifest for the Mouse Methylation 285k on the equivalent Illumina Human
Methylation 450k manifest and annotation package. Beginning from the Mouse Methylation excel sheet
(MouseMethylation-12v1-0_A2), we imported it using a function
called read.manifest.285k() (provided). This function was modified from minfi’s read.manifest.450k function with some
alterations. It changes the Infinium design type from arabic numbers (1 and 2) to roman numbers (I and II). It also reads
the IlmnID as the main identifier, since the mouse array uses a different naming scheme and IlmnID is the only unique
identifier. Reading in the mouse annotation excel sheet with read.manifest.285k() will create a large list containing
three smaller lists: “manifest”, “manifestList”, and “controls”.

***Annotation***
  We extracted the list “manifest” as a data frame, and changed the column titles so that it could be read by minfi.
From the “anno” data frame:
  •	A “Locations” data frame was created by combining the chromosome positions, stands and map info. The chromosome
data format was changed so that it could be read by minfi.
•	A new “Manifest” data frame was created by combining the probe identifiers, addresses A, addresses B, probe sequences
of Allele A, probe sequences of allele B, design types, next bases and colour channels.
•	An “Other” data frame was made using all probe information that were not included in “Locations” and excluding the
genome builds and the MFG flag changes.
The final annotation was made using minfi’s IlluminaMethylationAnnotation() function. This function requires four
objects: “objectNames” and “defaults” (both include “Locations”, “Manifest” and “Other” data frames), “annotation”
(includes array name, annotation name and the genome build) and “pkgName” (“Mouseanno.ilmn12.mm10”).

***Manifest***
  To create a minfi-compatible manifest, we extracted the “manifestList” object. From this, the final manifest was created
using the function IlluminaMethylationManifest() with the TypeI, TypeII, TypeControl, TypeSnpI, TypeSnpII and with
“IlluminaMousemanifest” as the annotation name.


*****To use this package with minfi, you will need to change annotation title of your dataset to Mousemanifest.ilmn12.mm10 (i.e rgset@annotation[1] <- "Mouse" and rgset@annotation[2] <- "ilmn12.mm10").******
