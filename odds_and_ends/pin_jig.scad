use <../utilities.scad>;

l=15.8 + 0.5;
d0=3+0.3;
spline_h=1.2+0.2;

difference(){

	union(){
		translate([-3,-2,-3]) cube([l+6,4+d0*2,3]);
		translate([-3,-2,-1]) cube([3,4+d0*2,2]);
	}

	translate([0,d0,-0.5]) rotate([0,90,0]) cylinder(r=d0/2,h=l,$fn=16);
//	translate([0,d0*3,0]) rotate([0,90,0]) intersection(){
//		cylinder(r=d0/2,h=l,$fn=16);
//		cube([spline_h,d0,9999],center=true);
//	}
//	translate([0,d0*5-spline_h/2,-d0/2]) cube([l,spline_h,d0]);
}