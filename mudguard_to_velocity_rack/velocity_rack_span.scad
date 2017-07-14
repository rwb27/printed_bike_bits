use <utilities.scad>;

//This is a P clip to attach things to my Tortec Velocity rear rack

rack_r = 10/2;
t = 1.5;
c2c = 58; // centre-to-centre distance between rack tubes at bottom
tube_angle = -atan(0.19);
plate_t = 3;
h=14;
d=0.05;

module annulus(inner_r,thickness,h,center=false){
	difference(){
		cylinder(r=inner_r+thickness,h=h,center=center);
		cylinder(r=inner_r,h=99999,center=true);
	}
}
module cable_tie(inner_r,center=false){
	annulus(inner_r+2,2.5,5.5,center=center);
}

module rack_frame(dx=0){
    // transform (and reflect) things relative to the rack stays
    reflect([1,0,0]) translate([c2c/2+dx,0,0]){
            rotate([0,tube_angle,0]) children();
    }
}

rotate([-90,0,0])
difference(){
    hull(){
        rack_frame(dx=-2) translate([0,-rack_r,0]) cube([d,rack_r*2,h]);
        translate([0,0,h/2]) rotate([90,0,0]) cylinder(d=h,h=2*rack_r, center=true);
    }
    
    // rack supports
    rack_frame() cylinder(r=rack_r, h=999, center=true);
    
    // cable ties
    rack_frame() translate([0,0,h/2+1.5]) cable_tie(rack_r,center=true);
    
    // nut trap for M6 mudguard mount
    translate([0,-1,h/2]) rotate([90,0,0]) nut(6, shaft=true);
}