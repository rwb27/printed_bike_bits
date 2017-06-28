/*

A chain guard that cable-ties on to a bike wheel (with holes for M3 bolts, should you elect to tap holes into your chainring).
(c) Richard Bowman 2017, released under CERN OHL

*/

use <utilities.scad>; //this can be found in the OpenFlexure Microscope repository, I put it in my include path.

d=0.05;

chainring_t = 2; //thickness of chainring
chain_t = 7.1; //thickness (width) of chain
echo("step height (ring to chain edge)",(chain_t-chainring_t)/2);
n_teeth = 34; //size of chainring
pitch_r = n_teeth*12.7/(2*3.14)/cos(180/n_teeth); //distance from centre to link pins
echo("pitch_r",pitch_r);
chain_height = 8.5; //height of chain (size perpendicular to link pins)
chainring_inner_r = 97/2-0.3; //radius of the cut-out in the chainring
lug_w = 16.3; //width of mounting lugs (for the bolts that attach to the spider)
bolt_d = 12; //diameter of mounting bolt
bcd = 74; //bolt circle diameter of mounting bolts
n_bolts = 5;
outer_r = pitch_r + chain_height-1; //maximum diameter of the guard (slightly above chain)
overall_t = 4.7; //thickness of the whole guard

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
        sequential_hull($fn=n_teeth*2){
            translate([0,0,0]) cylinder(r=chainring_inner_r, h=d);
            translate([0,0,chainring_t/2]) cylinder(r=chainring_inner_r, h=d);
            translate([0,0,chainring_t/2]) cylinder(r=under_chain_r, h=d);
            translate([0,0,chain_t/2]) cylinder(r=under_chain_r, h=d);
            translate([0,0,chain_t/2+0.5]) cylinder(r=under_chain_r+0.5, h=d);
            translate([0,0,chain_t/2+0.5]) cylinder(r=pitch_r, h=d);
            translate([0,0,overall_t+chainring_t/2-1]) cylinder(r=outer_r, h=1);
        }
        
        //chainring();
        difference(){
            cylinder(r=chainring_inner_r-2, h=999, center=true);
            for(i=[1:n_bolts]) rotate(i/n_bolts*360) hull(){
                translate([0,999,0]) cube([lug_w+8,999*2-bcd,999],center=true);
                translate([0,bcd/2,0]) cylinder(d=lug_w+8,h=999, center=true);
            }
        }
        
        for(i=[1:n_bolts]) rotate(i/n_bolts*360){
            //cut the locating lip to allow clearance for the spider
            translate([0,999,0]) cube([lug_w+9,999*2,chainring_t],center=true);
            translate([0,bcd/2,0]) cylinder(d=bolt_d, h=999, center=true); //clearance for mounting bolts
            translate([0,chainring_inner_r+5,0]) cylinder(d=3.5, h=999, center=true); //mounting M3 bolts (req. tapping)
            reflect([1,0,0]) translate([lug_w/2+0.8,chainring_inner_r-5,0]) cube([2,4,999],center=true); //c. tie
        }
    }
}

module wedge_144(){
    union(){
        rotate(72) cube(999);
        rotate(90-72) cube(999);
    }
}

//chainring();

intersection(){
    rotate([0,180,0]) union(){
    
        difference(){
            guard_ring();
            wedge_144();
        }

        translate([0,3,0])
        intersection(){
            guard_ring();
            wedge_144();
        }
    }
    
    //cylinder(r=chainring_inner_r+5, h=chainring_t+2, center=true); //test fit of inner_r
    //translate([0,-999,0]) cube([10,999*2,999],center=true);
}