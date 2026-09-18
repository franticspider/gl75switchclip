// Parametric Keyhole Switch Surround / Clip for Lenco GL75 (Filleted)
$fn = 64;

// --- KEYHOLE DIMENSIONS (mm) ---
hole_radius    = 8.0;   // Radius of the main circular opening
slot_width     = 4.0;   // Width of the straight slot portion
slot_length    = 31.0;  // Length of the slot extending from circle center
fillet_radius  = 12;    // Curve radius where circle meets slot
outer_margin   = 10.0;  // Border thickness surrounding the keyhole
plate_height   = 10.0;  // Total height/thickness of the clip, minus the cones
tolerance      = 0.2;   // Print clearance adjustment

//
// Turntable Switch Guard
//
// Copyright © 2026 Simon Hickinbotham
//
// Licensed under the CERN Open Hardware Licence
// Version 2 - Permissive (CERN-OHL-P-2.0).
//
// The complete licence is available in the repository's LICENSE file.
//


// --- CALCULATED VALUES ---
r_inner = hole_radius + tolerance;
w_inner = slot_width + (tolerance * 2);

// 2D Keyhole Profile with Internal Fillets
module keyhole_2d(r, w, len, f) {
    offset(r = -f)
        offset(r = f)
            union() {
                circle(r = r);
                translate([0, len / 2, 0])
                    square([w, len], center = true);
            }
}

// 3D Keyhole Clip Body
module keyhole_clip() {
    difference() {
        // Outer body (expands the filleted keyhole outline smoothly)
        linear_extrude(height = plate_height)
            offset(r = outer_margin)
                keyhole_2d(r_inner, w_inner, slot_length, fillet_radius);
        
        // Inner keyhole cutout with filleted junctions
        translate([0, 0, -1])
            linear_extrude(height = plate_height + 2)
                keyhole_2d(r_inner, w_inner, slot_length, fillet_radius);
    }
}

module mycone(tx,ty,tz){
   
    translate([tx,ty,tz])
    cylinder(h=2,r1=3,r2=0); 
}

//The switch surround
keyhole_clip();

//The lever
translate([10,-outer_margin/2,0])
cube([60, outer_margin, plate_height]);
//optional rounded end

translate([70,0,0])
cylinder(h=plate_height,r1=outer_margin/2,r2=outer_margin/2);

//Add cones underneath to limit friction
mycone(hole_radius+outer_margin/2,0,10);
mycone(-(hole_radius+outer_margin/2),0,10);
mycone(0,-(hole_radius+outer_margin/2),10);
mycone(0,(slot_length+outer_margin/2),10);