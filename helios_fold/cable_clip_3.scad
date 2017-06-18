use <../utilities.scad>

span=19.1; //increased from 19
corner_r=6;
clip_to_cross=11.5;
//clip_to_cross=8.5;
t=2.5;
lip=2.5;
lug_r=0.7;
d=0.05;
h=7;
$fn=32;

difference(){
	union(){
		reflect([1,0,0]){
			translate([-d,-t,0]) cube([span/2+t+d-corner_r+d,t,h]); //bottom
			translate([span/2,corner_r-t-d,0]) cube([t,clip_to_cross+2*d-corner_r+t,h]); //side
			translate([span/2-corner_r+t,corner_r-t,0]) difference(){ //corner
				intersection(){
					cylinder(r=corner_r,h=h);
					mirror([0,1,0]) translate([-d,-d,-d]) cube([999,999,999]);
				}
				cylinder(r=corner_r-t,h=999,center=true);
			}
		}
		//rounded lug on non-lever side (to allow clip to rotate without bending)
		translate([-span/2,clip_to_cross,0]) hull(){
			translate([-t,-d,0]) cube([t,d,h]); //join to arm of clip
			translate([-t/2,t/2,0]) cylinder(r=t/2,h=h); //rounded end
			translate([lip-lug_r/tan(22.5),lug_r,0]) cylinder(r=lug_r,h=h); //lug
		}
		//rounded lug on lever side (with sloped lead-in to help it clip in easily)
		mirror([1,0,0]) translate([-span/2,clip_to_cross,0]) hull(){
			translate([-t,-d,0]) cube([t,d,h]); //join to arm of clip
			translate([-t+lug_r,t+lip-lug_r/tan(22.5),0]) cylinder(r=lug_r,h=h); //rounded end (produces slope)
			translate([lip-lug_r/tan(22.5),lug_r,0]) cylinder(r=lug_r,h=h); //lug
		}
		//curved lever
		assign(roc=10) translate([span/2+roc,clip_to_cross-roc/5,0]) union(){
			difference(){
				hull(){
					intersection(){
						cylinder(r=roc,h=h,$fn=64);
						rotate([0,0,90]) translate([-d,-d,-d]) cube([999,999,999]);
					}
				}
				cylinder(r=roc-t,h=999,center=true,$fn=64);
			}
			translate([0,roc-t/2,0]) cylinder(r=t/2,$fn=16,h);
		}
//		translate([0,0,h/2]) cube([span+2*t-2*corner_r,3,h],center=true); //squeeze outer cables
	}
//	repeat([5,0,0],2,center=true) translate([0,0,h/2]) cube([2,999,3],center=true); //holes for cable ties
	translate([0,5/2,0]) cylinder(r=5/2,h=999,center=true); //clearance for third cable
	reflect([1,0,0]) translate([span/2+t-corner_r,t/2,0]) cylinder(r=t/2,h=999,center=true);
}