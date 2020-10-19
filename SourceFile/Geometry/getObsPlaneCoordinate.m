function [cartCoord,sphCoord] = getObsPlaneCoordinate(X,Y,z0)

    z = ones(length(Y),length(X)) * z0;
    [x,y] = meshgrid(X,Y);
    [azimuth, elevation, radius] = cart2sph(x,y,z);   
    elevation = pi/2 - elevation;
    
    cartCoord.x = x;
    cartCoord.y = y;
    cartCoord.z = z;
    
    sphCoord.azimuth = azimuth;
    sphCoord.elevation = elevation;
    sphCoord.radius = radius;
    
end

