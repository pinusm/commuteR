

#' Filter package names of packages that already installed
#'
#' @param packages A string vector of names of packages.
#' @import dplyr
#' @import pacman
#' @return \code{packages}, without any packages that already installed (any version).

filter_installed_packages <- function(packages) {
  packages[!pacman::p_isinstalled(packages %>% dplyr::pull(1) %>% as.character())]
}

#' Install packages fom CRAN
#'
#' @param packages A string vector of names of packages to be installed from a CRAN repo.
#' @param dependencies logical indicating whether to also install uninstalled packages which these packages depend on/link to/import/suggest (and so on recursively). Not used if repos = NULL. Can also be a character vector, a subset of c("Depends", "Imports", "LinkingTo", "Suggests", "Enhances").
#'   Only supported if lib is of length one (or missing), so it is unambiguous where to install the dependent packages. If this is not the case it is ignored, with a warning.
#'   The default, NA, means c("Depends", "Imports", "LinkingTo").
#'   TRUE means to use c("Depends", "Imports", "LinkingTo", "Suggests") for pkgs and c("Depends", "Imports", "LinkingTo") for added dependencies: this installs all the packages needed to run pkgs, their examples, tests and vignettes (if the package author specified them correctly).
#'   In all of these, "LinkingTo" is omitted for binary packages.
#' @param quiet logical: if true, reduce the amount of output.
#' @param force logical. Should package be installed if it already exists on local system?
#' @param lib character vector giving the library directories where to install the packages. Recycled as needed. If missing, defaults to the first element of .libPaths().
#' @import pacman
#'

install_cran_packages <- function(packages, dependencies = NA, quiet = T, force = F, lib = .libPaths()[1]) {
  # old_repos <- getOption("repos")
  # options(repos = getOption("repos")["CRAN"])
  for (i in seq_along(packages)) {
    pkg <- packages[i] %>% as.character()
    pacman::p_install(pkg, force = force, dependencies = dependencies, quiet = quiet, character.only = T, lib = lib, repos = getOption("repos")["CRAN"])
  }
}

#' Install packages fom GitHub
#'
#' @param packages A string vector of names of packages (e.g. "dplyr").
#' @param dependencies logical indicating whether to also install uninstalled packages which these packages depend on/link to/import/suggest (and so on recursively). Not used if repos = NULL. Can also be a character vector, a subset of c("Depends", "Imports", "LinkingTo", "Suggests", "Enhances").
#'   Only supported if lib is of length one (or missing), so it is unambiguous where to install the dependent packages. If this is not the case it is ignored, with a warning.
#'   The default, NA, means c("Depends", "Imports", "LinkingTo").
#'   TRUE means to use c("Depends", "Imports", "LinkingTo", "Suggests") for pkgs and c("Depends", "Imports", "LinkingTo") for added dependencies: this installs all the packages needed to run pkgs, their examples, tests and vignettes (if the package author specified them correctly).
#'   In all of these, "LinkingTo" is omitted for binary packages.
#' @param quiet logical: if true, reduce the amount of output.
#' @param force logical. Should package be installed if it already exists on local system?
#' @param lib character vector giving the library directories where to install the packages. Recycled as needed. If missing, defaults to the first element of .libPaths().
#' @import pacman

install_github_packages <- function(packages, dependencies = NA, quiet = T, force = F, lib = .libPaths()[1]) {
  for (i in seq_along(packages)) {
    pkg <- packages[i] %>% as.character()
    remotes::install_github(pkg, force = force, dependencies = dependencies, quiet = quiet, lib = lib)
  }
}

#' Install packages, from both CRAN and GitHub
#'
#' Installs packages, from both CRAN and GitHub, and skips any packages that are already installed
#' @param cran_packages A string vector with names of packages to be installed from CRAN
#' @param gh_packages A string vector with names of repo\\packages to be installed from GitHub
#'
install_packages_from_backup <- function(cran_packages, gh_packages) {
  filtered_cran_package <- filter_installed_packages(cran_packages)
  filtered_gh_package <- filter_installed_packages(gh_packages)

  install_cran_packages(filtered_cran_package)
  install_github_packages(filtered_gh_package)
}

#' List all files in a specified backup Dropbox folder
#'
#' @param path path to look for files (usually, "commuteR")
#'
#' @return A vector of filenames, without file extensions
#' @import rdrop2
#'

list_backup <- function(path = path) {
  rdrop2::drop_dir(path) %>%
    dplyr::pull(name) %>%
    base::basename() %>%
    tools::file_path_sans_ext()
}

#' Restore from cloud (Install packages)
#'
#' @param path a folder in Dropbox where the backup files where saved (typically, the same \code{path} given to \code{backup_to_cloud()}
#' @export

restore_from_cloud <- function(path = "commuteR") {
  # authenticate
  rdrop2::drop_auth()

  temp_path <- tempdir()

  list_of_backs <- list_backup(path = path)

  paths_of_restores <- lapply(seq_along(list_of_backs), function(i) {
    paste0(temp_path, "\\", list_of_backs[[i]], ".Rdata")
  }) %>% unlist()

  # get actual files
  for (i in seq_along(paths_of_restores)) {
    rdrop2::drop_download(
      path = paste0(path, "/", list_of_backs[[i]], ".Rdata"),
      local_path = paths_of_restores[i],
      overwrite = T
    )
  }

  # load actual files
  for (i in seq_along(paths_of_restores)) {
    assign(list_of_backs[[i]], dget(paths_of_restores[i]))
  }

  install_packages_from_backup(cran_packages = cran_packages, gh_packages = gh_packages)
}
