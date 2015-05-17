include Header;
settings.outformat = "pdf";
//import patterns;

string[] FileNames = {"PenroseDiagrams", "ObserverA", "ObserverB",
                      "NullRays", "AsymptoticCoordinates",
                      "TimeTranslation", "SpaceTranslation",
                      "SpaceTimeTranslation", "SuperTranslation",
                      "ExcludedRegion"};
pen[] DiagramPens = {gray(0.2), gray(0.2), gray(0.2), gray(0.2),
                     gray(0.2), gray(0.2), gray(0.2), gray(0.2),
                     gray(0.2), gray(0.2)};
pen[] DiagramLabelPens = {gray(0.2), gray(0.5), gray(0.5), gray(0.5),
                          invisible, invisible, invisible, invisible,
                          invisible, invisible};

real Infty = 75.; // This is how close we need to get to infinity
dotfactor = 3;

real v(real t, real r) { return t+r; }
real w(real t, real r) { return t-r; }
real p(real v) { return 2*atan(v)/pi; }
real q(real w) { return 2*atan(w)/pi; }
real tp(real p, real q) { return (p+q)/2.0; }
real rp(real p, real q) { return (p-q)/2.0; }
pair PrimeTransform(pair tr) {
  return (tp(p(v(tr.x, tr.y)), q(w(tr.x, tr.y))),
          rp(p(v(tr.x, tr.y)), q(w(tr.x, tr.y))));
}

real PointPicker(real t) { return (t^3+t)/(Infty^2+1); }

