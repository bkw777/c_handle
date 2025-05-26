// Brian K. White - rounded_cube()
//
// rounded_cube(w,d,h,rv,rh,t);
//
// w,d,h = same as cube([w,d,h],center=true)
//
// rv = vertical radius
//      range: >= 0
//
// rh = horizontal radius
//      range: >= rv
//
// t = wall thickness
//     missing or 0 = solid
//     -n = wall grows in from w,d,h,rv,rh
//     +n = wall grows out from w,d,h,rv,rh

use <mirror_copy.scad>

module quarter_circle (r=1) {
 intersection () {
  circle(r);
  square(r);
 }
}

module quarter_hemisphere (rv=1,rh=1) {
 rotate_extrude(90)
  translate([rh-rv,0,0])
   quarter_circle(rv);
}

module _rounded_cube (w=10,d=10,h=10,rv=1,rh=1) {
 // no radii, simple cube()
 if (rv<=0 && rh<=0) cube([w,d,h],center=true);
 else hull() {
  // only horiz radius, use cylinders
  if (rv<=0) {
   mirror_copy([0,1,0]) translate([0,d/2-rh,0])
    mirror_copy([1,0,0]) translate([w/2-rh,0,0])
     cylinder(h=h,r=rh,center=true);
  } else {
  // both radii, use quarter hemispheres
   mirror_copy([0,0,1]) translate([0,0,h/2-rv])
    mirror_copy([0,1,0]) translate([0,d/2-rh,0])
     mirror_copy([1,0,0]) translate([w/2-rh,0,0])
      quarter_hemisphere(rh=rh,rv=rv);
  }
 }
}

module rounded_cube (w=10,d=10,h=10,rv=1,rh=1,t=0) {
 // reference
 //%cube([w,d,h],center=true);

 // no wall, solid
 if (t==0 || t>=w/2 || t>=d/2 || t>=h/2) _rounded_cube(w=w,d=d,h=h,rh=rh,rv=rv);
 // wall grows out
 else if (t>0) difference(){
  _rounded_cube(w=w+t+t,d=d+t+t,h=h+t+t,rv=rv+t,rh=rh+t);
  _rounded_cube(w=w,d=d,h=h,rv=rv,rh=rh);
 }
 // wall grows in
 else difference(){
  _rounded_cube(w=w,d=d,h=h,rv=rv,rh=rh);
  _rounded_cube(w=w+t+t,d=d+t+t,h=h+t+t,rv=rv+t,rh=rh+t);
 }
}

// test
/*
difference(){
 rounded_cube(w=80,d=60,h=40,rv=1,rh=10,t=2,$fn=72);
 cube(100);
}
*/