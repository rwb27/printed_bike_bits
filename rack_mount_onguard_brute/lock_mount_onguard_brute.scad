use <utilities.scad>;

module annulus(inner_r,thickness,h){
	difference(){
		cylinder(r=inner_r+thickness,h=h);
		cylinder(r=inner_r,h=99999,center=true);
	}
}
module cable_tie(inner_r){
	annulus(inner_r+2,2,5);
}


shroud_r = 25.1/2+0.6;
barrel_r = 50/2;
rack_r = 5;
t=3;
h=8;
$fn=64;

module top_holder(){
    difference(){
        hull(){
            cylinder(r=shroud_r+t, h=h, center=true);
            translate([0,-shroud_r-t,0]) cube([2*shroud_r+2*t, 2*rack_r, h],center=true);
        }
        
        //hole for the rubberised casing of the lock
        translate([0,0,-h/2]) chamfered_hole(r=shroud_r, h=h);
        
        //indent for the lock body
        translate([0,0,h/2+barrel_r-2]) rotate([0,90,0]) cylinder(r=barrel_r,h=999,center=true);
        
        //cable tie points
        reflect([1,0,0]) translate([shroud_r-5, -shroud_r-t-rack_r,0]) rotate([0,90,0]) cable_tie(rack_r);
        
        //rack
        translate([0, -shroud_r-t-rack_r,0]) rotate([0,90,0]) cylinder(r=rack_r,h=999,center=true);
    }
}

module bottom_clip(){
    