{pkgs, ...}:

{
  home.packages = with pkgs;
  let
    python-with-my-packages = python312.withPackages (ps: with ps; [
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
      openpyxl
      newick
      ete3
      pytesseract
      xlsx2csv
      flask
      sqlalchemy
      flask-sqlalchemy
      werkzeug
      flask-session
      pdfminer-six
      pyqt6
    ]);
    
  in
    [
      python-with-my-packages
    ];

}
