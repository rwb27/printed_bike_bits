use <../utilities.scad>;
shim = [30,20,1.5];
hole_spacing = 14;

difference(){
	cube(shim,center=true);
	repeat([hole_spacing,0,0],2,center=true) cylinder(h=999,r=5.5/2,center=true);
}
