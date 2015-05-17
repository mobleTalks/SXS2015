import graph;
import texcolors;


// Include any latex packages and any macro definitions needed for
// labels and legends
usepackage("amsmath");
texpreamble("\input{UsePackages.tex}");
texpreamble("\input{Macros.tex}");


// This makes lines thicker than the default, and changes the default
//   font size to the same as the paper's font size.  To get the
//   current font parameters in a LaTeX document, put something like
//   
// \makeatletter %
// \newcommand{\ShowFont}{\typeout{The font is \f@encoding \space
//     \f@family \space \f@series \space \f@shape \space at
//     \f@size pt}} %
// \makeatother %
//   
//   in the preamble, then "\ShowFont" wherever you want to see it,
//   and grep the output for "The font is".  Note that if you have
//   more than one in a single document, the output may be out of
//   order.  For math font sizes, ask for \tf@size (main),
//   \sf@size (script), and \ssf@size (scripscript).  See the LaTeX2e
//   font selection guide for more details.
// Note also that captions in revtex4 are typeset with \small; when
//   most of the document is 10pt, \small is 9pt.
// In beamer, the default font is cmss and the math font size 10.95pt.
defaultpen(linewidth(1)+fontsize(10.95pt));


// This size command makes the final result fit in a square of the
//   given dimensions.  To get the linewidth of a LaTeX document, put
//   something like "\typeout{The linewidth is \the\linewidth}", and
//   grep the output for "linewidth".  In revtex4, we have the
//   following widths:
//            onecolumn   twocolumn
//     10pt     510pt       246pt
//     12pt     468pt       229pt
// To make the plot square, regardless of aspect ratio, just add
//   ", IgnoreAspect" to the size argument.
// PRD editors resize things to fit in a 200x200pt box by default, but
//   I like to keep figures the full width.
real PictureWidth  = 246pt;
real PictureHeight = PictureWidth;
size(PictureWidth, PictureHeight, IgnoreAspect);


// This is a useful function for reading in data from a file
real[][] ReadFile(string InputFileName) {
  //real[][] Temp = dimension(line(input(InputFileName)),0,0);
  real[][] Temp = input(InputFileName).line().dimension(0,0);
  return transpose(Temp);
}


// These are inherited from my Mexico City AGR colors
pen[] AGRColors =
  {rgb(255/255, 255/255, 255/255), rgb(000/255, 000/255, 000/255),
   rgb(243/255, 064/255, 000/255), rgb(000/255, 248/255, 055/255),
   rgb(000/255, 084/255, 208/255), rgb(220/255, 208/255, 060/255),
   rgb(188/255, 143/255, 143/255), rgb(220/255, 220/255, 220/255),
   rgb(148/255, 000/255, 211/255), rgb(000/255, 255/255, 255/255),
   rgb(255/255, 000/255, 255/255), rgb(255/255, 165/255, 000/255),
   rgb(114/255, 033/255, 188/255), rgb(103/255, 007/255, 072/255),
   rgb(064/255, 224/255, 208/255), rgb(000/255, 139/255, 000/255)};
pen CornellRed = rgb(179/255, 27/255, 27/255);
pen CornellGray = rgb(104/255, 100/255, 91/255);
pen[] Colors = 
  {heavyblue, heavyred, heavygreen, Cyan, Magenta,
   green, heavycyan, heavymagenta, lightolive, Black, Yellow};
//   {red,blue,green,magenta,cyan,orange,purple,brown,
//    deepblue,deepgreen,chartreuse,fuchsia,lightred,
//    lightblue,black,pink,yellow,gray};


// A convenient set of short directions
real ShorteningFactor = 0.0001;
pair n = ShorteningFactor*N;
pair e = ShorteningFactor*E;
pair s = ShorteningFactor*S;
pair w = ShorteningFactor*W;
pair ne = ShorteningFactor*NE;
pair nw = ShorteningFactor*NW;
pair se = ShorteningFactor*SE;
pair sw = ShorteningFactor*SW;


// A set of linetypes to cycle through
pen[] Lines =
  {solid, dotted+1.0, dashed, longdashed, dashdotted, dashed+0.85};


// Make some nice paths
path TriangleRightPath =
  scale(1.1)*((-1.4,-2)--(-1.4,2)--(1.4,0)--cycle);
