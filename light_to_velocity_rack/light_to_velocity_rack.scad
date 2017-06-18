use <utilities.scad>;

light_hole = [-25,-12,0];
light_hole_r = 5/2*1.15;
rack_hole = [0,0,0];
rack_halfhole = [0,0,-19];
rack_hole_r = 7/2*1;
d=0.05;
$fn=32;

rotate([90,0,0])
difference(){
    union(){
        translate(light_hole - [5,0,5]) cube([-2*light_hole[0]+10, 5, 10]);
        hull(){
            translate(light_hole + [5,d,-10]) cube([-2*light_hole[0]-10,d,15]);
            translate([-15,-d,rack_halfhole[2]]) cube([30,d,-rack_halfhole[2]+5]);
            translate(rack_hole) rotate([90,0,0]) cylinder(r=light_hole_r+6, h=rack_hole[1]-light_hole[1]);
        }
        translate(rack_hole) rotate([90,0,0]) cylinder(r=rack_hole_r, h=4, center=true);
        translate(rack_halfhole-[0,d,0]) intersection(){
            rotate([-90,0,0]) cylinder(r=rack_hole_r, h=2);
            cylinder(r=999,h=999,$fn=8);
        }
    }
    
    reflect([1,0,0]) translate(light_hole) rotate([90,0,0]) cylinder(r=light_hole_r,h=999,center=true);
    
    translate(rack_hole) rotate([90,0,0]) cylinder(r=light_hole_r, h=999, center=true);
    
    translate([rack_hole[0],light_hole[1],rack_hole[0]]) rotate([-90,0,0]) cylinder(r1=light_hole_r+8, r2=light_hole_r, h=8,center=true);
}