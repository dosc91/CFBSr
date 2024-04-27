# CFBSr <img src='https://github.com/dosc91/CFBSr/blob/main/CFBSr_logo.png' align="right" height="138" />

<!-- badges: start -->
![](https://img.shields.io/badge/version-0.1.0-FFA70B.svg)
![](https://img.shields.io/github/last-commit/dosc91/CFBSr)
<!-- badges: end -->

`CFBSr` is a workflow to get C-FBS data from sound files and TextGrids. Lists files, cuts sound files, computes MEL features and MEL feature correlations of samples. 

This package is mostly inspired by Shafaei-Bajestan, E., Moradipour-Tari, M., Uhrig, P., & Baayen, R. H. (2023). LDL-AURIS: a computational model, grounded in error-driven learning, for the comprehension of single spoken words. *Language, Cognition and Neuroscience, 38(4)*, 509–536. https://doi.org/10.1080/23273798.2021.1954207 and their Python package `pyLDLauris`.


# How to Install

The preferred way to install this package is through devtools:

```r
# if devtools has not been installed yet, please install it first
# install.packages("devtools")

# then, install the CFBSr package
devtools::install_github("dosc91/CFBSr")
```


# References

Please cite the `CFBSr` package as follows:

Schmitz, D. (2024). CFBSr: Create Continuous Frequency Band Summaries from Sound and TextGrid Files. R package version 0.1.0. URL: https://github.com/dosc91/CFBSr


The following sources are made use of in the `CFBSr` package:

Bořil, T., & Skarnitzl, R. (2016). Tools rPraat and mPraat. In P. Sojka, A. Horák, I. Kopeček, & K. Pala (Eds.), Text, Speech, and Dialogue (pp. 367-374). Springer International Publishing.

Ligges, U., Krey, S., Mersmann, O., & Schnackenberg, S. (2023). tuneR: Analysis of Music and Speech. Retrieved from https://CRAN.R-project.org/package=tuneR

Lyons, J., Wang, D. Y.-B., Gianluca, Shteingart, H., Mavrinac, E., Gaurkar, Y., Watcharawisetkul, W., Birch, S., Zhihe, L., Hölzl, J., Lesinskis, J., Almér, H., Lord, C., & Stark, A. (2020). jameslyons/python_speech_features: release v0.6.1 (0.6.1). Zenodo. https://doi.org/10.5281/zenodo.3607820
