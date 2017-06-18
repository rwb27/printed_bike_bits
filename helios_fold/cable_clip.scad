use <../utilities.scad>

span=19;
clip_to_cross=10.5;
t=2.5;
lip=2.5;
d=0.05;
h=7;

difference(){
	union(){
		reflect([1,0,0]){
			translate([-d,-t,0]) cube([span/2+t+d,t,h]);
			translate([span/2,-d,0]) cube([t,clip_to_cross+2*d,h]);
			translate([span/2+t,clip_to_cross,0]) mirror([1,0,0]) intersection(){
				rotate([0,0,45]) cube([(lip+t)*1.41,(lip+t)*1.41,2*h],center=true);
				cube([999,999,999]);
			}
		}
		translate([span/2+t,clip_to_cross,0]) rotate([0,0,-45]) 
			mirror([1,0,0]) translate([lip*1.41/2+t*(1.41/2-1),0,0]) cube([t,10,h]);
	}
	repeat([6,0,0],3,center=true) translate([0,0,h/2]) cube([2,999,3],center=true);
}