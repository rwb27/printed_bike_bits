use <utilities.scad>;

t = 3;
h = 12;
inner_r = 22;
rack_r = 10.5/2+0.2;

rack = [inner_r+2,-inner_r+3,0];

roc=2;
flex_t=2;
clip = [3,rack_r-4,h];
clip_l = 10;
pivot = rack + [-clip[0]-roc, -rack_r - clip_l, 0];

d=0.05;

module rack(){
	translate(rack) rotate([0,4,-90]) //rotate([0,2.5,-90])
				cylinder(r=rack_r,h=999*2,center=true);
}

union(){
	difference(){
        hull(){ //this bit holds the rack tube
            cylinder(r=inner_r+t,h=h); //body
            translate([2,-inner_r-5,h/2]) cube([16,10,h],center=true);
            translate(rack) cylinder(r=5+4,h=h); //hold rack
            translate(pivot + [-roc,0,0]) cylinder(r=d,h=h); //for locking clip
        }

        chamfered_hole(r=inner_r,h=h); //hole for seat tube
        //Clamping bolt
		translate([0,-inner_r-5,h/2]) rotate(90) pinch_y(4,t=5, top_access=true,screw_l=12,extra_height=0); //clamping screw

		//clearance for rack
		hull() repeat([0,-999,0],2) rack();
        hull(){ //clearance for locking clip
            translate(pivot) cylinder(r=2,h=999,center=true);
            translate(rack+[-rack_r-clip[0],-4,-1]) cube([999,d,999]);
        }
	}
    
    //locking clip
    difference(){
        union(){
            translate(rack) hull(){ //locking bit
                translate([-clip[0],-rack_r,0]) cube([rack_r-2,rack_r-4,h]);
                translate([-clip[0],-rack_r-10-d,0]) cube([flex_t,d,h]);
            }
            translate(pivot) difference(){
                cylinder(r=4,h=h);
                hull(){
                    cylinder(r=2,h=999,center=true);
                    translate([-rack_r+roc,clip_l+rack_r,-1]) cube([rack_r,d,3*h]);
                }
            }
        }
        rack();
    }
}


