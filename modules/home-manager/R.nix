{pkgs, ...}:

{
  home.packages = with pkgs;
  let
    my_R_packages_list = with rPackages; [
      tidyverse
      rPackages.languageserver
      bslib
      ggplot2
      DT
      ggpubr
      shinyFiles
      bigsnpr
      ggExtra
      plotly
      shiny
      ape
      data_table
      ggtree
      microbenchmark
      devtools
      igraph
      dplyr
      argparse
      rPackages.IRkernel
      shinyBS
      reactlog
      rlang
      viridis
      svglite
      purrr
      # phylotools  # Currently broken in nixos-unstable
    ];
    
    RStudio-with-my-packages = rstudioWrapper.override{
      packages = my_R_packages_list;
    };
    R-with-my-packages = rWrapper.override{
      packages = my_R_packages_list;
    };
  in
    [
      RStudio-with-my-packages
      R-with-my-packages
    ];
}
