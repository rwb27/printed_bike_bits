use <../utilities.scad>;
use <../standard_optomechanics/cylinder_clamp.scad>;

bar_to_bag = 65;
bar_r = 26/2+0.3;
bag_y = bar_r + bar_to_bag;
pocket = [85.5,10,36.8];
clip=[15,pocket[1],pocket[2]];
lip = [clip[0], 4.5, 4];

d=0.05;

module rh_clamp(){
    difference(){
        union(){
            rotate([0,90,180]) cylinder_clamp(bar_r, clip[0], 
                        clamp_t=3, flat_t=bar_to_bag-clip[1]+d, flat_width=clip[2], mounting_bolt=0 );
            
            translate([0,bar_to_bag+bar_r,0]){
                translate([0,-clip[1]/2,0]) cube(clip,center=true);
                translate([-lip[0]/2,-lip[1],clip[2]/2-d]) cube(lip);
            }
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
        rotate([-30,0,0]) hull() repeat([0,bar_r+10,0],2) rotate([0,90,0]) cylinder(h=999,r=3,center=true);
    }
}

//reflect([1,0,0]) translate([-clip[2]/2-10-20,0,0]) 
rotate([0,-90,0]) rh_clamp();

/*rotate([0,-90,0]) intersection(){
    rh_clamp();
    translate([999/2,bag_y,0]) cube([999,24,999],center=true);
}*/