settings.render=4;

import three;
import graph3;
import palette;

size(500, 500);
currentprojection = perspective(camera=(0, 0, 4), up=Y);

// Softer, more “studio-like” lighting
currentlight = light(
  gray(0.6),
  specularfactor=2,
  (1, 1, 2)
);

// --- your parameters (unchanged) ---
real wA1=0,       wA2=0.45*pi;
real wB1=0.5*pi,  wB2=1.5*pi;
real wC1=1.55*pi, wC2=2*pi;
real BL = 0.08*pi;

real sm(real x) { real t=min(max(x,0),1); return t*t*(3-2*t); }

real R(real w) { return 3.5 + 1.8*exp(-15*w^2/(pi*pi)); }

// --- lower patch ---
triple lower(real w, real v) {
  if ((w>pi)) {
    real u = w + 3*pi/2; if (u >= 2*pi) u -= 2*pi;
    real r = R(w);
    if (w>1.7*pi) { r = R(w*((1.7*pi)/w)^28);}
    return (7.2*cos(u)*(1+sin(u)) + r*cos(v+pi),
            -16*sqrt(abs(sin(u))),
            r*sin(v));
  }
  else if ((w<0.35*pi)){
    w = 2*pi-w;
    real u = w + 3*pi/2; if (u >= 2*pi) u -= 2*pi;
    real r = R(2*pi-w);
    return (-(7.2*cos(u)*(1+sin(u)) + r*cos(v+pi)),
            -16*sqrt(abs(sin(u))),
            r*sin(v));
  }
  else if (w>0.25*pi) {
    w = 2*pi-w;
    real u = w + 3*pi/2; if (u >= 2*pi) u -= 2*pi;
    real r = R(w);
    return (-(7.2*cos(u)*(1+sin(u)) + r*cos(v+pi)),
            -16*sqrt(abs(sin(u))),
            r*sin(v));
  }
  return (0,0,0);
}

// --- upper patch ---
triple upper(real w, real v) {
  real u = w + 3*pi/2; if (u >= 2*pi) u -= 2*pi;
  real r = R(w);
  return (7*cos(u)*(1+sin(u)) + r*cos(u)*cos(v),
          16*sin(u) + r*sin(u)*cos(v) - 3.8,
          r*sin(v));
}

// --- seam alignment ---
real bestOffset(triple f(real, real), real wf,
                triple g(real, real), real wg) {
  int N = 60;
  real best = 0; real minD = 1e18;
  for (int k = 0; k < N; ++k) {
    real phi = 2*pi*k/N;
    real d = 0;
    for (int i = 0; i < N; ++i) {
      real vi = 2*pi*i/N;
      triple p = f(wf, vi);
      triple q = g(wg, vi + phi);
      d += dot(p-q, p-q);
    }
    if (d < minD) { minD = d; best = phi; }
  }
  return best;
}

real offAB = bestOffset(upper, wB1, lower, wA2);
real offBC = bestOffset(upper, wB2, lower, wC1);

// --- domain stitching ---
real LA = wA2-wA1, LB = wB2-wB1, LC = wC2-wC1;
real total = LA + BL + LB + BL + LC;
real scale = 2*pi/total;

triple klein(pair uv) {
  real t = uv.x / scale;
  real v = uv.y;

  real s1 = LA, s2 = s1+BL, s3 = s2+LB, s4 = s3+BL;

  if (t < s1) {
    return lower(wA1 + t, v);
  } else if (t < s2) {
    real alpha = sm((t-s1)/BL);
    return (1-alpha)*lower(wA2, v+offAB) + alpha*upper(wB1, v);
  } else if (t < s3) {
    return upper(wB1 + (t-s2), v);
  } else if (t < s4) {
    real alpha = sm((t-s3)/BL);
    return (1-alpha)*upper(wB2, v) + alpha*lower(wC1, v+offBC);
  } else {
    return lower(wC1 + (t-s4), v);
  }
}

// --- build surface ---
surface s = surface(klein, (0, 0), (2pi, 2pi), 100, 50, Spline);

// --- gray-blue palette (like your image) ---
pen[] softGrayBlue = new pen[] {
  rgb(0.93, 0.93, 0.93),
  rgb(0.88, 0.90, 0.92),
  rgb(0.74, 0.77, 0.89),
  rgb(0.90, 0.92, 0.94),
  rgb(0.75, 0.75, 0.95)
};
// --- cylindrical-style shading ---


draw(s, surfacepen=material(palegray+opacity(0.27),shininess=0.5),
meshpen=opacity(0.03)+gray(0.7)+linewidth(0.1bp)
    );   // ← removes mesh entirely



real v0 = pi/3; // or try pi/2, pi, etc.
triple P = lower(0, v0);
dot(P, rgb(0.05,0.15,0.2)+9bp);

real v1 = 2*pi/3; // or try pi/2, pi, etc.
triple P1 = lower(0, v1);
dot(P1, rgb(0.05,0.15,0.2)+9bp);

