// Yet another carry handle for Monoprice Select Mini V2
// Brian K. White

// configurable

TUBULAR = false;

minimum_part_thickness = 3;

post_depth = 12;
post_width = post_depth;
post_height = 25;
corner_radius = 3;
grip_width = 50;
grip_height = 30;
grip_thickness = max(corner_radius*2,minimum_part_thickness);

screw_flange_thickness = 5;

$fn = $preview?18:72;

////////////////////////////////////////////////////////////////////////////////////

// partly configurable
screw_bore_id = 3.5; // screw is M3
screw_pocket_id = 7.5; // M3 button heads or washers are 6mm

// not configurable
screws_seperation = 67;    // handle screws center to center
nsx = 6.5;  // neighboring screw X relative to handle screw
nsy = 8;    // neighboring screw Y relative to handle screw

////////////////////////////////////////////////////////////////////////////////////

// console info
assert(screw_flange_thickness>minimum_part_thickness,"screw_flange_thickness is too thin");
echo();
echo("screw_flange_thickness",screw_flange_thickness);
echo("requires screw: M3 x ",screw_flange_thickness+7);
echo();

use <c_handle.scad>

module handle () {

  difference() {
    // add C handle
    c_handle(
      pitch=screws_seperation,
      screw=[screw_bore_id,screw_pocket_id,screw_flange_thickness],
      post=[post_width,post_depth,post_height],
      grip=[grip_width,grip_height,grip_thickness],
      fillet=corner_radius,
      tubular=TUBULAR
    );

    // cut clearance around nearby screw head
    translate([screws_seperation/2+nsx,nsy,-0.001]) #cylinder(h=2,d=6);
  }
  
}

//////////////////////////////////////////////////////////////////////////////
// render


if ($preview) handle();
else translate([0,-(grip_height+grip_thickness)/2,post_depth/2]) rotate([-90,0,0]) handle();
