
#' List all installed packages
#'
#' @return A data frame with installed packages names and version numbers
#'

list_packages <- function() {
  ip <- as.data.frame(utils::installed.packages()[, c(1, 3:4)])
  rownames(ip) <- NULL
  ip <- ip[is.na(ip$Priority), 1:2, drop = FALSE]
}

#' Filter CRAN packages
#'
#' Takes a data frame of package names and versions (i.e. The output of \code{list_packages()}), and return only the names of packages that are available on CRAN.
#'
#' @param packages a data frame of package names and versions (i.e. The output of \code{list_packages()})
#'
#' @return a vector of package names
#'

list_cran_packages <- function(packages) {
  pkgs <- packages %>%
    dplyr::pull(1) %>%
    as.character()
  cran_available_packages <- rownames(utils::available.packages())
  pkgs[pkgs %in% cran_available_packages]
}

#' Filter GitHub packages
#'
#' Returns a vector with the name and repo composites (e.g. "pinusm/commuteR") for packages that were installed from GitHub.
#'
#' @return A vector with the name and repo composites, for packages that were installed from GitHub.
#'
list_github_packages <- function() {
  pkgs <- utils::installed.packages(fields = "RemoteType")
  github_pkgs <- pkgs[pkgs[, "RemoteType"] %in% "github", "Package"]
  github_pkgs_repos <- c("")

  for (i in seq_along(github_pkgs)) {
    repo <- utils::packageDescription(github_pkgs[i], fields = "GithubRepo")
    username <- utils::packageDescription(github_pkgs[i], fields = "GithubUsername")

    github_pkgs_repos[i] <- paste0(username, "/", repo)
  }
  github_pkgs_repos
}

#' Gathers the list of objects to backup and upload to the cloud
#'
#' Currently, a list of all installed packages, a vector of all CRAN packages, and a vector of all GitHub
#'     packages, in a repo/packagename composite.
#' @return A list of objects to backup and upload to the cloud
#'

populate_backup <- function() {
  packages <- list_packages()
  gh_packages <- list_github_packages()
  cran_packages <- list_cran_packages(packages)

  to_backup <- list(
    packages = packages,
    gh_packages = gh_packages,
    cran_packages = cran_packages
  )
  to_backup
}

#' Backup to cloud
#'
#' @param path a folder in Dropbox where the backup files are to be saved (typically, the same \code{path} given to \code{restore_from_cloud()}
#' @export
#'
backup_to_cloud <- function(path = "commuteR") {
  to_backup <- populate_backup()

  temp_path <- tempdir()

  paths_of_backups <- lapply(seq_along(to_backup), function(i) {
    paste0(temp_path, "\\", names(to_backup)[[i]], ".Rdata")
  }) %>% unlist()

  # authenticate
  rdrop2::drop_auth()

  # create actual files
  for (i in seq_along(to_backup)) {
    dput(to_backup[[i]], paths_of_backups[i])
  }

  # upload to cloud service of choice
  if (!rdrop2::drop_exists(path = path)) {
    rdrop2::drop_create(path = path)
  }
  for (i in seq_along(to_backup)) {
    rdrop2::drop_upload(file = paths_of_backups[i], path = path)
  }
}
