//use <../standard_optomechanics/cylinder_clamp.scad>;
//use <cylinder_clip.scad>;
use <utilities.scad>;

t = 3;
h = 12;
clamp_h = 30;
inner_r = 20.1;
rack_r = 5+0.3;

tube_to_tube = 15;
c2c_distance = (inner_r + rack_r + tube_to_tube);
//rack_angle = -90-asin( (inner_r - rack_r) / c2c_distance);

d=0.05;

module rack_frame(){
    translate([-rack_r-3,c2c_distance,0]) children();
}

module rack(){
	rack_frame() translate([0,0,h/2]) rotate([0,6,0]){
		hull() repeat([0,999,0],2) cylinder(r=rack_r,h=999*2,center=true);
        translate([0,0,h/2]) cylinder(r=rack_r+4.5,h=999);
    }
}

union(){
	difference(){
		union(){
			hull(){ //this bit holds the rack tube
                cylinder(r=inner_r+t,h=clamp_h);
				rack_frame() cylinder(r=rack_r+3,h=h);
                translate([2,-inner_r-5,clamp_h/2]) cube([17,10,clamp_h],center=true);
			}
		}
        
        chamfered_hole(r=inner_r,h=clamp_h); //hole for seat tube
		translate([0,-inner_r-5,h/2]) rotate(90) pinch_y(4,t=5, nut_l=999,screw_l=10,extra_height=0,gap=[20,4,999]); //clamping screw
		translate([0,-inner_r-5,clamp_h-h/2]) rotate(90) pinch_y(4,t=5, nut_l=999, screw_l=10,extra_height=0); //clamping screw

		//clearance for rack
		rack();
        //cut off so we can get the rack in
		rack_frame() translate([0,2.5+999,0]) cube([1,1,1]*999*2,center=true);
        //cut-out for the velcro tie
        rack_frame() difference(){
            translate([0,0,h/2]) cylinder(r=rack_r+8,h=h-5,center=true);
            cylinder(r=rack_r+5,h=999,center=true);
        }
	}
}


