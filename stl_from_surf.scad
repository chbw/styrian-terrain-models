// Create a 3D-printable terrain model of a small part from styria. The preparation is done via octave with surf_from_dgm.m

// The original grid size is 10m so the elevation has to be scaled by 1/10=0.1 to have a 1:1 aspect ratio,
scale([1,1,0.1])
surface(file = "snippet.surf", center = true, convexity = 5);
