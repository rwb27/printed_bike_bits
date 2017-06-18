use <../utilities.scad>;
use <../standard_optomechanics/cylinder_clamp.scad>;
use <./cylinder_clip.scad>;

rack_r = 10/2+0.3;
lock_r = 24/2+0.4;
h=10;
lock_pos = [13,30,-h/2];
d=0.05;

module annulus(inner_r,thickness,h){
	difference(){
		cylinder(r=inner_r+thickness,h=h);
		cylinder(r=inner_r,h=99999,center=true);
	}
}
module cable_tie(inner_r){
	annulus(inner_r+2,2.25,5.5);
}


union(){
    {
        $fn=64;
        rack_r = 10/2-0.1;
        t=2.5;
        standoff = lock_pos[0]*23/25 - lock_r*2/25;
        cr = 2.5;

        difference(){
            union(){
                scale([1,25/23,1]) cylinder_clip(r=lock_r,t=t,flat_t=standoff,flat_w=2*lock_r+2*t,h=h,opening_angle=90);
                translate([lock_r,-lock_r-standoff-t,0]) hull(){
                    cube([15,7,h]);
                    cube([d,lock_r+standoff+3*t,h]);
                }
            }
  
//            reflect([1,0,0]) 
            translate([(-lock_r+cr),-lock_r-standoff+t+cr,-1]) difference(){
                mirror([1,0,0]) mirror([0,1,0]) cube([999,999,999]);
                cylinder(r=t+cr,h=999,center=true);
            }
            
            translate([-lock_r+cr,-lock_r-standoff+t+cr,0]) hull() repeat([lock_r-cr,0,0],2) cylinder(r=cr,h=999,center=true);
            translate([-2.5,-lock_r-standoff+2*t,-1]) cube([5,9999,9999]);
            
            translate([0,-standoff-rack_r-lock_r+1,rack_r]) rotate([0,90,0]){
                cylinder(r=rack_r,h=999,center=true);
                translate([0,0,7+lock_r]) cable_tie(rack_r);
            }
        }
    }
}