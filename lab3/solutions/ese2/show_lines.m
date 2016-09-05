function show_lines(I,accum)
%SHOW_LINES Summary of this function goes here
%   Detailed explanation goes here

[~,ind] = max(accum(:));
[ii,jj] = ind2sub(size(accum),ind);

r = ii;
theta = 0.01*(jj-1);

eps = 1;
for y = 1:size(I,1)
    for x = 1:size(I,2)
        if(r < abs((x)*cos(theta)+(y)*sin(theta))+eps && r > abs((x)*cos(theta)+(y)*sin(theta))-eps)
            I(y,x) = 255;
        end
    end
end
imshow(I)

end

