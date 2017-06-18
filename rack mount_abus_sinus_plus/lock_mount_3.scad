use <../utilities.scad>;
d=0.05;
h=32;
rack_r = 9.5/2+0.1;
rack_t = 2;
rack_pos = [rack_r+1,-rack_r-rack_t-4,0];

module lock_fitting(h=10){
    //fits the Abus lock carrier
    t_y = 7;
    t_t = 5;
    t_w = 28;
    neck_w = 14.4-0.2;
    
    difference(){
        union(){
            //T-shaped bit that mates to the lock
            hull() reflect([1,0,0]) translate([(t_w-t_t)/2,t_y,0]) cylinder(r=t_t/2,h=h,$fn=16);
            translate([-neck_w/2,-d,0]) cube([neck_w,t_y+d,h]);
            translate([-rack_r-10+rack_pos[0],-4-d,0]) cube([neck_w/2-(-rack_r-10+rack_pos[0]),4+d,h]);
            
            //clamp
            translate(rack_pos){
                hull(){
                    cylinder(r=rack_r+rack_t,h=h,$fn=32);
                    translate([-rack_r-10,-rack_r-rack_t,0]) cube([10,2*rack_r+2*rack_t,h]);
                }
            }
        }
        
        //clamp stuff
        translate(rack_pos){
            chamfered_hole(r=rack_r,h=h); //hole for rack
            
            //pinch bolt
            translate([-rack_r-5,0,7]) repeat([0,0,h-7*2],2){
                mirror([0,1,0]) pinch_y(4,screw_l=8,gap=[15,2,999]);
                translate([-999,4,-3.7]) cube([999,4,7.4]); //nut access
            }
        }
        
        //fixing screw (just in case)
        translate([0,0,28]) rotate([-90,0,0]) cylinder(r=2,h=999,$fn=16);
    }
}

module lock_clip(){
    lock_r = 14/2-0.5;
}
lock_fitting(h=h);

