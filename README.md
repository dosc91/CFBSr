# CFBSr <img src='https://dominicschmitz.com/wp-content/uploads/2024/04/CFBSr_logo.png' align="right" height="138" />

<!-- badges: start -->
![](https://img.shields.io/badge/version-0.3.0-FFA70B.svg)
![](https://img.shields.io/github/last-commit/dosc91/CFBSr)
<!-- badges: end -->

`CFBSr` is a workflow to get C-FBS data from sound files and TextGrids. Lists files, cuts sound files, computes MEL features and MEL feature correlations of samples. 

This package is mostly inspired by Shafaei-Bajestan, E., Moradipour-Tari, M., Uhrig, P., & Baayen, R. H. (2023). LDL-AURIS: a computational model, grounded in error-driven learning, for the comprehension of single spoken words. *Language, Cognition and Neuroscience, 38(4)*, 509–536. https://doi.org/10.1080/23273798.2021.1954207 and their Python package `pyLDLauris`.

Check the [documentation](https://dosc91.github.io/CFBSr/index.html) for further information.


# How to Install

The preferred way to install this package is through devtools:

```r
# if devtools has not been installed yet, please install it first
# install.packages("devtools")

# then, install the CFBSr package
devtools::install_github("dosc91/CFBSr")
```

# Workflow

<img src='https://dominicschmitz.com/wp-content/uploads/2024/05/CFBSr_flowchart_v030.svg' align="center"/>


# References

Please cite the `CFBSr` package as follows:

Schmitz, D. (2024). CFBSr: Create Continuous Frequency Band Summaries from Sound and TextGrid Files. R package version 0.2.0. URL: https://github.com/dosc91/CFBSr


The following sources are made use of in the `CFBSr` package:

Arnold, D. (2018). AcousticNDLCodeR: Coding Sound Files for Use with NDL. R package version 1.0.2. Retrieved from https://CRAN.R-project.org/package=AcousticNDLCodeR

Arnold, D., Tomaschek, F., Sering, K., Lopez, F., & Baayen, R. H. (2017). Words from spontaneous conversational speech can be recognized with human-like accuracy by an error-driven learning algorithm that discriminates between meanings straight from smart acoustic features, bypassing the phoneme as recognition unit. PLOS ONE, 12(4), e0174623. https://doi.org/10.1371/journal.pone.0174623

Bořil, T., & Skarnitzl, R. (2016). Tools rPraat and mPraat. In P. Sojka, A. Horák, I. Kopeček, & K. Pala (Eds.), Text, Speech, and Dialogue (pp. 367-374). Springer International Publishing.

Ligges, U., Krey, S., Mersmann, O., & Schnackenberg, S. (2023). tuneR: Analysis of Music and Speech. Retrieved from https://CRAN.R-project.org/package=tuneR

Lyons, J., Wang, D. Y.-B., Gianluca, Shteingart, H., Mavrinac, E., Gaurkar, Y., Watcharawisetkul, W., Birch, S., Zhihe, L., Hölzl, J., Lesinskis, J., Almér, H., Lord, C., & Stark, A. (2020). jameslyons/python_speech_features: release v0.6.1 (0.6.1). Zenodo. https://doi.org/10.5281/zenodo.3607820

Shafaei-Bajestan, E., Moradipour-Tari, M., Uhrig, P., & Baayen, R. H. (2023). LDL-AURIS: a computational model, grounded in error-driven learning, for the comprehension of single spoken words. Language, Cognition and Neuroscience, 38(4), 509–536. https://doi.org/10.1080/23273798.2021.1954207

Signal developers. (2023). signal: Signal processing. Retrieved from https://r-forge.r-project.org/projects/signal/

Sueur, J., Aubin, T., & Simonis, C. (2008). Seewave: a free modular tool for sound analysis and synthesis. Bioacoustics, 18(3), 213-226.

Wickham, H. (2016). ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York. ISBN 978-3-319-24277-4. Retrieved from https://ggplot2.tidyverse.org

Wickham, H. (2007). Reshaping Data with the {reshape} Package. Journal of Statistical Software, 21(12), 1-20. Retrieved from http://www.jstatsoft.org/v21/i12/

Zeileis, A., & Grothendieck, G. (2005). zoo: S3 Infrastructure for Regular and Irregular Time Series. Journal of Statistical Software, 14(6), 1-27. https://doi.org/10.18637/jss.v014.i06
