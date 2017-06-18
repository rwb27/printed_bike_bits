use <../utilities.scad>;
d=0.05;
bar_r=10.6/2;
lock_r=14/2+0.6;
angle=-11;

module annulus(inner_r,thickness,h){
	difference(){
		cylinder(r=inner_r+thickness,h=h);
		cylinder(r=inner_r,h=99999,center=true);
	}
}
module cable_tie(inner_r){
	annulus(inner_r+2,2,5);
}

%rotate([0,-angle,0]) difference(){
	union(){
		translate([-3,2+bar_r,-3]) rotate([0,angle,0]) cube([33,bar_r+6+2*lock_r+1,9]);
	}
	
	//rack centre
	mirror([1,0,0]) translate([0,-999,0]) hull(){
		cube([999,999*2,d]);
		translate([5,0,9]) cube([999,999*2,d]);
	}

	//rack bar
	translate([26.5-0.2-0.5+bar_r,0,bar_r]) rotate([-90,0,0]){
		cylinder(r=bar_r,h=999*2,center=true);
		translate([0,0,2*bar_r+6+2*lock_r-4]) cable_tie(bar_r+0.5);
	}

	//cross bar
	translate([0,bar_r,-1]) rotate([0,90,0]) {
		cylinder(r=bar_r+0.5,h=999*2,center=true);
		translate([0,0,3]) cable_tie(bar_r+0.5);
		translate([0,0,18]) cable_tie(bar_r+0.5);
	}

	//lock
	translate([16,2*bar_r+6+lock_r,0]) rotate([0,angle,0]){
		cylinder(r=lock_r,h=999,center=true);
	}
}

translate([0,40,0]) difference(){
//	translate([0,4,0]) hull() repeat([bar_r*2,0,0],2) cylinder(r=bar_r+1,h=lock_r*3);
	hull(){
		cube([lock_r*3,bar_r+2,bar_r*4-2]);
		translate([lock_r*0.5,0,0]) cube([lock_r*2,bar_r+6,bar_r*4-2]);
//		translate([lock_r*1.5,bar_r+2+lock_r,0]) cylinder(r=lock_r+3,h=bar_r*4-2);
	}

	//indent for rack
	translate([0,0,bar_r-1]) hull() repeat([0,0,bar_r*2],2) rotate([0,90,0]) cylinder(r=bar_r,h=999,center=true);
	
	//indent for lock
	translate([lock_r*1.5-bar_r*2*sin(angle),bar_r+2+lock_r,0]) rotate([0,angle,0]){
		cylinder(r=lock_r,h=999,center=true);
	}
	//cable ties
	translate([4.5,bar_r+2.75,0]) cube([3,1.5,999],center=true);
	translate([lock_r*3-3-1.5,bar_r+2.75,0]) cube([3,1.5,999],center=true);
}