function [FilteredImage] = FilterRegions( OrigImage, BinaryForegroundMap, ...
                                          SharpeningAlpha, SmoothingSigma  )
%
% Inputs: 
% 
% OrigImage: RGB or grayscale input image to be filtered.
%
% BinaryForegroundMap: Binary map of the foreground region(s). The type 
% (class) of the input image must be logical.
%
% SharpeningAlpha: The parameter of the sharpening filter.
% 
% SmoothingSigma: Standard deviation of the gaussian filter.
%
% Outputs: 
%
% FilteredImage:  2D filtered image that has the same type and dimension 
% as the original one.
%

% OrigImage = double(OrigImage);
[H, W] = size(OrigImage);

a = SharpeningAlpha;
Lfilter = 4/(a+1)*[a/4 (1-a)/4 a/4;(1-a)/4 -1 (1-a)/4;a/4 (1-a)/4 a/4];
%  Lfilter = fspecial('laplacian', a); % another way

delta = zeros(3,3);
delta(2,2) = 1;
sharpenFilter = delta-Lfilter;

 % the smaller the sigma the more detailed (the less smoothing)
fSize = 7;


% Do sharpening on whole image to avoid contour sharpening
sharpenedPart = imfilter(OrigImage, sharpenFilter, 'symmetric');

sharpenedPart(~BinaryForegroundMap) = 0; % all foreground deleted

gaussFilt = fspecial('gaussian', fSize, SmoothingSigma);


% Do smoothing on all image -- to avoid boundary issues
smoothedPart = imfilter(OrigImage, gaussFilt, 'symmetric');
smoothedPart(BinaryForegroundMap) = 0; % all focus object deleted

% Type of resulting image should be the same of the original one!
FilteredImage = sharpenedPart+smoothedPart;

end