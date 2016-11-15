//render settings
$fs=0.4; // def 1, 0.2 is high res
$fa=4;//def 12, 3 is very nice

module ball(size, height) {
    base_size = 0.8 * size;
    sphere(r=size);
    translate([0,0,-size]) cylinder(r1=base_size, r2=base_size * 0.6, h=size / 3);
    translate([0,0,-size-height]) cylinder(r=base_size,h=height);
}

module joint(size, height)
{
    base_size = 0.8 * size;
    joint_spacing = 0.5;
    joint_thickness = 0.2 * size;
    squeeze_thickness = 0.1 * size;
    joint_arms = 8;
    arm_width = 0.4 * size;
    oversize = size + joint_spacing + joint_thickness;

    difference()
    {
        union() {
            sphere(r=oversize);
            translate([0,0,height - size])
                cylinder(r=base_size,h=height);
        }
        sphere(r=oversize - joint_thickness - squeeze_thickness);
        translate([0,0,-size-(size/5)])
            cube([2*oversize, 2*oversize, size],center=true);
        for(i = [0:joint_arms]) {
            rotate([0,0,360/joint_arms*i])
                translate([-arm_width/2, 0, -size])
                    cube([arm_width, oversize, 1.8 * size]);
        }
    }
}

module joint_assembly(pin_radius, pin_height) {
    difference() {
        union() {
            translate([0,0,10+5])
                rotate(180, [1,0,0])
                    joint(5, 10);
        }
        translate([0,0,pin_height/2], center=true)
            cylinder(h=pin_height+0.5, r=pin_radius, center=true);
        translate([0,0,pin_height])
            sphere(r=pin_radius);
    }
}

module ball_assembly(pin_radius, pin_height) {
    difference() {
        translate([0,0,10])
            ball(5, pin_height);
        translate([0,0,pin_height/2])
            cylinder(h=pin_height+0.5, r=pin_radius, center=true);
        translate([0,0,pin_height])
            sphere(r=pin_radius);
    }
}

pin_radius = 2.5;
pin_height = 8;

module printable_assembly() {
    translate([8, 0, 0])
        joint_assembly(pin_radius, 5);
    translate([-8, 0, 0])
        ball_assembly(pin_radius, 5);

    h = pin_radius * sin(60);
    rotate(90, [1,0,0])
        translate([0, h, -pin_height/2])
            cylinder(r=pin_radius, h=pin_height, $fn=6);
}

printable_assembly();
