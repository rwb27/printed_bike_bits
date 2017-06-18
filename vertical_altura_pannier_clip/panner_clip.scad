use <../utilities.scad>;

roc=2;
d=0.05;
h=20;
pivot_y=18;
base_h=12;
base=[26,base_h,h];

$fn=32;
difference(){
    union(){
        translate([0,6,0]) cube(base,center=true);
        
        hull(){
            translate([0,pivot_y,0]) cylinder(r=roc+3,h=h,center=true);
            translate([0,d,0]) cube([roc*2+2*3,2*d,h],center=true);
        }
        
        translate([0,base_h-3,-h/2]) cube([50,3,h]);
        translate([50-d,base_h-3,-h/2]) rotate(20) cube([10,3,h]);
    }
    
    //cut-out for clip
    cube([2,pivot_y*2,999],center=true);
    translate([0,pivot_y,0]) cylinder(r=roc,h=999,center=true);
    translate([-roc,base_h,-999]) cube([roc*2,pivot_y-base_h,999*2]);
    
    translate([0,base_h-4,0]) rotate(90) pinch_y(3,nut_l=10,screw_l=base[0]/2,gap=[d,base[0]-12,d]);
    
    //rail
    cube([16,4.5*2,999],center=true);
    translate([0,4.5-1.3,0]) cube([21,2.6,999],center=true);
}