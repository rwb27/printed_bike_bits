use <../utilities.scad>;
use <./cylinder_clip.scad>;
use <../standard_optomechanics/cylinder_clamp.scad>;

socket_r = 24.3/2+0.2;
clip_t = 3.5;
vbrake_mount_r2 = 11.6/2+0.2;
vbrake_mount_r1 = 14/2+0.3;
corner_clearance = 1;
vbrake_mount_l1 = 8;
vbrake_mount_l2 = 20;
vbrake_mount_lip_l = 4.5;
clip_h = 16;
fork = [32.6,25.6];
base_z = -fork[1]/2; //in original this was -fork[1]/2+1
mount_h = clip_h;
reinforcement = [13,13];
vbrake_pos = [0,-vbrake_mount_r1-1,fork[1]/2-vbrake_mount_r2];
rack_r = 5;
rack_pos = [0,vbrake_pos[1]+38+rack_r+vbrake_mount_r1,-fork[1]/2+rack_r+4];
fork_leg_angle = [-4,0,0];
bottom = rack_pos[2]-rack_r+rack_pos[1]*sin(fork_leg_angle[0]);
pedal_pos = [socket_r+3,socket_r+3,bottom+3];

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

null() mirror([0,0,1])
//mirror([1,0,0])
difference(){
	union(){
		translate([socket_r+clip_t+5,socket_r+clip_t,base_z]) rotate(0) cylinder_clip(r=socket_r, t=clip_t,flat_w=1,flat_t=clip_t+5,h=clip_h,opening_angle=140);
		translate([corner_clearance,-5,base_z]) cube([socket_r+clip_t+10,5+clip_t,mount_h]); //attachment to V brake mount
		translate([-fork[0]/4,corner_clearance,base_z]) cube([fork[0]/4+3,socket_r*3,mount_h]); //attachment to fork
		translate([corner_clearance,corner_clearance,base_z]) hull(){
			cube([reinforcement[0],d,mount_h]);
			cube([d,reinforcement[1],mount_h]);
		}
		translate([clip_t+5,clip_t,base_z+clip_h-3.6]) intersection(){
			cube([socket_r*2,socket_r,3.6]); //lip to engage pedal mount
			translate([socket_r,socket_r,0]) cylinder(r=socket_r+1,h=999,center=true);
		}
		//retaining clip
		assign(sr=socket_r, rc=5, t=3)translate([0,0,base_z]){
			translate([0,sr+clip_t,0]) cube([t,sr*2.5+d,clip_h]);
			translate([rc+t,sr*3.5+clip_t-d,0]) difference(){
				cylinder(r=rc+t,h=clip_h);
				cylinder(r=rc,h=999,center=true);
				translate([0,-999,0]) cube([1,1,1]*2*999,center=true);
			}
			hull(){
				translate([2*rc+1.5*t,sr*3.5+clip_t-d,0]) cylinder(r=t/2,h=clip_h);
				translate([rc+t,sr*3.5+clip_t-d,0]) rotate(15) translate([rc+t/2,0,0]) cylinder(r=t/2,h=clip_h);
				translate([socket_r+clip_t+3,socket_r*2+clip_t,0]) cylinder(r=4,h=clip_h);
			}
		}
	}

	// Pedal mount
	translate([socket_r+clip_t+5,socket_r+clip_t,0]) cylinder(r=socket_r-1.5,h=999,center=true);
	translate([socket_r+clip_t+5,socket_r+clip_t,base_z+clip_h-3.6]) mirror([0,0,1]) cylinder(r=socket_r,h=999);
//	translate([socket_r+clip_t+5,socket_r+clip_t,base_z+clip_h-3.6]) cylinder(r1=socket_r,r2=socket_r-1.5,h=0.75);
    mirror([0,0,1]) fork_bits();
}
module fork_bits(){
    translate(vbrake_pos) rotate(fork_leg_angle) translate(-vbrake_pos){
		//////////// Fork
		translate([-fork[0]/2,0,0]) rotate([-90,0,0]) scale([fork[0]/fork[1],1,1]){
			cylinder(r=fork[1]/2,h=999,center=true);
			translate([0,0,3]) cable_tie(fork[1]/2);
			translate([0,0,fork[0]-8]) cable_tie(fork[1]/2);
		}
	
		//////////// V brake mount
		translate(vbrake_pos) rotate([0,90,0]){
			cylinder(r=vbrake_mount_r1,h=2*(vbrake_mount_l1+d),center=true);
			translate([0,0,vbrake_mount_l1]) cylinder(r=vbrake_mount_r1+1,h=vbrake_mount_lip_l);
			translate([0,0,vbrake_mount_l1+vbrake_mount_lip_l]) cylinder(r=vbrake_mount_r2,h=vbrake_mount_l2);
			// Cable tie points
			translate([0,0,vbrake_mount_l1-5]) cable_tie(vbrake_mount_r1);
			translate([0,0,vbrake_mount_l1+vbrake_mount_lip_l+5]) cable_tie(vbrake_mount_r2);
		}
        
        //////////// Front Rack
        translate(rack_pos) rotate([0,90,-atan(38/190)*0.9]) cylinder(r=rack_r,h=100);
	}
}

difference(){
    union(){
        translate([-5,-5,bottom]){ //main body of mount
            cube([5+pedal_pos[0],rack_pos[1]+5-2,fork[1]/2-bottom]);
            cube([5+pedal_pos[0]+5,10,fork[1]/2-bottom]);
            cube([5+pedal_pos[0]+5,rack_pos[1]+5-2 -2,2*rack_r-1]);
        }
        hull(){                    //reinforcement along V brake boss
            translate([pedal_pos[0],-5,2]) cube([socket_r+2,7,fork[1]/2-2]);
            translate([pedal_pos[0],-5,-2]) cube([socket_r+2,3,fork[1]/2+1]);
        }
        //retaining clip
        t=3;
        clip_l=30;
        rc=3;
        translate([pedal_pos[0],-5,bottom]){
            cube([clip_l+d,t,-bottom]);
            translate([clip_l,rc+t,0]) difference(){
				cylinder(r=rc+t,h=-bottom);
				cylinder(r=rc,h=999,center=true);
				translate([-999,0,0]) cube([1,1,1]*2*999,center=true);
			}
            hull(){
                translate([clip_l,2*rc+t,0]) cube([d,t,-bottom]);
                translate([-pedal_pos[0]-5+2*socket_r+1,t+9,0]) cube([d,5,-bottom-2]);
            }
        }
    }
    
    fork_bits();
    
    translate(pedal_pos){
        cylinder(r=socket_r,h=999);
        cylinder(r=socket_r-1.5,h=999,center=true);
        translate([0,-socket_r,0]) cube([5.5,2*socket_r,999]);
        translate([0,-socket_r+1.5,-999/2]) cube([5.5,2*socket_r-1.5*2,999]);
    }
}
%fork_bits();
