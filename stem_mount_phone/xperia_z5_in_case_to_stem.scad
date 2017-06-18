/*

Mount to attach Xperia Z5 phone to my bike stem

(c) 2016 Richard Bowman, released under CERN open hardware license

*/

use <utilities.scad>;
d = 0.05;
$fn=16;
bar_z = -32/2-11-14;

module annulus(inner_r,thickness,h,center=false){
	difference(){
		cylinder(r=inner_r+thickness,h=h,center=center);
		cylinder(r=inner_r,h=99999,center=true);
	}
}
module cable_tie(inner_r,center=false){
	annulus(inner_r+1.5,2.5,5,center=center);
}
module phone(h=135){
    phonebox=[67+0.5,h,11.4];
    case_t=11;
    case_rroc=1.5;
    union(){
        translate([-phonebox[0]/2,0,-d]) cube(phonebox);
        hull(){
            translate([-phonebox[0]/2-7+case_t/2,0,-case_t/2]) rotate([-90,0,0]) cylinder(d=case_t,h=h);
            translate([phonebox[0]/2,0,-case_rroc*0.7]) rotate([-90,0,0]) cylinder(r=case_rroc,h=h);
            translate([phonebox[0]/2,0,-case_t+case_rroc]) rotate([-90,0,0]) cylinder(r=case_rroc,h=h);
        }
    }
}

module handlebar(){
    clamp_w = 43;
    clamp_roc = 5;
    clamp_h = 11;
    bar_r = 32/2;
    union(){
        rotate([0,90,0]) cylinder(r=bar_r,h=150,$fn=32, center=true);
        rotate([-90,0,0]) hull(){
            reflect([1,0,0]) reflect([0,1,0]) 
                translate([clamp_w/2-clamp_roc,clamp_h+bar_r-clamp_roc,0]) 
                cylinder(r=clamp_roc,h=bar_r*3,center=true);
        }
    }
}

module top_mount(h=22, top_t=1){
    difference(){
        hull(){
            rotate([-90,0,0]) linear_extrude(h, center=true){
                minkowski(){
                    circle(r=1.5);
                    projection() rotate([90,0,0]) phone();
                }
            }
            translate([0,0,bar_z]) cube([(28+3)*2,h,d],center=true);
        }
        translate([0,-135+h/2-top_t,0]) phone();
        translate([0,0,bar_z]) handlebar();
        //cable ties
        reflect([1,0,0]) translate([28,0,bar_z]) rotate([0,90,0]) cable_tie(32/2+3, center=true, $fn=32);
    }
}
module bottom_mount(h=22, top_t=1){
    difference(){
        hull(){
            rotate([-90,0,0]) linear_extrude(h, center=true){
                minkowski(){
                    circle(r=1.5);
                    projection() rotate([90,0,0]) phone();
                }
            }
            translate([0,0,bar_z]) cube([25,h,d],center=true);
        }
        translate([0,0,-1]) cylinder(r=999,h=999,$fn=8);
        translate([0,-135/2,0]) phone();
        translate([0,0,bar_z]) rotate([90,0,0]) cylinder(d=32,h=100,center=true,$fn=32);
        //cable ties
        translate([0,0,bar_z]) rotate([90,0,0]) cable_tie(32/2+2, center=true, $fn=32);
        //anchor points
        reflect([1,0,0]) translate([20,0,bar_z/2]) rotate([90,0,0]) cylinder(d=6,h=999,center=true);
    }
}

rotate([-90,0,0]) bottom_mount();//h=0.5,top_t=-1);

//rotate([-90,0,0]) top_mount();//h=0.5,top_t=-1);