use <utilities.scad>;

module annulus(inner_r,thickness,h){
	difference(){
		cylinder(r=inner_r+thickness,h=h);
		cylinder(r=inner_r,h=99999,center=true);
	}
}
module cable_tie(inner_r){
	annulus(inner_r+2,2,5);
}


barrel_r = 50/2; //radius of lock barrel
shroud_r = 25.1/2+0.6; //radius of rubber shroud on the lock body
shroud_l = barrel_r + 8.5; //centre of barrel to end of shroud
//tapers to about 4.5 at outside edge of lock
shackle_r = 18/2;//+0.5; //radius of metal shackle (specced 18/2, got 17.5/2)
rack_r = 5; //radius of panner rack
rack_gap = 28; //width of gap between the outer bar on the rack and the other bar (or plate) used as an end-stop
t=3; //thickness of thinnest structural parts in XY
h=rack_r*2 + shroud_l - sqrt(barrel_r*barrel_r - shroud_r*shroud_r); //overall height
$fn=64;
d=0.05; //small distance

module top_holder(){
    difference(){
        hull(){
            translate([0,0,-rack_r]) cylinder(r=shroud_r+t, h=h);
            translate([0,-shackle_r-rack_r*2-rack_gap,0]) rotate([-30,0,0]) cube([2*shroud_r+2*t, d, rack_r*2/cos(30)],center=true);
        }
        
        //hole for the rubberised casing of the lock
        intersection(){
            translate([0,0,rack_r]) cylinder(r=shroud_r, h=h);
            union(){
                big_r = shroud_r / sin(atan(4.0/shroud_r));
                translate([0,-shroud_r,rack_r]) cube(999);
                translate([0,0,rack_r+big_r]) rotate([90,0,0]) cylinder(r=big_r,h=999,center=true);
            }
        }
        //hole for the shackle
        translate([0,0,-rack_r]) chamfered_hole(r=shackle_r, h=h);
        
        //indent for the lock body
        translate([0,0,rack_r+shroud_l]) rotate([0,90,0]) cylinder(r=barrel_r,h=999,center=true);
        
        //indent for cable ties round the outside
        difference(){
            translate([-99,0,-rack_r+1]) cube([999,999,2*rack_r-1]);
            resize([shroud_r+t+1,shroud_r+t-0.5,999]*2) cylinder(r=shroud_r,h=999,center=true);
        }
        
        //rack
        translate([0, -shackle_r-rack_r-d,0]) rotate([0,90,0]){
            //rack bar, with 45 degree cut-out for entry
            hull() repeat([100,-50,0],2)cylinder(r=rack_r,h=999,center=true);
            //cable ties (optional)
            reflect([0,0,1]) translate([0,0,shroud_r+t-3.5-2]) annulus(rack_r+2,2,3.5);
        }
    }
}

//module bottom_clip(){
top_holder();  