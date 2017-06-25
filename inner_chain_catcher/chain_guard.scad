/*

A chain guard that cable-ties on to a bike wheel (with holes for M3 bolts, should you elect to tap holes into your chainring).
(c) Richard Bowman 2017, released under CERN OHL

*/

use <utilities.scad>; //this can be found in the OpenFlexure Microscope repository, I put it in my include path.

d=0.05;

chainring_t = 2; //thickness of chainring
chain_t = 7.1 + 2; //thickness (width) of chain
n_teeth = 34; //size of chainring
pitch_r = n_teeth*12.7/(2*3.14); //distance from centre to link pins
chain_height = 8.5; //height of chain (size perpendicular to link pins)
chainring_inner_r = pitch_r - 15; //radius of the cut-out in the chainring
lug_w = 16; //width of mounting lugs (for the bolts that attach to the spider)
bcd = 74; //bolt circle diameter of mounting bolts
n_bolts = 5;
outer_r = pitch_r + chain_height; //maximum diameter of the guard (slightly above chain)
overall_t = 6; //thickness of the whole guard

//no need to change stuff under here...
under_chain_r = pitch_r - chain_height/2 - 1; //radius of the part that sits under the chain

//z=0 is the centre of the chainring.

module chainring(extra_r=0){
    difference(){
        cylinder(r=pitch_r+extra_r, h=chainring_t, center=true);
        
        difference(){
            cylinder(r=chainring_inner_r, h=999, center=true);
            
            for(i=[1:n_bolts]) rotate(i/n_bolts*360) translate([0,bcd/2,0]) hull() 
                repeat([0,999,0],2) cylinder(d=lug_w,h=999,center=true);
        }
    }
}
    
module guard_ring(){
    difference(){
        sequential_hull(){
            translate([0,0,0]) cylinder(r=chainring_inner_r, h=d);
            translate([0,0,chainring_t/2]) cylinder(r=chainring_inner_r, h=d);
            translate([0,0,chainring_t/2]) cylinder(r=under_chain_r, h=d);
            translate([0,0,chain_t/2]) cylinder(r=under_chain_r, h=d);
            translate([0,0,chain_t/2]) cylinder(r=pitch_r, h=d);
            translate([0,0,overall_t-1]) cylinder(r=outer_r, h=1);
        }
        
        //chainring();
        difference(){
            cylinder(r=chainring_inner_r-2, h=999, center=true);
            for(i=[1:n_bolts]) rotate(i/n_bolts*360) translate([0,999,0]) cube([lug_w,999*2-bcd,999],center=true);
        }
        
        for(i=[1:n_bolts]) rotate(i/n_bolts*360){
            //cut the locating lip to allow clearance for the spider
            translate([0,999,0]) cube([lug_w+8,999*2-bcd,chainring_t],center=true);
            translate([0,bcd/2,0]) cylinder(d=lug_w-3, h=999, center=true); //clearance for mounting bolts
            translate([0,chainring_inner_r+5,0]) cylinder(d=3.5, h=999, center=true); //mounting M3 bolts (req. tapping)
            reflect([1,0,0]) translate([lug_w/2,chainring_inner_r-2-2,0]) cylinder(r=2,h=999,center=true); //c. tie
        }
    }
}

//chainring();
guard_ring();