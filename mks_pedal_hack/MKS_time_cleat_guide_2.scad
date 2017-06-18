/* A plastic guide that sits on my MKS Urban Step In pedals to stop me clipping in to the back of them. 

Released under CERN open hardware license, Richard Bowman, 2016
*/

/*
The origin is on the plane of the platform side of the pedal (that's z=0) with y=0 
at the outside edge of the rear wire.  x=0 is the centre of the cleat.
*/
use <utilities.scad>;

wire_top=37-1.0; //top of the gripping wire
d = 0.05; //a small distance

module y_w_h_point(y,w,h){
    translate([0,y,0]) cube([w,d,2*h],center=true);
}

module pedal_bits_front(){
    union(){
        //ensure we don't protrude under the wire or above it
        //translate([0,-999+4,0]) cube(999*2,center=true);
        //translate([0,0,999+wire_top-1]) cube(999*2,center=true);
        
        sequential_hull(){
            y_w_h_point(0, 6, 25);
            y_w_h_point(9.5, 6, 25);
            y_w_h_point(14, 6, 22);
            hull(){
                y_w_h_point(11, 17, 22);
                y_w_h_point(11, 21, 17);
            }
            hull(){
                y_w_h_point(27, 15, 22);
                y_w_h_point(30, 18, 17);
            }
            y_w_h_point(30, 6, 17);
            y_w_h_point(36, 6, 7.67);
        }
        
        //spring
        translate([0,5,19]) rotate([0,90,0]) cylinder(d=13,h=50, center=true);
        //adjusting bolt
        //translate([0,18.5, 21]) cylinder(d1=10, d2=16, h=wire_top-21);
        translate([0,19.5, 21]) cube([10,12,(wire_top-21)*2],center=true);
    }
}

module guide_front(){
    rotate([atan((wire_top-1-25)/(29-4))+180,0,0]) difference(){
        hull(){
            translate([0,4,wire_top-1]) cube([20,d,d],center=true);
            translate([0,29,25]) cube([18,d,d],center=true);
            translate([0,4,18]) cube([20,d,d],center=true);
            translate([0,32,15]) cube([28,d,d],center=true);
        }
        pedal_bits();

        //cable tie point
        translate([0,16, 27]) cube([60,5,3],center=true);
    }
}

module rz_point(r,z){
    translate([0,0,z]) cylinder(r=r, h=d, center=true);
}

module guide_back(){
    axle_h = 17.5;
    back_edge = [0,39.6+0.25,10.3]; //upped this for a tighter fit
    pivot = [0,30,23];
    w = 18;
    difference(){
        union(){
            // main body of guide, with thin flexible part 
            sequential_hull(){
                translate([0,0,axle_h]) rotate([-atan((axle_h-back_edge[2])/back_edge[1]),0,0]) translate([0,7,0]) cube([w,7/2,8],center=true);
                translate([-w/2,16,axle_h-3]) cube([w,d,30-axle_h+3]);
                translate([-w/2,16,axle_h-3]) cube([w,1,wire_top-axle_h+3]);
                translate([-w/2,pivot[1],back_edge[2]-4]) cube([w,d,pivot[2]-back_edge[2]+4]);
                //translate(back_edge+[0,-1,-3.5]) cube([w,3,10],center=true);
                translate(back_edge+[0,1,-2]) cube([w,3,13],center=true);
            }
        }
        
        //axle
        translate([0,0,axle_h]) rotate([0,90,0]) reflect([0,0,1]) sequential_hull(){
            rz_point(7.3,0);
            rz_point(7.5,3);
            rz_point(9,12);
        }
        
        //back edge
        roc = 60;
        difference(){
            translate([-999,0,back_edge[2]-10]) cube([2,2,0]*999 + [0,0,10]);
            translate(back_edge-[0,roc,0]) sequential_hull(){
                $fn=64;
                rz_point(roc,0);
                rz_point(roc,-5.5);
                rz_point(roc+10,-5.5-10);
            }
        }
        
        //horizontal bolts near back
        translate(back_edge+[0,-6,0]) rotate([0,90,0]) cylinder(d=6,h=999,center=true);
//        translate(back_edge+[0,-4,5]) rotate([0,90,0]) cylinder(d=6,h=999,center=true);
        
        //flexible part, with bolts to jam it in
        translate(pivot) rotate([-30,0,0]){
            repeat([12,0,0], 2, center=true) translate([0,0,-4]) mirror([0,0,1]){
                cylinder(d=5.5,h=999, $fn=16);
                translate([0,0,7]) cylinder(d1=5.5, d2=15.5,h=25, $fn=16);
            }
            hull(){ //cut out a wedge so it can bend
                translate([0,0,-4]) rotate([0,90,0]) cylinder(r=2,h=999,center=true, $fn=16);
                translate([0,0,-40]) rotate([0,90,0]) cylinder(r=2,h=999,center=true, $fn=16);
            }
        }
    }
}

guide_back();