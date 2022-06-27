Image Scaling by de la Vallée-Poussin Filtered Interpolation

SOFTWARE

The source code of VPI (de la Vallée-Poussin Interpolation) method, proposed in the paper "Image Scaling by de la Vallée-Poussin Filtered Interpolation", arXiv:2109.13897 (2021), by D. Occorsio, G. Ramella, W. Themistoclakis, is intended by the authors as support for possible comparisons.

The method can be run by the script DemoCall_VPI_supervised.m and DemoCall_VPI_unsupervised.m respectively in supervised nd unsupervised mode. Note that this is an educational code, not optimized.

This material shall not be modified without having permission from the authors.

The authors don't make representations about the suitability of this material for any purpose. It is provided "as is" without express or implied warranty.

DATASETS

The validation of the VPI method has been carried out on several kinds of 8-bit color images collected in ten publicly available datasets, having different characteristics on the size and the quality of the images, the variety of the subjects, etc. The employed datasets are synthesized in the following table comprising 1943 images in total.

Dataset - N - Size - Link

BSDS500 - 500 - 481×321 or 321×481 - www2.eecs.berkeley.edu/Research/Projects/CS/vision/bsds/

NY - 17 -[500×334] – [6394×3456] -www.gcc.tu-darmstadt.de/home/proj/dpid/index.en.jsp

NY - 96 -[500×334] – [6394×3456] -www.gcc.tu-darmstadt.de/home/proj/dpid/index.en.jsp

13US -13 -[241×400] – [400×310] -www.cl.cam.ac.uk/~aco41/Files/Sig15UserStudyImages.html

URBAN100 -100 -[1024×564]– [1024×1024] -paperswithcode.com/dataset/urban100

PEXELS300 -300 -300×300 -available here

SET-5 -5 -[256×256] – [512×512] -https://paperswithcode.com/dataset/set5

SET-14 -12 -[276×276] – [512×768] -https://paperswithcode.com/dataset/set14

DIV2k-T -800 -[2040×768] – [2040×2040] -https://data.vision.ee.ethz.ch/cvl/DIV2K/

DIV2k-V -100 -[2040×768] – [2040×2040] -https://data.vision.ee.ethz.ch/cvl/DIV2K/

These datasets are available by the link indicated above. The dataset named PEXELS300 has been obtained by selecting 300 images from PEXELS (www.pexels.com/search/color/) that provides a free using and downloading library containing over 3.2 million photos and videos, growing each month by roughly 200,000 files. Its content is uploaded by the users and reviewed manually. The 300 images taken from this dataset, originally with a different large size, have been centrally cropped by 1800x1800 pixels. PEXELS300 is available here with the aim to support the possibility of comparison by other authors.

Permission to use, copy, or modify this dataset and its documentation for educational and research purposes only and without fee is granted, provided that this copyright notice and the original authors' names appear on all copies and supporting documentation. This dataset shall not be modified without first obtaining the permission of the authors. The authors make no representations about the suitability of this dataset for any purpose. It is provided "as is" without express or implied warranty.

In case of publishing results obtained utilizing this dataset, please refer to the following paper:

D. Occorsio, G. Ramella, W. Themistoclakis, "Image Scaling by de la Vallée-Poussin Filtered Interpolation", arXiv:2109.13897 (2021).

