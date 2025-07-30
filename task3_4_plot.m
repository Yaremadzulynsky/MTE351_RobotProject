[x,y] = meshgrid(1:0.001:5, 1:0.001:5);
z = floorHeightFcn(x,y);

surf(x,y,z)