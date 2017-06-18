use <../utilities.scad>;
use <./cylinder_clip.scad>;

$fn=64;
rack_r = 10/2-0.1;
t=4;
h=16;
standoff = 4+t;
cr = (standoff-t+0.5)/2;

difference(){
	cylinder_clip(r=rack_r,t=t,flat_t=standoff,flat_w=2*rack_r+2*t,h=h);
	translate([0,-rack_r-4,h/2]){
		//screw_y(4,fudge=0.9,h=999,shaft=true,extraheight=0);
		rotate([90,0,0]) cylinder(r=2.2,h=999,center=true);
		rotate([-90,0,0]) cylinder(r=3.7,h=999);
	}
	reflect([1,0,0]) translate([-rack_r+cr,-rack_r-standoff+t+cr,-1]) difference(){
		mirror([1,0,0]) mirror([0,1,0]) cube([999,999,999]);
		cylinder(r=t+cr,h=999,center=true);
	}
	hull() reflect([1,0,0]) translate([-rack_r+cr,-rack_r-standoff+t+cr,0]) cylinder(r=cr,h=999,center=true);
}