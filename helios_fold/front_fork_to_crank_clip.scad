use <../utilities.scad>;
use <./cylinder_clip.scad>;
use <../standard_optomechanics/cylinder_clamp.scad>;

socket_radius = 24.3/2-0.3;
clip_t = 3.5;
vbrake_mount_r2 = 11.6/2+0.2;
vbrake_mount_r1 = 14/2+0.3;
corner_clearance = 1;
vbrake_mount_l1 = 8;
vbrake_mount_l2 = 20;
vbrake_mount_lip_l = 4.5;
clip_h = 18;
fork = [32.6,25.6];
base_z = fork[1]/2-clip_h; //in original this was -fork[1]/2+1
mount_h = fork[1]/2+1 - base_z;
reinforcement = [13,12];
$fn=32;
d=0.05;

module annulus(inner_r,thickness,h){
	difference(){
		cylinder(r=inner_r+thickness,h=h);
		cylinder(r=inner_r,h=99999,center=true);
	}
}
module cable_tie(inner_r){
	annulus(inner_r+2,2,5);
}

difference(){
	union(){
		translate([socket_radius+clip_t+5,socket_radius+clip_t,base_z]) cylinder_clip(r=socket_radius, t=clip_t,flat_w=10,flat_t=clip_t+5,h=clip_h);
		translate([corner_clearance,-5,base_z]) cube([socket_radius+clip_t+10,5+clip_t,mount_h]); //attachment to V brake mount
		translate([-fork[0]/4,corner_clearance,base_z]) cube([fork[0]/4+3,fork[0],mount_h]); //attachment to fork
		translate([corner_clearance,corner_clearance,base_z]) hull(){
			cube([reinforcement[0],d,mount_h]);
			cube([d,reinforcement[1],mount_h]);
		}
		translate([clip_t+5,clip_t,base_z]) cube([socket_radius*1.8,4,3.6]);
	}

	// Pedal mount
	translate([socket_radius+clip_t+5,socket_radius+clip_t,0]) cylinder(r=socket_radius-1.5,h=999,center=true);

	//////////// Fork
	translate([-fork[0]/2,0,0]) rotate([-90,0,0]) scale([fork[0]/fork[1],1,1]){
		cylinder(r=fork[1]/2,h=999,center=true);
		translate([0,0,3]) cable_tie(fork[1]/2);
		translate([0,0,fork[0]-8]) cable_tie(fork[1]/2);
	}

	//////////// V brake mount
	translate([0,-vbrake_mount_r1-1,fork[1]/2-vbrake_mount_r2]) rotate([0,90,0]){
		cylinder(r=vbrake_mount_r1,h=vbrake_mount_l1+d);
		translate([0,0,vbrake_mount_l1]) cylinder(r=vbrake_mount_r1+1,h=vbrake_mount_lip_l);
		translate([0,0,vbrake_mount_l1+vbrake_mount_lip_l]) cylinder(r=vbrake_mount_r2,h=vbrake_mount_l2);
		// Cable tie points
		translate([0,0,vbrake_mount_l1-5]) cable_tie(vbrake_mount_r1);
		translate([0,0,vbrake_mount_l1+vbrake_mount_lip_l+5]) cable_tie(vbrake_mount_r2);
	}
}
