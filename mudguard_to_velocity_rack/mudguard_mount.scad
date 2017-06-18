use <utilities.scad>;

d=0.05;

difference(){
    union(){
        cylinder(r=7.5,h=17); //body of mount, with cable tie groove
        cylinder(r=6.5,h=22);
        translate([0,0,20]) cylinder(r1=6.5,r2=7.5,h=1);
        translate([0,0,21-d]) cylinder(r=7.5,h=1+d);
    }
    cylinder(r=2.9,h=999,center=true); //M6 mounting bolt for mudguard
    translate([0,3-8-7,0]) cylinder(r=7,h=999,center=true);
}