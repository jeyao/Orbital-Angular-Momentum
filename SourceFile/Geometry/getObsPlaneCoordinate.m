function [cartCoord,sphCoord] = getObsPlaneCoordinate(X,Y,z0)

    z = ones(length(Y),length(X)) * z0;
    [x,y] = meshgrid(X,Y);
    [azimuth, elevation, radius] = cart2sph(x,y,z);   
    elevation = pi/2 - elevation;
    
    cartCoord(1,:,:) = x;
    cartCoord(2,:,:) = y;
    cartCoord(3,:,:) = z;
    
    sphCoord(1,:,:) = azimuth;
    sphCoord(2,:,:) = elevation;
    sphCoord(3,:,:) = radius;
    
end

