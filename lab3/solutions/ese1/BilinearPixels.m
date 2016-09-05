%%
% This function computes the bilinear interpolation of each pixel after the image.
%
% Inputs:
% Im - input image   
% u  - 1XN vector with the x coordinates (the coordinates are not rounded)
% v  - 1XN vector with the y coordinates (the coordinates are not rounded)
% 
% Outputs:
% intensities - NX3 matrix with RGB values. 

function intensities = BilinearPixels( Im, u, v)

[height,width,channels] = size(Im);
N = length(u);
intensities = -1*ones(N,channels);

rx = round(u);
ry = round(v);

p = u - rx;
q = v - ry;
dx = ones(N,1);
dy = ones(N,1);

dx(p < 0) = -1;
dy(q < 0) = -1;

p = abs(p);
q = abs(q);

for k = 1:N
    
    if ( (rx(k) <1) || (ry(k) <1) || (rx(k) >= width) || (ry(k) >= height) || (rx(k)+dx(k) <1) || (ry(k)+dy(k) <1) || (rx(k)+dx(k) >= width) || (ry(k)+dy(k) >= height))
        continue ;
    end
    a = Im(ry(k),rx(k),:); 
    b = Im(ry(k),rx(k)+dx(k),:); 
    c = Im(ry(k)+dy(k),rx(k),:); 
    d = Im(ry(k)+dy(k),rx(k)+dx(k),:);

    intensities(k,:) = (1-p(k))*(1-q(k)).*a + (1-p(k))*q(k).*c + p(k)*(1-q(k)).*b + p(k)*q(k).*d;
       
end 

