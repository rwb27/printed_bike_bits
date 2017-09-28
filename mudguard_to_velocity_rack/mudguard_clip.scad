/*

    My bike has a front brake mount where the nut sits inside the
    frame.  That makes it hard to attach a rack.  This adapter sits
    around the brake mount (like a washer) and I screw into it from below to attach the mudguard.
    
    (c) R Bowman 2017, released under CERN open hardware license
    
*/

use <utilities.scad>;

mg_w = 35;
mg_h = mg_w/2 + 5;
mg_r = mg_w/4;

module mudguard(h=999,center=false, offset=0){
    linear_extrude(h,center=center){
        offset(offset) hull() reflect([1,0,0]){
            translate([-mg_w/2,0]) square(1);
            translate([-mg_w/2+mg_r, mg_h-mg_r]) circle(mg_r);
        }
    }
}



difference(){
    mudguard(h=6,offset=4);
    mudguard();
    cube([mg_w-2,10,999],center=true);
}