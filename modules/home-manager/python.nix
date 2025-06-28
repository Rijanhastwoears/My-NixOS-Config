{pkgs, ...}:

{
  home.packages = with pkgs;
  let
    python-with-my-packages = python3.withPackages (ps: with ps; [
      numpy
      pandas
      matplotlib
      spyder
      spyder-kernels
      psycopg2
      pyarrow
      marimo
      duckdb
      pysam
      ipykernel
      jupyterlab
      polars
      qtconsole
      newick
      ete3
      xlsx2csv
      flask
      sqlalchemy
      flask-sqlalchemy
      werkzeug
      flask-session
      pyqt6
    ]);
    
  in
    [
      python-with-my-packages
    ];

}
