use <../utilities.scad>;
use <../standard_optomechanics/cylinder_clamp.scad>;
use <./cylinder_clip.scad>;

rack_r = 10/2+0.3;
lock_r = 6;
h=10;
lock_pos = [13,30,-h/2];

union(){/*
    cylinder_clamp(
        inner_r=rack_r, //radius of the cylinder being clamped (ish!)
        clamp_h=h, //thicknedess of the clamp along the cylinder axis
        clamp_t=2, //thickness of the clamp radially
        flat_t=2, //how thick the bottom of the clamp is (often need to allow for the mounting bolt head here)
        flat_width=0, //width of the flat base
        mounting_bolt=0, //nominal size of mounting bolt (default is 4 for M4, 0 to disable)
        nut_trap=false
        );
    
    hull(){
        translate([-6,rack_r+9,-h/2]) cube([4.5,1,h]);
        translate([-4.5,lock_pos[1],-h/2]) cube([3,3,h]);
    }*/
    translate(lock_pos)rotate(-90){
        $fn=64;
        rack_r = 10/2-0.1;
        t=3;
        standoff = lock_pos[0];
        cr = 2.5;

        difference(){
            cylinder_clip(r=lock_r,t=t,flat_t=standoff,flat_w=2*lock_r+2*t,h=h,opening_angle=90);
  
            reflect([1,0,0]) translate([-lock_r+cr,-lock_r-standoff+t+cr,-1]) difference(){
                mirror([1,0,0]) mirror([0,1,0]) cube([999,999,999]);
                cylinder(r=t+cr,h=999,center=true);
            }
            hull() reflect([1,0,0]) translate([-lock_r+cr,-lock_r-standoff+t+cr,0]) cylinder(r=cr,h=999,center=true);
            translate([-2.5,-lock_r-standoff+2*t,-1]) cube([5,9999,9999]);
            
            #translate([0,-standoff-rack_r-lock_r+1,rack_r]) rotate([0,90-5,0]) cylinder(r=rack_r,h=999,center=true);
        }
    }
}