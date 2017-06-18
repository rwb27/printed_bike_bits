/*

A strong clip for attaching something to a cylindrical rod, designed to be good for diameters of abour 10mm.

This uses flex in the plastic, and has been designed to avoid, as far as possible, concentrating stress anywhere that is likely to make it crack.  I intend to use it for clipping stuff together on my bike to stop it rattling, so it should be able to handle moderately large shock loads in X.

(c) Richard Bowman 2016, released under CERN open hardware license.  
If you want to use it in something closed-source that's probably fine, but please contact me first (my.name@cantab.net).

*/

use <utilities.scad>;

d=0.05;
$fn=32;

module arc(r,angle, h=1, t=1, endcap="none"){
    a=angle/2;
    union(){
        intersection(){
            difference(){
                cylinder(r=r+t/2, h=h);
                cylinder(r=r-t/2, h=4*h, center=true);
            }
            linear_extrude(4*h, center=true){
                polygon([[0,0],
                         [sin(180-a), cos(180-a)],
                         [sin(180-a/2), cos(180-a/2)],
                         [0,-1],
                         [-sin(180-a/2), cos(180-a/2)],
                         [-sin(180-a), cos(180-a)],
                         [0,0]]*2*r);
            }
        }
        reflect([1,0,0]) rotate(a-90) translate([r,0,0]){
            if(endcap=="d") translate([-t/2,0,0]) cube([t,d,h]);
            if(endcap=="round") cylinder(d=t,h=h);
        }
    }
}

module cylinder_clip_strong(r, t, angle=225, rc=2, support_angle=0, h=10, back_to_tube=6){
    a = 180-angle/2;
    back = -r-back_to_tube;
    front_vertex = [sin(a),cos(a),0]*(r+t/2+rc); //centre of curved ends of the clip
    support_l = (front_vertex[1]-back-t/2-rc)/cos(support_angle); //length of straight part at the edge
    back_vertex = [front_vertex[0]+support_l*sin(support_angle), back+t/2+rc,0]; //centre of curve that joins clip to back
    union(){
        arc(r+t/2, angle, h=h, t=t,endcap="d"); //this grips the rod
        //this part joins the front of the clip to the back of the mount
        reflect([1,0,0]){
            translate(front_vertex) 
                rotate(-135-a/2+support_angle/2) arc(rc, 270-a-support_angle, h=h, t=t, endcap="d");
            translate(back_vertex) rotate(support_angle) translate([rc-t/2,0,0]) cube([t,support_l,h]);
            translate(back_vertex) rotate(45+support_angle/2) arc(rc, 90+support_angle, h=h,t=t,endcap="d");
        }
        translate([-back_vertex[0],back,0]) cube([back_vertex[0]*2,t,h]);
    }
}

//cylinder_clip_strong(10/2,1.5, back_to_tube=4);
module lock_to_rack_bottom(){
    difference(){
        h=10;
        rack_r=10/2;
        lock_r=18/2;
        back_w=30;
        union(){
            cylinder_clip_strong(lock_r,2,250, h=h, support_angle=15, back_to_tube=5);
            translate([-back_w/2,-lock_r-5-3,0]) cube([back_w,3+d,h]);
        }
        translate([0,-lock_r-5-rack_r,h/2]) rotate([0,90,0]) cylinder(r=rack_r,h=999,center=true);
        reflect([1,0,0]) translate([-back_w/2,-lock_r-5-3,0]) cylinder(r=3,h=999,center=true);
        reflect([1,0,0]) translate([-back_w/2+3,-lock_r-5-rack_r,h/2]) rotate([0,90,0]) arc(rack_r+3.5, 360, t=2, h=5);
        
    }
}
module lock_stopper(r=18/2,h=10,t=2){
    difference(){
        hull(){
            cylinder(r=r+t, h=h, center=true);
            translate([r+2,0,0]) cube([h,2*sqrt(r*r-(r-3)*(r-3))+8,h],center=true);
        }
        translate([0,0,-h/2]) chamfered_hole(r=r,h=h);
        translate([r+2,0,0]) pinch_y(3,gap=[20,4,20],t=sqrt(r*r-(r-3)*(r-3))-2, nut_l=999);
        //cylinder(r=999,h=999,$fn=8);
    }
}

//lock_stopper();
lock_to_rack_bottom();          
