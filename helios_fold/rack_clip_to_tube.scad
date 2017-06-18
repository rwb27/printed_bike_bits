use <../utilities.scad>;
use <./cylinder_clip.scad>;

$fn=64;

tube_r = 22;
tube_to_rack = 6; //was 6 for smaller clips, 13 for larger ones

module annulus(inner_r,thickness,h,center=false){
	difference(){
		cylinder(r=inner_r+thickness,h=h,center=center);
		cylinder(r=inner_r,h=99999,center=true);
	}
}
module cable_tie(inner_r,center=false){
	annulus(inner_r+2,2,5,center=center);
}
difference(){
	cylinder_clip(r=5-0.1,t=3,flat_t=tube_to_rack+1,h=12);
	translate([0,-5-tube_to_rack-tube_r,12/2]) rotate([0,90,0]){
#		cylinder(r=tube_r,h=999,center=true);
		cable_tie(tube_r,center=true);
	}
}