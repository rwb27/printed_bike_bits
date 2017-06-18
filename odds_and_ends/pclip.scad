use <utilities.scad>;

//This is a P clip to attach things to my Tortec Velocity rear rack

rack_r = 10/2;
t = 1.5;
plate_length = 18;
plate_t = 3;
h=9;
$fn=32;
pclip_spacing = 35;

module pclip_with_plate(){
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
        translate([rack_r+h/2,rack_r/2/2-rack_r-t+plate_t,h/2]) mirror([0,1,0]) pinch_y(3,t=plate_t-0.5,gap=[h*2,rack_r/2,999],top_access=true);
        // the mounting slot
        translate([rack_r+h+3*1.2,0,h/2]) hull() repeat([plate_length-h-plate_t-3*1.2,0,0],2) rotate([90,0,0]) cylinder(r=3/2*1.2,h=999,center=true);
            
    }
}

module pclip(){
    difference(){
        union(){
            // go round the rack, plus space for the bolt
            hull(){
                cylinder(r=rack_r+t, h=h);
                translate([rack_r,-rack_r-t,0]) cube([h,2*rack_r+2*t,h]);
            }
        }
        // the rack
        cylinder(r=rack_r,h=999,center=true);
        // the pinching bolt
        extra_t=0.25;
        translate([rack_r+h/2,rack_r/2-rack_r+extra_t,h/2]) mirror([0,1,0]) pinch_y(3,t=t+extra_t,gap=[h*2,rack_r,999],top_access=true,extra_height=0);
            
    }
}



module mudguard_mount(h=2,extra_h=3,spacing=pclip_spacing, slot_l=1){
    difference(){
        hull(){
            reflect([1,0,0]) translate([spacing/2,0,0]) cylinder(r=4,h=h);
            cylinder(r=7,h=h+extra_h);
        }
        // M3 mounting bolts to P clips
        reflect([1,0,0]) translate([spacing/2,0,0]) hull() repeat([-slot_l,0,0],2) cylinder(r=3/2*1.15,h=999,center=true);
        // flatten the ends so bolts go on nicely
        reflect([1,0,0]) translate([spacing/2,0,h]) hull() repeat([-slot_l,0,0],2) cylinder(r=4.5,h=999);
        // M6 nut to mount central bolt for mudguard
        translate([0,0,h]) nut(6,shaft=true);
    }
}
mudguard_mount(slot_l=3, spacing=35+1); //front


//pclip();

//reflect([0,1,0]) translate([0,rack_r+2*t,0]) pclip();
