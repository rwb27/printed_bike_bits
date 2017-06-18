use <utilities.scad>;
rack_r = 10.5/2+0.3;

difference(){
    hull(){
        cylinder(r=rack_r+1.5,h=9);
        translate([-4,rack_r,0]) cube([8,9,9]);
    }
    
    chamfered_hole(r=rack_r,h=999,chamfer=0.25);
    translate([0,rack_r+9/2,9/2]) rotate(90) pinch_y(3,t=2,bolt_l=10);
}