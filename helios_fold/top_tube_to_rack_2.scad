use <../standard_optomechanics/cylinder_clamp.scad>;
use <./cylinder_clip.scad>;
use <../utilities.scad>;

t = 3;
h = 11;
inner_r = 22;
rack_r = 5+0.3;

rack = [inner_r+2,-inner_r+3,0];

d=0.05;

module rack(){
	translate(rack) rotate([0,4,-90]) //rotate([0,2.5,-90])
				cylinder(r=rack_r,h=999*2,center=true);
}

union(){
	translate([0,0,h/2]) mirror([0,1,0]) cylinder_clamp(inner_r=inner_r,clamp_h=h,flat_width=0,flat_t=t,mounting_bolt=0,clamp_t=t);

	difference(){
		union(){
			hull(){
				rotate(18) translate([inner_r+t/2,0,0]) cylinder(r=t/2,h=h);
				translate(rack) cylinder(r=5+4,h=h);
			}
		}
	
		cylinder(r=inner_r+t/2,h=999,center=true); //clearance for tube 

		//clearance for rack
		hull() repeat([0,-999,0],2) #rack();
		translate(rack + [0,-4-999,0]) cube([1,1,1]*999*2,center=true);
		translate(rack + [0,-2,-1]) mirror([1,0,0]) mirror([0,1,0]) cube([1,1,1]*999);
	}
}

roc=2;
flex_t=2;
clip = [3,rack_r-4,h];
pivot = rack + [-clip[0]-roc, -rack_r - 10,0];
module clip_strut(h){
    hull(){
        translate(pivot + [-roc-flex_t,-d,0]) cube([flex_t,d,h]);
        translate([rack[0]-clip[0]-rack_r-flex_t-0.5,rack[1],0]) cube([flex_t,d,h]);
    }
}

difference(){
    union(){
        translate(rack) hull(){ //locking bit
            translate([-clip[0],-rack_r,0]) cube([rack_r-2,rack_r-4,h]);
            translate([-clip[0],-rack_r-10-d,0]) cube([flex_t,d,h]);
        }
        translate(pivot) difference(){
            cylinder(r=4,h=h);
            cylinder(r=2,h=999,center=true);
            translate([-10,0,-10]) cube([1,1,1]*999);
        }
        clip_strut(h);
        repeat([0,0,h-1.5],2) hull(){
            clip_strut(1.5);
            translate([4,-inner_r-10,0]) cube([d,10,1.5]);
        }
    }
    rack();
}

/*
null()	difference(){
	//	hull(){
//			translate(rack - [
		cylinder(r=inner_r+1,h=999,center=true);
		translate([inner_r,inner_r,0]) repeat([999,0,0],2) rotate([-2.5,0,-90])
				translate([0,0,-999]) cylinder(r=5+0.2,h=999*2,center=true);
	}
	difference(){
		translate([4,0,-h/2]) cube([inner_r-4-1,inner_r+10,h]); //support for clip
		cylinder(r=inner_r+t/2,h=999,center=true); //clearance for tube 
		translate([0,0,-8/2]) cube([14,999,8+0.3]); //nut entry
		translate([0,inner_r+5,0]) rotate(-90) cylinder_with_45deg_top(r=2.5,h=20,$fn=16); //bolt clearance
	}
}
*/