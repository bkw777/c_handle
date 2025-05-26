// parametric simple C handle generator
// Brian K. White

use <mirror_copy.scad>
use <rounded_cube.scad>

// pitch=screw-center-to-center
// screw=[bore_id,pocket_id,flange_thickness]
// post=[width,depth,height]
// grip=[width,height,thickness]
// fillet=corner_radius
// tubular=false

module rectangular_body (pitch,post,grip,fillet) {

  post_width = post[0];
  post_depth = post[1];
  post_height = post[2];
  grip_width = grip[0];
  grip_height = grip[1];
  grip_thickness = grip[2];

  mirror_copy([1,0,0]) {
    // post
    translate([pitch/2,0,post_height/2]) rounded_cube(w=post_width,d=post_depth,h=post_height,rh=fillet,rv=0);

    // connector
    hull() {
      mirror_copy([0,1,0]) translate([0,post_depth/2-fillet,0]) {
        translate([pitch/2+post_width/2-fillet,0,post_height]) sphere(r=fillet);
        translate([grip_width/2,0,grip_height+grip_thickness-fillet]) sphere(r=fillet);
        translate([grip_width/2-fillet,0,grip_height+fillet]) sphere(r=fillet);
        translate([pitch/2-post_width/2+fillet,0,post_height]) sphere(r=fillet);
      }
    }
  }

  // grip
  translate([0,0,grip_thickness/2+grip_height]) rotate([0,90,0]) rounded_cube(w=grip_thickness,d=post_depth,h=grip_width,rh=fillet,rv=0);
}

module tubular_body (pitch,post,grip) {

  post_diameter = max(post[0],post[1]);
  post_height = post[2];
  grip_width = grip[0];
  grip_height = grip[1];

  mirror_copy([1,0,0]) {
    // post
    translate([pitch/2,0,0]) cylinder(h=post_height,d=post_diameter);
    //connector
    hull() {
      translate([pitch/2,0,post_height]) sphere(d=post_diameter);
      translate([grip_width/2,0,grip_height+post_diameter/2]) sphere(d=post_diameter);
    }
  }
  // grip
  translate([-grip_width/2,0,grip_height+post_diameter/2]) rotate([0,90,0]) cylinder(h=grip_width,d=post_diameter);
}

module c_handle(pitch=100,screw=[4.5,8,6],post=[16,12,20],grip=[80,30,10],fillet=2,tubular=false) {

  screw_bore_id = screw[0];
  screw_pocket_id = screw[1];
  screw_flange_thickness = screw[2];
  grip_height = grip[1];
  grip_thickness = tubular?post[0]:grip[2];

  difference() {
    // add handle body
    if (tubular) tubular_body(pitch,post,grip);
    else rectangular_body(pitch,post,grip,fillet);

    // cut screw holes
    group() {
      mirror_copy([1,0,0]) translate([pitch/2,0,0]) {
        // screw bore
        translate([0,0,-1]) cylinder(d=screw_bore_id,h=grip_height+grip_thickness+2);
        // screw head pocket
        translate([0,0,screw_flange_thickness]) cylinder(d=screw_pocket_id,h=grip_height+grip_thickness);
      }
    }
  }
}
