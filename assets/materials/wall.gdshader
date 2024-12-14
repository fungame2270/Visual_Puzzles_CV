shader_type spatial;


void fragment() {
    // Check if the current face is front-facing or back-facing
    if (FRONT_FACING) {
        // Outside of the mesh (transparent)
        ALPHA = 0.0; // Fully transparent
    } else {
        // Inside of the mesh (opaque)
        ALPHA = 1.0; // Fully opaque
    }

    ALBEDO = vec3(0.8, 0.2, 0.2); // Example color for inside
}
