push @generated_exts, "cb";
push @generated_exts, "cb2";
push @generated_exts, "spl";
push @generated_exts, "nav";
push @generated_exts, "snm";
push @generated_exts, "tdo";
push @generated_exts, "nmo";
push @generated_exts, "brf";
push @generated_exts, "nlg";
push @generated_exts, "nlo";
push @generated_exts, "nls";
push @generated_exts, "synctex.gz";
push @generated_exts, "soc";
push @generated_exts, "loc";
push @generated_exts, "log";
push @generated_exts, "xdv";
push @generated_exts, "run.xml";

$pdf_mode = 1;

$latex = 'latex  %O  --shell-escape %S';
$pdflatex = 'pdflatex  %O  --shell-escape %S';
$xelatex = 'xelatex  %O  --shell-escape %S';
