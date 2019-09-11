# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

list_packages <- function(){
  ip <- as.data.frame(installed.packages()[,c(1,3:4)])
  rownames(ip) <- NULL
  ip <- ip[is.na(ip$Priority),1:2,drop=FALSE]
  print(ip, row.names=FALSE)
}

filter_cran_packages <- function(packages) {
  packages[!pacman::p_iscran(packages %>% pull(1) %>% as.character()),]
}

list_github_packages <- function(){
  pkgs <- installed.packages(fields = "RemoteType")
  github_pkgs <- pkgs[pkgs[, "RemoteType"] %in% "github", "Package"]
  github_pkgs_repos <- c("")

  for (i in 1:length(github_pkgs)){
    repo = packageDescription(github_pkgs[i], fields = "GithubRepo")
    username = packageDescription(github_pkgs[i], fields = "GithubUsername")

    github_pkgs_repos[i] <- paste0(username, "/", repo)
  }
  github_pkgs_repos
}

filter_installed_packages <- function(packages) {
  packages[!pacman::p_isinstalled(packages %>% pull(1) %>% as.character()),]
}

install_cran_packages <- function(packages, dependencies = NA, quiet = T, force = F, lib = .libPaths()[1]){
  # old_repos <- getOption("repos")
  # options(repos = getOption("repos")["CRAN"])
  for (i in 1:nrow(packages)) {
    pkg <- packages[i,1] %>% as.character()
    pacman::p_install(pkg, force = force , dependencies = dependencies , quiet = quiet,character.only = T, lib = lib, repos = getOption("repos")["CRAN"])
  }
}

install_github_packages <- function(packages, dependencies = NA, quiet = T, force = F, lib = .libPaths()[1]){
  for (i in 1:nrow(packages)) {
    pkg <- packages[i,1] %>% as.character()
    githubinstall::githubinstall(pkg, force = force , dependencies = dependencies , quiet = quiet)
  }
}


