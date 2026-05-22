# Force xelatex for this project (fonts via fontspec require it).
# 5 = xelatex (via .xdv -> xdvipdfmx). biber is auto-detected for biblatex.
$pdf_mode = 5;
$bibtex_use = 2;   # run biber/bibtex as needed
