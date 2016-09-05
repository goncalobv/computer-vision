clear all
close all
clc
%  image=imread('lena.jpg');
image=imread('./in3.jpg');

lowThresh = 10; % in percentage of the maximum of the gradient magnitude
highThresh = 40; % in percentage of the maximum of the gradient magnitude
sigmaSmoothing = 2;

%% 1. convert image in double, grayscale

image=im2double(rgb2gray(image));
[height,width]=size(image);

%% 2. smoothing using a filter
smoothingFilter = fspecial('gaussian',3*sigmaSmoothing, sigmaSmoothing);
smoothedImg = imfilter(image, smoothingFilter, 'symmetric');

%% 3. compute gradient magnitude and angle
derFilter = fspecial('sobel');
imageDx = imfilter(smoothedImg, derFilter', 'symmetric');
imageDy = imfilter(smoothedImg, derFilter, 'symmetric');

gradientModule = sqrt(imageDx.^2 + imageDy.^2);
% computing angle of gradients
gradientAngle=zeros(height, width);
for i=1:height
    for j=1:width
        gradientAngle(i,j) = atan2(imageDy(i,j), imageDx(i,j));
    end
end

figure, subplot(1,2,1), imagesc(gradientModule),
subplot(1,2,2), imagesc(gradientAngle)

%% 4.non maxima suppression
maximaImg = zeros(height, width);
for i = 2:height-1
    for j = 2:width-1
        angleNormal = gradientAngle(i,j);
        p1 = [j+cos(angleNormal); i + sin(angleNormal)];
        p2 = [j-cos(angleNormal); i - sin(angleNormal)];
        intensities = BilinearPixels(gradientModule, [p1(1) p2(1)], [p1(2) p2(2)]);
        if((gradientModule(i,j) > intensities(1)) && (gradientModule(i,j) > intensities(2)))
            maximaImg(i,j) = gradientModule(i,j);
        end
    end
end
    
%% 5. hysteresis thresholding
edgeImage = HysteresisThresholding(maximaImg, lowThresh, highThresh);

%% 6. the end =)
figure, subplot(1,2,1), imshow(image), title('original image')
subplot(1,2,2), imshow(edgeImage), title ('Canny edge image')

    
