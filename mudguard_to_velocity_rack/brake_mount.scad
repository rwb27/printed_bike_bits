/*

    My bike has a front brake mount where the nut sits inside the
    frame.  That makes it hard to attach a rack.  This adapter sits
    around the brake mount (like a washer) and I screw into it from below to attach the mudguard.
    
    (c) R Bowman 2017, released under CERN open hardware license
    
*/

brake_mount_d = 12;
hole_d = 6;
mounting_bolt = 4;
bottom_t = 1;
h = 8;

difference(){
    hull(){
        cylinder(h=h, d=brake_mount_d+2*2, $fn=32);
        translate([-brake_mount_d/2,-brake_mount_d/2-6,0]) cube([brake_mount_d,1,h]);
    }
    
    translate([0,0,bottom_t]) cylinder(h=h, d=brake_mount_d, $fn=32);
    translate([0,0,-1]) cylinder(h=999, d=hole_d, $fn=32);
    translate([0,0,h/2]) rotate([90,30,0]) cylinder(d=mounting_bolt*0.95, h=999);
}