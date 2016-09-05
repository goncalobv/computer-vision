% Started at 11:45
%% --- Computer Vision Course - Excerice Session 2
% For instructions check the moodle webpage
clearvars;


%% -- Exercise 2.1: Implementing Convolution

% read sample image
img = imread('coins.jpeg');
img = rgb2gray(img);
% image has WxH dimensions and filter has (2N+1)x(2M+1)
% convert to DOUBLE, VERY IMPORTANT. Find out why!
img = im2double(img);

% create filter we will convolve img with
% (sobel filter)
filt = [-1, 0, 1; ...
        -2, 0, 2; ...
        -1, 0, 1] * 1/8;
    
% convolve img with filt with the function you wrote
result = applyImageFilter( img, filt );

% show the results
figure(1); clf;
subplot(131); imshow(img); title('Original');
subplot(132); imagesc(filt); axis equal; axis off; title('Filter');
subplot(133); imagesc(result); axis equal; axis off; title('Result');
figure(2)
subplot(121);
imshow(result); % does not work with decimals (doubles)
subplot(122);
imagesc(result); % does work with decimals (doubles)

%% -- Exercise 2.2: Analyzing gradient image
% using impixelinfo() to investigate intensity values
% From dark to bright, from left to right (as we have an horizontal filter
% Sx), values go from negative to positive: -0.16 -.20 -.23 .14 0.09
% When going from left to right (bright to dark): .29 .05 -.01 .01
% The 1/8 conserves the energy of the image (in terms of signal processing)
% add your code here

%% -- Exercise 2.3: Computing Gradient Magnitude and Phase
% add your code here
clearvars;
img = imread('coins.jpeg');
img = rgb2gray(img);
% image has WxH dimensions and filter has (2N+1)x(2M+1)
% convert to DOUBLE, VERY IMPORTANT. Find out why!
img = im2double(img);
Sx = [-1, 0, 1; ...
        -2, 0, 2; ...
        -1, 0, 1] * 1/8;

Sy = Sx';
    
% convolve img with filt with the function you wrote
resultx = applyImageFilter( img, Sx );
resulty = applyImageFilter( img, Sy );

grad = [resultx; resulty];

mag_grad = sqrt(resultx .^ 2 + resulty .^ 2);
phase_grad = atan2(resulty, resultx); % atan 2 determines right quadrant for the phase

subplot(1,3,1)
imshow(img)
subplot(1,3,2)
imshow(mag_grad)
subplot(1,3,3)
imshow(phase_grad)
impixelinfo()
% gradient gets maximum in edges
% phase crosses zero

%% Exercise 2.4: Comparing separable and non separable filters
% add your code here
clearvars;

img = imread('coins.jpeg');
img = rgb2gray(img);
% image has WxH dimensions and filter has (2N+1)x(2M+1)
% convert to DOUBLE, VERY IMPORTANT. Find out why!
img = im2double(img);

fSigma = 0.5; % the smaller the sigma the more detailed (the less smoothing)
fSize = [3 3];
gaussFilt = fspecial('gaussian', fSize, fSigma)

% h = fspecial('gaussian', hsize, sigma) returns a rotationally symmetric
% Gaussian lowpass filter of size hsize with standard deviation sigma
% (positive). hsize can be a vector specifying the number of rows and
% columns in h, or it can be a scalar, in which case h is a square matrix.
% The default value for hsize is [3 3]; the default value for sigma is 0.5.

% For high smoothing (high fSigma like 10) and a 'tall' filter (fSize=[20
% 3]) we get vertical smoothing.

% For a given fSigma if the value is high then we want to do smoothing, I
% would choose a large fSize to spread it over a larger area.
filtered_img = imfilter(img, gaussFilt);
imagesc(filtered_img);

%% Exercise 2.5
clearvars;

img = imread('coins.jpeg');
img = rgb2gray(img);
% image has WxH dimensions and filter has (2N+1)x(2M+1)
% convert to DOUBLE, VERY IMPORTANT. Find out why!
img = im2double(img);

gaussFilt = fspecial('gaussian', 25, 10);
filtered_img = imfilter( img, gaussFilt, 'circular');
% border methods include default value X, 'symmetric', 'replicate' and
% 'circular'
% X would be suitable for known border types (default value X)
% symmetric is appropriate for patterns (repeating tiles)
% replicate is appropriate for extending last known values of the img
% circular also for patterns?
imagesc(filtered_img);
%%
clear all
I = imread('cameraman.jpg');
I = im2double(I);
gaussFilt = fspecial('gaussian', 25, 10);
subplot(131)
filtered_img = imfilter( I, gaussFilt, 'circular');
imshow(filtered_img)
subplot(132)
filtered_img = imfilter( I, gaussFilt, 'replicate');
imshow(filtered_img)
subplot(133)
filtered_img = imfilter( I, gaussFilt, 'symmetric');
imshow(filtered_img)
%% Exercise 2.6

clearvars;

img = imread('coins.jpeg');
img = rgb2gray(img);
% image has WxH dimensions and filter has (2N+1)x(2M+1)
% convert to DOUBLE, VERY IMPORTANT. Find out why!
img = im2double(img);

separableFilter = [-1, 0, 1; ...
        -2, 0, 2; ...
        -1, 0, 1] * 1/8;

nonSeparableFilter = [-7 6 5;...
                    4 1 3;...
                    3 2 5] * 1/30;

timeS = zeros(50, 1);
timeNS = timeS;

for size = 1:50
    separableFilter = rand(size,1)*rand(1,size);
    tic
    filtered_img = imfilter( img, separableFilter, 'circular');
    timeS(size) = toc;
end
for size = 1:50
    nonSeparableFilter = rand(size,1)*rand(1,size);
    nonSeparableFilter(1,1) = 7;
    nonSeparableFilter(size,size) = 3;
    tic
    filtered_img = imfilter( img, nonSeparableFilter, 'circular');
    timeNS(size) = toc;
end
plot([1:50], timeS, [1:50], timeNS);
legend('separable filter', 'nonseparable filter');

% Conclusion: filtering with separable filters is much faster than with
% nonseparable filters, except for small size filters.
% A possible explanation can be that identifying if a filter is separable
% or not is very quick, but separating the filter takes some relatively
% fixed time (which is not needed for a nonseparable small filter and hence
% it is faster).

% To separate the filter, do SVD

% Finished at 13:22