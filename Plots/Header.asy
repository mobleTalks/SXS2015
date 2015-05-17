texpreamble("\def\asybeamer{beamer}");
include Header_Paper;

// Use sans fonts to mesh with beamer
usepackage("sfmath");
texpreamble("\renewcommand*\familydefault{\sfdefault}");


// In beamer, the default font is cmss and the math font size 10.95pt.
defaultpen(linewidth(1)
	   +font("T1", "cmss", "m", "n")
	   +fontsize(10.95pt));


// In my Cornell beamer class, the text area is 334.195pt across, and
//   220.647pt high.
// To make the plot square, regardless of aspect ratio, just add
//   ", IgnoreAspect" to the size argument.
real PictureHeight = 220.64662pt;
real PictureWidth  = 247.69934pt;//334.19536pt;//PictureHeight;//
size(PictureWidth, PictureHeight, IgnoreAspect);


// Redefine some colors from the paper version of Header.asy
pen[] Colors = 
  {heavyblue, heavyred, heavygreen, lightolive, Cyan, Magenta,
   green, Yellow, heavymagenta, heavycyan, Black};



