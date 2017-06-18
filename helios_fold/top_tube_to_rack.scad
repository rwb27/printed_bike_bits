use <../standard_optomechanics/cylinder_clamp.scad>;
use <./cylinder_clip.scad>;
use <../utilities.scad>;

t = 3;
h = 11;
inner_r = 22;


union(){
	cylinder_clamp(inner_r=inner_r,clamp_h=h,flat_width=0,flat_t=t,mounting_bolt=0,clamp_t=t);
	
	intersection(){
		translate([inner_r+5,inner_r+5,0]) rotate([-2.5,0,-90])translate([0,0,-999])cylinder_clip(r=5-0.1,t=3,flat_t=7,h=999*2);
		cube([999,999,h],center=true);
	}
	difference(){
		translate([4,0,-h/2]) cube([inner_r-4-1,inner_r+10,h]); //support for clip
		cylinder(r=inner_r+t/2,h=999,center=true); //clearance for tube 
		translate([0,0,-8/2]) cube([14,999,8+0.3]); //nut entry
		translate([0,inner_r+5,0]) rotate(-90) cylinder_with_45deg_top(r=2.5,h=20,$fn=16); //bolt clearance
	}
}