use <utilities.scad>;

//This is a P clip to attach things to my Tortec Velocity rear rack

rack_r = 10/2;
t = 1.5;
plate_length = 20;
plate_t = 3;
h=9;

module pclip(){
    difference(){
        union(){
            hull(){
                cylinder(r=rack_r+t, h=h);
                translate([rack_r,-rack_r-t,0]) cube([h,2*rack_r+2*t,h]);
            }
            hull(){
                translate([rack_r,-rack_r-t,0]) cube([plate_length,plate_t,h]);
                translate([rack_r+plate+length+t-h/2,-rack_r-t,0]) rotate([90,0,0]) cylinder(r=h/2,h=t);
            }
        }
    }
}

pclip();