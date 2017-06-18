
cone_dr=1.5;
cone_h=2;
n_cones=9;
shaft_h=n_cones*cone_h;
rbottom = 9;
rtop = 11.5;
d=0.05;

difference(){
	union(){
        //serrated conical part
		for(i = [0 : n_cones - 1]) assign(p = i/(n_cones - 1))
			translate([0, 0, i * cone_h - d]) 
				cylinder(r1=(1-p)*rbottom + p*rtop - cone_dr,
							r2=(1-p)*rbottom + p*rtop,
							h=cone_h+2*d);
		//elegantly curved top
		translate([0,0,shaft_h+3-d]) assign(r=rtop+4) assign(roc=3*r) intersection(){
			cylinder(r=r,h=999);
			translate([0,0,-sqrt(roc*roc-r*r)]) sphere(r=roc, $fn=64);
		}
        //cone to join top to serrated bit (avoid overhangs >45 degrees)
		translate([0,0,shaft_h])cylinder(r1=rtop, r2=rtop+4,h=3);
	}
	translate([0,0,-2*d]) cylinder(r1=rbottom-cone_dr-2, r2=rtop-cone_dr-2,h=shaft_h);

	translate([0,0,shaft_h+4.5]) hull(){
		cylinder(r=6,h=999);
		rotate(45) cube([6,6,999]);
	}
}