function [labelImage] = clusterImage(depthImage)
%
% Inputs: 
% 
% depthImageage: An image where each value indicates the depth of the
% corresponding pixel.
%
% Outputs: 
%
% labelImage:  Output label image where each value indicates to which 
% cluster the corresponding pixels belongs. There are three clusters: 
% value 1 for the background, value 2 for the hand and value 3 for 
% the doll.
%
[H, W] = size(depthImage);
labelImage = zeros(H,W);

k=3;

% initiate centroids - BEGIN
% we create 3 centroids, in the format [Z X Y], where Z in the inverse depth
mu=zeros(k,3);

mu(1,:) = [0 0 0]; %background centroid
mu(2,:) = [500 300 150]; %hand centroid
mu(3,:) = [1000 100 200]; %doll centroid
% initiate centroids - END

%%TODO: implement kmeans
while(true)
    new_mu = zeros(k, 3);
    npoints = zeros(k,1);
    for i=1:H
        for j=1:W
            dist = zeros(k,1);
            for u=1:k
                dist(u) = sqrt(1*(depthImage(i,j)-mu(u,1))^2 + (i-mu(u,2))^2 + (j-mu(u,3))^2); % added weight to depth component
            end
            [a, b] = min(dist); % a is min val, b is index
            new_mu(b,:) = (new_mu(b,:)*npoints(b)+[depthImage(i,j) i j])/(npoints(b)+1);
            npoints(b) = npoints(b) + 1;
            labelImage(i,j) = b;
        end
    end
%     [Y, X] = find(labelImage == 1); % another way of computing the
%     centroids
%     new_mu(1,1) = mean(Y);
%     new_mu(1,2) = mean(X);
    new_mu
    if(mu == new_mu)
        break;
    end
    mu = new_mu;
end

end