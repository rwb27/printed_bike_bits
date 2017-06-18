use <../utilities.scad>;
use <../standard_optomechanics/cylinder_clamp.scad>;

bar_to_bag = 65;
bar_r = 26/2+0.3;
bag_y = bar_r + bar_to_bag;
pocket = [85,10,36.8];
clip=[15,pocket[1],pocket[2]];
lip = [clip[0], 4.5, 4];
screw_angles = [140, -10];

d=0.05;

module rh_clamp(){
    difference(){
        union(){
            hull(){
                rotate([0,90,0]) cylinder(h=clip[0], r=bar_r+3, center=true);
                translate([0,bar_to_bag+bar_r-1.5*pocket[1]+d,0]) cube(clip,center=true);
                rotate([screw_angles[1],0,0]) reflect([0,0,1]) rotate([0,90,0]) rotate(screw_angles[0]) translate([bar_r+6,0,0]) cube([10,8,clip[0]],center=true);
            }
            translate([0,bar_to_bag+bar_r,0]){
                translate([0,-clip[1]/2,0]) cube(clip,center=true);
                translate([-lip[0]/2,-lip[1],clip[2]/2-d]) cube(lip);
            }
        }
        
        //hole for handlebar
        rotate([0,90,0]) chamfered_hole(h=clip[0], r=bar_r,center=true);
        
        //fixing bolts
        rotate([screw_angles[1],0,0]) reflect([0,0,1]) rotate([0,90,0]) rotate(screw_angles[0]) translate([bar_r+6,0,0]){
            pinch_y(4,screw_l=8,gap=[30,2,20]);
            mirror([0,1,0]) translate([-4,3,0]) cube([8,4,999]);
        }
        
        //chamfer the edge
        assign(r=2){
            translate([clip[0]/2 - r, bag_y-pocket[1], clip[2]/2 - r]){
                difference(){ //radius the top corner of the pocket
                    cube([999,999,999]);
                    rotate([90,0,0]) cylinder(r=r,h=999*3,center=true);
                }
                for(a=[0, 5, 10, 15]) rotate([a,0,0]) translate([0,0,-pocket[2]+2*r - a/180*3.14*r/2]) mirror([0,0,1]) difference(){ //radius the bottom corner of the pocket & allow for swing
                    translate([-clip[0],0,0]) cube([999,999,999]);
                    rotate([90,0,0]) cylinder(r=r,h=999*3,center=true);
                    translate([-clip[0],-999,0]) cube([clip[0],999*2,r]);
                }
                
            }
        }
        
        //bolts to connect central clip
        reflect([0,0,1]) translate([0,bar_to_bag+bar_r-clip[1]-5, clip[2]/2-7]) rotate([0,90,0]){
            cylinder(r=4*1.1,h=999);
            cylinder(r=4/2*1.1,h=999,center=true);
        }
        //bolts to connect central reinforcement
        translate([0,bar_r + 15, 0]) repeat([0,bar_to_bag - 12*3 - clip[1],0],2) rotate([0,90,0]){
            cylinder(r=4*1.1,h=999);
            cylinder(r=4/2*1.1,h=999,center=true);
        }
        
        //brake cable clearance
        translate([0,bar_r+10,-bar_r-3]) hull() repeat([0,5,-10],2) rotate([0,90,0]) cylinder(h=999,r=3,center=true);
    }
}

module linker(){
    difference(){
        cube([pocket[0]-2*clip[0], 10, clip[2]],center=true);
        
        //tapped holes for mounting (M4)
        reflect([1,0,0]) reflect([0,0,1]) translate([pocket[0]/2-clip[0], 0,clip[2]/2-7]) rotate([0,90,0]) cylinder(r=3.5/2,h=30,center=true,$fn=16);
        
        //hole for actuating rod
        translate([0,5,0]) cube([30,8,999],center=true);
       
        //attachment for actuating rod 
//        translate([0,-5,-clip[2]/2]) cube([26+0.5,0.5,20*2+1],center=true); //pocket for the mount
        reflect([1,0,0]) translate([9,-2,-clip[2]/2+4]) rotate([-90,0,0]) nut(3,h=999,shaft=true);
    }
}

module clip(){
    w=26;
    t=3;
    reach=15;
    snib=[w,4,4];
    snib_z=-6;
    roc=(8-snib_z)/2;
    lever=30;
    difference(){
        union(){
            translate([-w/2,0,snib_z]) mirror([0,1,0]){
                translate([0,0,-snib_z]) cube([w,t,25]); //mount to clamp
                
                //clamp arm (flexes)
                translate([0,0,roc*2]) cube([w,lever-reach+d,t]);
                translate([0,lever-reach,roc]) rotate([0,90,0]) difference(){
                    cylinder(r=roc+t,h=w,$fn=32);
                    cylinder(r=roc,h=999,center=true,$fn=32);
                    translate([0,-999,0]) cube([1,1,1]*999*2,center=true);
                }
                translate([0,-reach-d,-t]) cube([w,lever+2*d,t]);
            }
            //snib
            translate([-w/2,reach,snib_z-t])hull(){
                cube([w,snib[1]+t,d]);
                cube([w,d,snib[2]+t]);
            }
            //actuator
            translate([-w/2,10-t, snib_z-t/2]) rotate([3,0,0]){
                cube([w,t,clip[2]-snib_z+10]);
                translate([0,-10+t,clip[2]-snib_z+10-t]) cube([w,10,t]);
            }
        }
        
        //mounting bolts
        reflect([1,0,0]) translate([9,-999+1,4]) rotate([-90,0,0]) cylinder(r=3*1.15/2,h=999,$fn=16);
    }
}

//reflect([1,0,0]) translate([-clip[2]/2-10-20,0,0]) 
//rotate([0,-90,0]) rh_clamp();
//rotate([90,0,0]) linker();
//rotate([0,-90,0]) clip();

reflect([1,0,0]) translate([pocket[0]/2-clip[0]/2,0,0]) rh_clamp(); //in situ
translate([0,bar_to_bag+bar_r-clip[1]-5,0]) linker();
#translate([0,bar_to_bag+bar_r-clip[1]-10,-clip[2]/2]) clip();

/*rotate([0,-90,0]) intersection(){
    rh_clamp();
    translate([999/2,bag_y,0]) cube([999,24,999],center=true);
}*/