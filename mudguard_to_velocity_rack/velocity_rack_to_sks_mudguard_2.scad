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
            // go round the rack, plus space for the bolt
            hull(){
                cylinder(r=rack_r+t, h=h);
                translate([rack_r,-rack_r-t,0]) cube([h,2*rack_r+2*t,h]);
            }
            // plate to mount things to
            hull(){
                translate([rack_r,-rack_r-t,0]) cube([plate_length,plate_t,h]);
                translate([rack_r+plate_length+t-h/2,-rack_r-t,h/2]) rotate([-90,0,0]) cylinder(r=h/2,h=plate_t);
            }
        }
        // the rack
        cylinder(r=rack_r,h=999,center=true);
        // the pinching bolt
        translate([rack_r+h/2,rack_r/2/2-rack_r-t+plate_t,h/2]) pinch_y(3,t=plate_t-0.5,gap=[rack_r,rack_r/2,rack_r],top_access=true);
        
    }
}

pclip();