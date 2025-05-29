// Yet another carry handle for Monoprice Select Mini V2
// Brian K. White

// The red puck in the preview is a near-by screw head on the machine.
// The cylinder will be cut from the handle automatically if the handle
// is large enough to intersect it. You don't have to worry about
// avoiding it except for cosmetic reasons if you don't want the notch
// cut out of the final part.

// configuration

TUBULAR = false;
USE_ORIGINAL_SCREWS = false;

// USE_ORIGINAL_SCREWS is a bad idea and you should not use it.
//
// The original screws are too short and they are tapered so the end is undersize,
// and they are tri-lobe self-tapping type. There is very little thread
// engagement and there is also not really enough plastic under the screw head.
// But this setting gives the best compromise for flange thickness
// and other tweaks to make it possible though not safe or robust.
//
// If the threads strip out or the screw head pulls through the plastic
// and the printer smashes your kids foot, don't blame me. I said don't do it.
//
// It is better to use standard (not self-tapping) M3x12 screws and M3 washers.

minimum_part_thickness = 2;
screw_flange_thickness = USE_ORIGINAL_SCREWS ? minimum_part_thickness : 5;

post_depth = 12;
post_width = post_depth;
post_height = 25;
corner_radius = 3;
grip_width = 50;
grip_height = 30;
grip_thickness = max(corner_radius*2,minimum_part_thickness);

$fn = $preview?18:72;

////////////////////////////////////////////////////////////////////////////////////

// partly configurable stuff

// If using the original screws, reduce the bore diameter to add as much material
// as possible to try to compensate a little for the thin flange thickness.
// This also assumes no washers so it reduces the pocket diameter too.
screw_bore_id = USE_ORIGINAL_SCREWS ? 3 : 3.5; // screw is M3
screw_pocket_id = USE_ORIGINAL_SCREWS ? 6.5 : 7.5; // M3 button heads or washers are 6mm

// not configurable
screws_seperation = 67;  // handle screws center to center
nsx = 6.5;  // neighboring screw X relative to handle screw
nsy = 8;    // neighboring screw Y relative to handle screw

////////////////////////////////////////////////////////////////////////////////////

// console info
assert(screw_flange_thickness>=minimum_part_thickness,"screw_flange_thickness is too thin");
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

    // cut clearance around a near-by screw head
    translate([screws_seperation/2+nsx,nsy,-0.001]) #cylinder(h=2,d=6);
  }
  
}

//////////////////////////////////////////////////////////////////////////////
// render


if ($preview) handle();
else translate([0,-(grip_height+grip_thickness)/2,post_depth/2]) rotate([-90,0,0]) handle();
