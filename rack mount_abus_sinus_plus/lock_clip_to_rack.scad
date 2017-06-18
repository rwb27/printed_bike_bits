use <../utilities.scad>;
use <./cylinder_clip.scad>;

$fn=64;
d=0.05;

tube_r = 10.5/2;
lock_r = 14/2-0.5;
separation = 14;
h = 12;
wrap = 4;

module annulus(inner_r,thickness,h,center=false){
	difference(){
		cylinder(r=inner_r+thickness,h=h,center=center);
		cylinder(r=inner_r,h=99999,center=true);
	}
}
module cable_tie(inner_r,center=false){
	annulus(inner_r+2,2,5,center=center);
}
module rotate_and_clip(){
    intersection(){
        translate([0,0,h/2]) cube([999,999,h],center=true);
        translate([0,0,h/2]) rotate([0,-15,0]) translate([0,0,-h/2]) children();
    }
}

difference(){
    union(){
        rotate_and_clip() translate([0,0,-999/2]) cylinder_clip(r=lock_r,t=3,flat_t=2,h=999,flat_w=15);
        hull(){
            translate([-15,-separation-lock_r-wrap,0]) cube([30,wrap+3,h]);
            rotate_and_clip() translate([-7.5,-lock_r-1,-999/2]) cube([15,d,999]);
        }
    }
    
	translate([0,-lock_r-separation-tube_r,h/2]) rotate([0,90,0]){
		cylinder(r=tube_r,h=999,center=true);
		repeat([0,0,10],3,center=true) cable_tie(tube_r,center=true);
	}
}