for(int i=0; i<FileNames.length; ++i) {

  if(i==5) { // Draw time-translated observer 'b'
    pair Path(real t) { return PrimeTransform((0.0, t+0.5)); }
    draw(Label("$\mathscr{B}$", position=Relative(0.75)),
         graph(Path, Infty, -Infty, n=100, PointPicker, join=operator ..),
         dashed+heavyblue);
  }

  if(i==6) { // Draw space-translated observer 'b'
    pair Path(real t) { return PrimeTransform((0.7, t)); }
    draw(Label("$\mathscr{B}$", position=Relative(0.75)), align=E,
         graph(Path, Infty, -Infty, n=100, PointPicker, join=operator ..),
         dashed+heavyblue);
  }

  if(i==7) { // Draw spacetime-translated observer 'b'
    pair Path(real t) { return PrimeTransform((0.7, t-0.3)); }
    draw(Label("$\mathscr{B}$", position=Relative(0.75)), align=E,
         graph(Path, Infty, -Infty, n=100, PointPicker, join=operator ..),
         dashed+heavyblue);
  }

  if(i>=1 && i<=7) { // Draw observer 'a'
    pair Path(real t) { return PrimeTransform((0.0, t)); }
    draw(Label("$\mathscr{A}$", position=Relative(0.25)),
         graph(Path, -Infty, Infty, n=100, PointPicker, join=operator ..),
         dashed+deepgreen);
  }

  if(i>=2 && i<=4) { // Draw observer 'b'
    real v = 0.5;
    pair Path(real t) { return PrimeTransform((v*t, t)); }
    draw(Label("$\mathscr{B}$", position=Relative(0.75)),
         graph(Path, Infty, -Infty, n=100, PointPicker, join=operator ..),
         dashed+heavyblue);
  }

  if(i>=3) { // Draw null cone
    pen NullCone = heavyred;
    pair RightGoing(real t) { return PrimeTransform((t, t)); }
    pair LeftGoing(real t) { return PrimeTransform((-t, t)); }
    draw(graph(RightGoing, 0, Infty), NullCone);
    draw(graph(LeftGoing, 0, Infty), NullCone);
    dot(PrimeTransform((0,0)), NullCone);
  }

  if(i>=3) { // Draw 'u' axis
    pair ne = 0.05*NE;
    pair Rzero = (0.5,0.5)+ne;
    pair nw = 0.05*NW;
    pair Lzero = (-0.5,0.5)+nw;
    draw((1,0)+ne--(0,1)+ne, Arrows(7));
    draw(Rzero+(0.02,0.02)--Rzero-(0.02,0.02));
    label("$u$", Rzero+(0.03, 0.03), ne);
    draw((-1,0)+nw--(0,1)+nw, Arrows(7));
    draw(Lzero+(0.02,-0.02)--Lzero-(0.02,-0.02));
    label("$u$", Lzero+(-0.03, 0.03), nw);
  }

  if(i>=5) { // Draw new null cone
    pen NewNullCone = purple;
    pair LOrigin, ROrigin;
    pair ne = 0.05*NE;
    pair nw = 0.05*NW;
    if(i==5) {
      LOrigin = (0,0.5);
      ROrigin = LOrigin;
      dot(PrimeTransform(LOrigin), NewNullCone);
    } else if(i==6) {
      LOrigin = (0.7,0);
      ROrigin = LOrigin;
      dot(PrimeTransform(LOrigin), NewNullCone);
    } else if(i==7) {
      LOrigin = (0.7,-0.3);
      ROrigin = LOrigin;
      dot(PrimeTransform(LOrigin), NewNullCone);
    } else if(i>=8) {
      LOrigin = (0.0,-0.7);
      ROrigin = (0.0, 0.4);
    }
    pair RightGoing(real t) { return PrimeTransform((t, t)+ROrigin); }
    pair LeftGoing(real t) { return PrimeTransform((-t, t)+LOrigin); }
    draw(graph(RightGoing, 0, Infty), NewNullCone);
    draw(graph(LeftGoing, 0, Infty), NewNullCone);
    pair LZero = PrimeTransform((-Infty, Infty)+LOrigin)+nw;
    draw(LZero--LZero+(-0.02,0.02));
    label("$u'$", LZero+(-0.03, 0.03), nw);
    pair RZero = PrimeTransform((Infty, Infty)+ROrigin)+ne;
    draw(RZero--RZero+(0.02,0.02));
    label("$u'$", RZero+(0.03, 0.03), ne);
  }

  if(i==9) { // Draw the excluded region
    pen BadRegionPen = gray(0.5);
    real ExcludedWidth = 1.5;
    pair RightEdge(real t) {
      if(t<0) { return PrimeTransform((ExcludedWidth*(1+2.*(-t/20.)^.25), t)); }
      return PrimeTransform((ExcludedWidth, t));
    }
    pair LeftEdge(real t) {
      if(t<0) { return PrimeTransform((-ExcludedWidth*(1+2.*(-t/20.)^.25), t)); }
      return PrimeTransform((-ExcludedWidth, t));
    }
    filldraw(
             graph(RightEdge, -Infty,Infty, n=100, PointPicker, join=operator --)
             --graph(LeftEdge,Infty,-Infty, n=100, PointPicker, join=operator --)
             --cycle,
             BadRegionPen,
             BadRegionPen);
    label("Turbulent spacetime", (0,0));
  }

  // Draw basic diagram
  draw((1,0)--(0,1)--(-1,0)--(0,-1)--cycle, p=DiagramPens[i]);
  label("$i^0$", (1,0), E, p=DiagramLabelPens[i]);
  label("$i^+$", (0,1), N, p=DiagramLabelPens[i]);
  label("$i^0$", (-1,0), W, p=DiagramLabelPens[i]);
  label("$i^-$", (0,-1), S, p=DiagramLabelPens[i]);
  label("$\scriplus$", (0.5, 0.5), NE, p=DiagramLabelPens[i]);
  label("$\scriplus$", (-0.5, 0.5), NW, p=DiagramLabelPens[i]);
  label("$\scriminus$", (-0.5, -0.5), SW, p=DiagramLabelPens[i]);
  label("$\scriminus$", (0.5, -0.5), SE, p=DiagramLabelPens[i]);

  write(FileNames[i]);
  shipout(FileNames[i]);
  erase();
}


/// Local Variables:
/// asy-TeX-master-file: "../Presentation"
/// End:
