/* Mount for clipping the loose tubes to the inside of the rack
(c) Richard Bowman 2016, released under CERN open hardware license.
*/

use <utilities.scad>;
d=0.05;
$fn=16;

tube_r = 22+0.5+3; //radius of large tube
tube_to_rack = 6; //separation between 
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
module cable_tie(inner_r,center=false){
	annulus(inner_r+2,2,5,center=center);
}


difference(){
    union(){    
        hull(){
            translate([0,1,0]) cube([w,d,h], center=true);
            reflect([1,0,0]) translate(tube_centre) rotate(angle_subtended/2) translate([0,-tube_r-hook_t/2,0]) cylinder(h=h, d=hook_t, center=true);
        }
        translate(tube_centre) rotate(angle_subtended/2) translate([0,-tube_r-hook_t/2,0]) sequential_hull(){
            cylinder(h=h, d=hook_t, center=true);
            translate([hook_t*0.5,-hook_t*2,0]) cylinder(h=h, d=hook_t, center=true);
            translate([-hook_t*0.25,-hook_t*3,0]) cylinder(h=h, d=hook_t, center=true);
        }
    }
    //big tube
    translate(tube_centre) cylinder(r=tube_r, h=999,center=true, $fn=64);
    //rack
    rotate([0,90,0]){
        cylinder(r=rack_r, h=999,center=true, $fn=24);
        reflect([0,0,1]) translate([0,0,w/2-6]) cable_tie(rack_r);
    }
    
    //fixed end of elastic/bungee
    
    //attachment for two-sided velcro
    translate(tube_centre) for(a=[-40,0,40]) rotate(a+180){
        repeat([0,0,4,],2,center=true) cube([1.5,2*tube_r+2*tube_to_rack,1.5],center=true);
        translate([0,tube_r+tube_to_rack+5,0]) cube([1.5,10+1,4+1.5],center=true); 
    }
}