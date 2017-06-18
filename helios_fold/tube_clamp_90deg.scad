use <../standard_optomechanics/cylinder_clamp.scad>;
use <../utilities.scad>;

t = 3;
h = 10;
inner_r = 22;


union(){
	mirror([1,0,0]) cylinder_clamp(inner_r=inner_r,clamp_h=h,flat_width=0,flat_t=t,mounting_bolt=0,clamp_t=t);
	difference(){
		translate([4,0,-h/2]) cube([inner_r-4,inner_r+10,h]);
		cylinder(r=inner_r+t/2,h=999,center=true);
		translate([0,inner_r+5,0]) rotate(-90) cylinder_with_45deg_top(r=2.5,h=999,$fn=16); 
	}
}