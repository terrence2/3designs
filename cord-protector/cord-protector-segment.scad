//render settings
$fs=0.8; // def 1, 0.2 is high res
$fa=4;//def 12, 3 is very nice

module ball(size, height) {
    base_size = 0.8 * size;
    sphere(r=size);
    translate([0,0,-size]) cylinder(r1=base_size, r2=base_size * 0.6, h=size / 3);
    translate([0,0,-size-height]) cylinder(r=base_size,h=height);
}

module joint(size, height)
{
    size=5;
    base_size = 0.8 * size;
    joint_spacing = 0.5;
    joint_thickness = 0.2 * size;
    joint_arms = 8;
    arm_width = 0.4 * size;
    oversize = size + joint_spacing + joint_thickness;

    difference()
    {
        union() {
            sphere(r=oversize);
            translate([0,0,height - size])
                cylinder(r=0.8*size,h=height);
        }
        sphere(r=oversize - joint_thickness);
        translate([0,0,-size-(size/5)])
            cube([2*oversize, 2*oversize, size],center=true);
        for(i = [0:joint_arms]) {
            rotate([0,0,360/joint_arms*i])
                translate([-arm_width/2, 0, -size])
                    cube([arm_width, oversize, 1.8 * size]);
        }
    }
}

module clip(size, open_angle) {
    rotate(90, [1, 0, 0])
        difference() {
            linear_extrude(size / 2) circle(size);
            translate([0,0,-0.5]) linear_extrude(size / 2 + 1) circle(size * 0.9);
            translate([0, size - 2, size/4]) rotate(open_angle, [0,1,0]) cube([size * 2, size * 2, size * 0.05], center=true);
        }
}

module tenon(size) {
    union() {
        translate([0,0,size/2]) cube([size, size * 3 / 2, size * 3 / 2], center=true);
        translate([-size/2,0,size/2]) sphere(r=size/4);
        translate([+size/2,0,size/2]) sphere(r=size/4);
    }
}

module mortise(size) {
    difference() {
        cube([size+4, size, size*2], center=true);
        tenon(size);
    }
}

//mortise(5);
//tenon(4.7);


module joint_assembly(pin_radius, pin_height) {
    difference() {
        union() {
            translate([0,0,10+5])
                rotate(180, [1,0,0])
                    joint(10, 10);
            /*
            for (i = [0:4]) {
                a = i * 90;
                rotate(a, [0,1,0])
                    translate([0, 5, 17])
                        clip(10, open_angle=15+(10*i));
            }
            */
        }
        translate([0,0,pin_height/2], center=true)
            cylinder(h=pin_height+0.5, r=pin_radius, center=true);
        translate([0,0,-pin_height])
            sphere(r=pin_radius);
    }
}

module ball_assembly(pin_radius, pin_height) {
    difference() {
        translate([0,0,10])
            ball(5, pin_height);
        translate([0,0,pin_height/2])
            cylinder(h=pin_height+0.5, r=pin_radius, center=true);
    }
}

pin_radius = 2.5;
pin_height = 8;

module printable_assembly() {
    translate([8, 0, 0])
        joint_assembly(pin_radius, 5);
    translate([-8, 0, 0])
        ball_assembly(pin_radius, 5);
    cylinder(r=pin_radius, h=pin_height, $fn=8);
}

module assembled_assembly() {
    joint_assembly(pin_radius, 5);
    rotate(180, [1,0,0])
        ball_assembly(pin_radius, 5);
}

printable_assembly();
//assembled_assembly();