path TriangleLeftPath = rotate(180)*TriangleRightPath;
path TriangleUpPath = rotate(90)*TriangleRightPath;
path TriangleDownPath = rotate(270)*TriangleRightPath;
path CirclePath = scale(1.3)*(unitcircle);
path SquarePath = scale(1.0)*((-2,-2)--(-2,2)--(2,2)--(2,-2)--cycle);
path DiamondPath = scale(1.3)*((0,-2)--(2,0)--(0,2)--(-2,0)--cycle);


// Useful constants
real GravitationalConstant = 6.67259e-11;  // m^3 kg^-1 sec^-2
real SpeedOfLight = 2.99792458e8;          // m / sec
real MSun = 1.98892e30;                    // kg
real Mpc = 3.08568025e22;                  // m


// This scale is linear below (less than) StartZoom, and magnified by
// ZoomFactor above (greater than) that coordinate.
scaleT ZoomHigher(real StartZoom, real ZoomFactor, 
		  bool automin=false, bool automax=automin)
{
  real T(real x) {
    if(x <= StartZoom) return x;
    return StartZoom+(x-StartZoom)*ZoomFactor;
  }
  real Tinv(real y) {
    if(y <= StartZoom) return y;
    return ((y-StartZoom)/ZoomFactor)+StartZoom;
  }
  return scaleT(T,Tinv,logarithmic=false,automin,automax);
}


// This subroutine stacks two graphs vertically and adds them to currentpicture,
// with Pic1 above Pic2.  Pad is a fractional separation between Pics.
void VerticalStack(picture Pic1, picture Pic2, real Pad=0.05) {
  real y1 = (point(Pic1,N)-point(Pic1,S)).y;
  real y2 = (point(Pic2,N)-point(Pic2,S)).y;
  real Y1 = (truepoint(Pic1,N)-truepoint(Pic1,S)).y;
  real Y2 = (truepoint(Pic2,N)-truepoint(Pic2,S)).y;
  size(Pic1,PictureWidth,(1/(1+ (Y2/y2)/(Y1/y1)))*PictureHeight*(1-Pad),IgnoreAspect);
  size(Pic2,PictureWidth,(1/(1+ (Y1/y1)/(Y2/y2)))*PictureHeight*(1-Pad),IgnoreAspect);
  
  pair min1=point(Pic1,SW);
  pair max1=point(Pic1,NE);
  pair min2=point(Pic2,SW);
  pair max2=point(Pic2,NE);
  real scale=(max1.x-min1.x)/(max2.x-min2.x);
  real shift=min1.x/scale-min2.x;
  transform t1=Pic1.calculateTransform();
  transform t2=Pic2.calculateTransform();
  transform T2=xscale(scale*t1.xx)*yscale(t2.yy);
  
  frame F;
  add(F, (shift(0,-point(Pic1,W).y)*Pic1).fit());
  real Height=(t1*(truepoint(Pic1, N)-truepoint(Pic1, S))).y;
  real YScale = (point(Pic1,N,user=false).y-point(Pic1,S,user=false).y)
    / (point(Pic2,N,user=false).y-point(Pic2,S,user=false).y);
  add(F, shift(0,-Height-Pad*PictureHeight)*(shift(shift,-point(Pic2,W).y)*Pic2).
      fit(T2*yscale(YScale)));
  
  currentpicture.addBox(min(F), max(F));
  add(new void(frame f, transform t){ add(f,t*F); }, exact=true);
}


// This returns the first derivative of y with respect to x, even when the abscissas are non-uniform
real[] dydx(real[] y, real[] x) {
  if(y.length != x.length) { abort("Size disagreement"); }
  if(y.length<3) { abort("Array size = " + string(y.length) + ".  Not enough points for a derivative"); }
  real[] D = new real[y.length];
  int i1 = y.length-1;
  real hprev = x[1]-x[0];
  D[0] = (y[1]-y[0]) / hprev;
  for(int i=1; i<i1; ++i) {
    real hnext = x[i+1]-x[i];
    /// Sundquist and Veronis, Tellus XXII (1970), 1
    D[i] = (y[i+1] - y[i-1]*((hnext/hprev)^2) - y[i]*(1-((hnext/hprev)^2))) / (hnext*(1+hnext/hprev));
    hprev = hnext;
  }
  D[i1] = (y[i1]-y[i1-1]) / (x[i1]-x[i1-1]);
  return D;
}


// This returns an array of indices of x skipping every N elements,
// but including the last element.
int[] IndicesEveryN(real[] x, int N) {
  int[] Indices = N*sequence(floor(x.length/N));
  if(Indices[Indices.length-1]!=x.length-1) {
    Indices.push(x.length-1);
  }
  return Indices;
}



// This makes the background transparent
bbox(opacity(0), Fill);
