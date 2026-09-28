# omit the pdf trailer /ID, which otherwise depends on where the pdf is built
$pre_tex_code = '\pdftrailerid{}';
$pdflatex = 'pdflatex %O %P';
