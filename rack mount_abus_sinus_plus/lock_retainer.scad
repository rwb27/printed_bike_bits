use <../utilities.scad>;
use <../standard_optomechanics/cylinder_clamp.scad>;
use <./cylinder_clip.scad>;

rack_r = 10/2+0.3;
lock_pos = [15,30,0];
h=10;

union(){
    cylinder_clamp(
        inner_r=rack_r, //radius of the cylinder being clamped (ish!)
        clamp_h=h, //thicknedess of the clamp along the cylinder axis
        clamp_t=2, //thickness of the clamp radially
        flat_t=2, //how thick the bottom of the clamp is (often need to allow for the mounting bolt head here)
        flat_width=0, //width of the flat base
        mounting_bolt=0, //nominal size of mounting bolt (default is 4 for M4, 0 to disable)
        nut_trap=false
        );
    
    translate([-6,rack_r+9,-h/2]) cube([4.5,1,h]);
}