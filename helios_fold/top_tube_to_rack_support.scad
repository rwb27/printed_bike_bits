/* Mount for clipping the loose tubes to the inside of the rack
(c) Richard Bowman 2016, released under CERN open hardware license.
*/

use <utilities.scad>;
d=0.05;
$fn=16;

tube_r = 22+0.5+3; //radius of large tube
tube_to_rack = 3; //separation between 
rack_r = 5;
tube_centre = [0,tube_r+rack_r+tube_to_rack,0];
h = 2*rack_r - 1;
angle_subtended = 90;
w = sin(angle_subtended/2) * tube_r * 2 - 4;
hook_t = 3;

module annulus(inner_r,thickness,h,center=false){
	difference(){
		cylinder(r=inner_r+thickness,h=h,center=center);
		cylinder(r=inner_r,h=99999,center=true);
	}
}
module cable_tie(inner_r,center=false,h=5){
	annulus(inner_r+2,2,h,center=center);
}


difference(){
    intersection(){    
        union(){
            //this bit mounts to the strut
            rotate([0,90,0]) cylinder(r=rack_r+tube_to_rack,h=w,center=true);
            //this bit fits on the tube (the M8 counterbore)
            rotate([-90,0,0]){
                cylinder(d=12, h=tube_to_rack+8);
                cylinder(d=7.5, h=tube_to_rack+8+4);
            }
        }
        //crop in Z so we can print it!
        translate([0,1+999/2,0]) cube([w,999,h], center=true);

    }
    //rack
    rotate([0,90,0]){
        cylinder(r=rack_r, h=999,center=true, $fn=24);
        reflect([0,0,1]) translate([0,0,w/2-6]) cable_tie(rack_r);
    }
    //cable tie for velcro
    rotate([0,90,0]) intersection(){
        cylinder(r=rack_r+1, h=999, center=true);
        rotate([0,-45,0]) cube([999,999,5], center=true);
    }
}