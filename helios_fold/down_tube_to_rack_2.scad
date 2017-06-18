//use <../standard_optomechanics/cylinder_clamp.scad>;
//use <cylinder_clip.scad>;
use <utilities.scad>;

t = 3;
h = 12;
inner_r = 20.1;
rack_r = 5+0.3;

tube_to_tube = 12.5;
c2c_distance = (inner_r + rack_r + tube_to_tube);
rack_angle = -90-asin( (inner_r - rack_r) / c2c_distance);

d=0.05;

module rack_frame(){
    rotate(rack_angle) translate([0,c2c_distance,0]) children();
}

module rack(){
	 rack_frame() rotate([0,6,0]) //rotate([0,2.5,-90])
				hull() repeat([0,999,0],2) cylinder(r=rack_r,h=999*2,center=true);
}

union(){
	difference(){
		union(){
			hull(){ //this bit holds the rack tube
                cylinder(r=inner_r+t,h=h);
				rotate(18) translate([inner_r+t/2,0,0]) cylinder(r=t/2,h=h);
				rack_frame() cylinder(r=5+4,h=h);
                translate([2,-inner_r-5,h/2]) cube([16,10,h],center=true);
			}
		}
        
        chamfered_hole(r=inner_r,h=h);
		translate([0,-inner_r-5,h/2]) rotate(90) pinch_y(4,t=4, top_access=true,screw_l=10,extra_height=0);
        
        //clearance for nut/bolt
        //translate([0,-inner_r-5,h/2]) cube([30,8,h-3],center=true);

		//clearance for rack
		rack();
		rack_frame() translate([0,4+999,0]) cube([1,1,1]*999*2,center=true);
//		translate(rack + [0,-4,-1]) mirror([1,0,0]) mirror([0,1,0]) cube([1,1,1]*999);
	}
}


