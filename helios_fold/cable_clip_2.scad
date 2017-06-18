use <../utilities.scad>

span=19.5; //increased from 19
corner_r=6;
clip_to_cross=11.5;
t=2.5;
lip=2.5;
d=0.05;
h=7;
$fn=16;

difference(){
	union(){
		reflect([1,0,0]){
			translate([-d,-t,0]) cube([span/2+t+d-corner_r+d,t+1.5,h]);
			translate([span/2,corner_r-t-d,0]) cube([t,clip_to_cross+2*d-corner_r+t,h]);
			translate([span/2-corner_r+t,corner_r-t,0]) difference(){
				intersection(){
					cylinder(r=corner_r,h=h);
					mirror([0,1,0]) translate([-d,-d,-d]) cube([999,999,999]);
				}
				cylinder(r=corner_r-t,h=999,center=true);
			}
			translate([span/2+t,clip_to_cross,0]) mirror([1,0,0]) intersection(){
				rotate([0,0,45]) cube([(lip+t)*1.41,(lip+t)*1.41,2*h],center=true);
				cube([999,999,999]);
			}
		}
//		translate([span/2+t,clip_to_cross,0]) rotate([0,0,-45]) 
//			mirror([1,0,0]) translate([lip*1.41/2+t*(1.41/2-1),0,0]) cube([t,10,h]);
		assign(roc=10) translate([span/2+roc,clip_to_cross-roc/5,0]) union(){
			difference(){
				intersection(){
					cylinder(r=roc,h=h);
					rotate([0,0,90]) translate([-d,-d,-d]) cube([999,999,999]);
				}
				cylinder(r=roc-t,h=999,center=true);
			}
			translate([0,roc-t/2,0]) cylinder(r=t/2,$fn=16,h);
		}
	}
//	repeat([5,0,0],2,center=true) translate([0,0,h/2]) cube([2,999,3],center=true); //holes for cable ties
	translate([0,5/2,0]) cylinder(r=5/2,h=999,center=true);
}