use <../utilities.scad>;
use <./cylinder_clip.scad>;

$fn=64;
rack_r = 10/2-0.1;
t=2.5;
h=12;
standoff = 7;

difference(){
	cylinder_clip(r=rack_r,t=t,flat_t=standoff,flat_w=2*rack_r+2*t,h=h);
	translate([0,-rack_r-4,h/2]){
		//screw_y(4,fudge=0.9,h=999,shaft=true,extraheight=0);
		rotate([90,0,0]) cylinder(r=2.4,h=999,center=true);
		rotate([-90,0,0]) cylinder(r=3.7,h=999);
	}
	reflect([1,0,0]) translate([-rack_r+t,-rack_r-standoff+2*t,-1]) difference(){
		mirror([1,0,0]) mirror([0,1,0]) cube([999,999,999]);
		cylinder(r=2*t,h=999,center=true);
	}
	hull() reflect([1,0,0]) repeat([0,standoff-3*t+0.5,0],2) translate([-rack_r+t,-rack_r-standoff+2*t,0]) cylinder(r=t,h=999,center=true);
}