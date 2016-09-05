% Started at 12:00
clear all;
close all;
clc;

%% load image

I = imread('./I3.png');
I = rgb2gray(I); % used for I3.png

%% make edge image

edge_I = zeros(size(I));
edge_I = edge(I);
%% Implement Hough Transform

accum_array = LinearHoughAccum(edge_I);
% show the accumulator array
figure(1);
imagesc(accum_array);

% If the dimensions change, instead of ceil(sqrt(2)*W), we would have
% ceil(sqrt(W^2 + H^2)).
% For detecting circles we need 3 parameters, two coordinates for a center
% and a third for the radius.


%% Implement basic visualization

figure(2);
show_lines(I,accum_array);

% Finished at 14:00
