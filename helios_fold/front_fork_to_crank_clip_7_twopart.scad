use <../utilities.scad>;
use <./cylinder_clip.scad>;
use <../standard_optomechanics/cylinder_clamp.scad>;
use <MCAD/regular_shapes.scad>;

socket_r = 24.3/2+0.3;
clip_t = 3.5;
vbrake_mount_r2 = 11.6/2+0.2;
vbrake_mount_r1 = 14/2+0.3;
corner_clearance = 1;
vbrake_mount_l1 = 8;
vbrake_mount_l2 = 30;
vbrake_mount_lip_l = 4.5;
clip_h = 16;
fork = [32.6,25.6];
base_z = -fork[1]/2; //in original this was -fork[1]/2+1
mount_h = clip_h;
reinforcement = [13,13];
vbrake_pos = [0,-vbrake_mount_r1-1,fork[1]/2-vbrake_mount_r2];
rack_r = 5;
rack_pos = [0,vbrake_pos[1]+38+rack_r+vbrake_mount_r1,-fork[1]/2+rack_r+4];
fork_to_straight = 20;
fork_leg_angle = [-4,0,0];
bottom = rack_pos[2]-rack_r+rack_pos[1]*sin(fork_leg_angle[0]);
pedal_pos = [socket_r+5,socket_r+3,bottom-1];
angular_float = 5;

$fn=32;
d=0.05;

module annulus(inner_r,thickness,h){
	difference(){
		cylinder(r=inner_r+thickness,h=h);
		cylinder(r=inner_r,h=99999,center=true);
	}
}
module cable_tie(inner_r){
	annulus(inner_r+2.5,2,5);
}

module fork_bits(){
    translate(vbrake_pos) rotate(fork_leg_angle) translate(-vbrake_pos){
		//////////// Fork
		translate([-fork[0]/2,0,0]) rotate([-90,0,0]) scale([fork[0]/fork[1],1,1]){
			cylinder(r=fork[1]/2,h=999,center=true);
			translate([0,0,pedal_pos[1]+2]) cylinder(r=fork[1]/2+0.5,h=14,center=true);
			translate([0,0,2]) cable_tie(fork[1]/2);
			translate([0,0,fork[0]-5]) cable_tie(fork[1]/2);
		}
	
		//////////// V brake mount
		translate(vbrake_pos) rotate([0,90,0]){
			cylinder(r=vbrake_mount_r1,h=2*(vbrake_mount_l1+d),center=true);
			translate([0,0,vbrake_mount_l1]) cylinder(r=vbrake_mount_r1+1,h=vbrake_mount_lip_l);
			translate([0,0,vbrake_mount_l1+vbrake_mount_lip_l-d]) cylinder(r=vbrake_mount_r2,h=vbrake_mount_l2);
			// Cable tie points
			translate([0,0,vbrake_mount_l1-5]) cable_tie(vbrake_mount_r1);
			translate([0,0,vbrake_mount_l1+vbrake_mount_lip_l+5]) cable_tie(vbrake_mount_r2);
		}
        
        //////////// Front Rack
        translate(rack_pos) rotate([0,90,-atan(38/190)*0.9]){
            //straight part of rack
            translate([0,0,fork_to_straight]) cylinder(r=rack_r,h=100);
            translate([-rack_r,0,fork_to_straight]) cube([rack_r*2+1,10,999]);
            
            roc=fork_to_straight - rack_r - 5;
            translate([0,roc,fork_to_straight+d]) rotate([0,90,180]){
                intersection(){ //curved part of rack
                    rotate_extrude($fn=16) translate([roc,0,0]) circle(rack_r);	
                    translate([0,0,-99]) cube([1,1,1]*999);
                }
                rotate(70) translate([roc,0,0]) rotate([90,0,0]) cable_tie(rack_r);
            }
        }
	}
}

module main_mount(){
    difference(){
        union(){ //body
            translate([-5,-5,bottom]) cube([5+pedal_pos[0]+socket_r+10,rack_pos[1]+5-3,fork[1]/2-bottom]);
            
        }
        
        fork_bits();
        
        //cutout for pedal holder
        translate(pedal_pos){
            hull()for(i=[-1,1]) rotate([0,i*angular_float,0]) cylinder(r=socket_r,h=999);
        }
        
        //cutout to clear pannier hooks
        pc_r = mount_h - bottom - 2*rack_r + 1;
        translate([20,pc_r+5,mount_h]) hull() repeat([0,999,0],2) 
            rotate([0,90,0]) cylinder(r=pc_r,h=999);
    }
}

module strap_retainer(){
    h=8; //thickness overall
    t=2; //thickness of important bit
    rc=2; //radius of curvature
    rc2=1; //RoC for the strap (around the fork axis)
    left=-7;
    strap_w=6;
    difference(){
        mirror([1,0,0]) translate([-left,-2,bottom-h]){
            cube([10,rack_pos[1]-5,h-bottom]);
        }
        fork_bits();
        
        //slot for strap
        translate([left,pedal_pos[1],bottom-h+t+rc]) rotate([0,90,0]){
            hull() reflect([0,1,0]) translate([0,strap_w/2,0]) cylinder(r=rc,h=999,center=true);
            hull() reflect([0,1,0]) translate([0,strap_w/2,0]){
                cylinder(r=rc,h=2,center=true);
                translate([1,0,1]) cylinder(r=rc,h=d);
            }
        }
    }
}

main_mount();
//rotate([0,90,0]) strap_retainer();


//%fork_bits();
