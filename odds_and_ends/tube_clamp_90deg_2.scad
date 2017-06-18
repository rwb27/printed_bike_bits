use <../standard_optomechanics/cylinder_clamp.scad>;
use <../utilities.scad>;

t = 2;
h = 12;
inner_r = 22;
nut_flat = 12;
mount_x = inner_r+8;
d=0.05;
$fn=64;


difference(){
    union(){
        hull(){
            cylinder(r=inner_r+t,h=h);
            translate([-8,inner_r,0]) cube([6.5,nut_flat,h]);
        }
        intersection(){
            cube([mount_x,inner_r+nut_flat,h]);
            hull(){
                translate([0,inner_r,0]) cube([mount_x,nut_flat,h]);
                cube([inner_r+t,d,h]);
            }
        }
    }
    
    //gap for pinch
    translate([0,inner_r,0]) cube([3,inner_r*2,999],center=true);
    
    //screw and nut
    translate([-4,inner_r+nut_flat/2,h/2]) rotate(90) nut_y(4,shaft=true,top_access=true, extra_height=0.4);
    
    //tube
    chamfered_hole(r=inner_r,h=h);
    
    
}