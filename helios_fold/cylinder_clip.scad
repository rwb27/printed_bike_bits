use <../utilities.scad>;

module cylinder_clip(r=1,t=3,opening_angle=120,wing_length=2,wing_angle=45,flat_w=10,flat_t=3,h=10,$fn=$fn){
	union(){
		difference(){
			hull(){
				cylinder(r=r+t,$fn=$fn,h=h);
				translate([-flat_w/2,-r-flat_t,0]) cube([flat_w,0.1,h]);
			}
			cylinder(r=r,$fn=$fn,h=99999,center=true);
			cylinder(r1=r+2,r2=r,$fn=$fn,h=2,center=true);
			scale([tan(opening_angle/2),1,1]) rotate([0,0,45]) translate([0,0,-1]) cube([1,1,1]*9999);
		}
		reflect([1,0,0]) translate([sin(opening_angle/2),cos(opening_angle/2),0]*(r+t/2)) hull() repeat([sin(wing_angle),cos(wing_angle),0]*wing_length,2)
			cylinder(r=t/2,h=h,$fn=16);
			
	}
}

//cylinder_clip(r=3,t=2,flat_w=6);
union(){
	cylinder_clip(r=21,t=4.5,flat_t=10,opening_angle=100,$fn=64);
	translate([-5,-22-5-20,0]) cube([10,20,10]);
}