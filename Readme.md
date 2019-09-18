# pkgdown <img src="man/figures/logo.svg" align="right" alt="commuteR logo" width="200"/>

# commuteR

**commuteR** makes working on two (or more!) machines more comfortable. It was created out
of a need to sync installed package on a workstation and a laptop, so I could work on my commute. It was mostly created during this commute, instead of actually working.

## Overview

commuteR provides two functions, which (at the moment) you'll need to call manually

  - `backup_to_cloud()`: Creates lists of installed packages, while differentiating
  CRAN and GitHub packages, and saves these lists to Dropbox (You'll need an account
  for that. If you don't have one already, consider creating one using this
  [link](https://db.tt/rIAwB2YDrC), and I'll get a referral bonus).
  
  - `restore_from_cloud()`: Looks for the lists of packages created by `backup_to_cloud()` 
  in your Dropbox account. It then installs them, one by one. 


## Installation

    # You can install the development version from GitHub:
    # install.packages("devtools")
    devtools::install_github("pinusm/commuteR")

## Usage

``` r
library(commuteR)
```

On your source machince (just pick one, it doesn't really matter which is the source
and which is the target) run the backup function (can be assigned to hotkeys). Let it 
run for a short while:

``` r
backup_to_cloud()
```

You'll be asked to authenticate and log into your Dropbox account
(This is  handled by [rDrop2](https://github.com/karthik/rDrop2). I have NO way of knowing,
let alone storing or exposing, your Dropbox credentials)/


Then, on your target machine, run the restore function. You'll again need to authnticate your Dropbox account:

``` r
restore_from_cloud()
```

You're then welcome to run the backup function on your 'target' machine, and the restore function on your 'source' machine, to have a two-way sync. You probably won't need to autheticate again.

## Credits

Image by [Clker-Free-Vector-Images](https://pixabay.com/users/Clker-Free-Vector-Images-3736/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=305019) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=305019)
