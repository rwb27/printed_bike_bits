use <../utilities.scad>;
use <./cylinder_clip.scad>;

$fn=64;


difference(){
	cylinder_clip(r=5-0.1,t=3,flat_t=7,h=12);
	translate([0,-5-4,12/2]){
		//screw_y(4,fudge=0.9,h=999,shaft=true,extraheight=0);
		rotate([90,0,0]) cylinder(r=2.4,h=999,center=true);
		rotate([-90,0,0]) cylinder(r=3.7,h=999);
	}
}