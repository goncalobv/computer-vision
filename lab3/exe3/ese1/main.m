% Started at 15:06

clear all
close all
clc
% image=imread('lena.jpg');
image=imread('in1.jpg');
height = size(image,1);
width = size(image,2);

lowThresh = 10; % in percentage of the maximum of the gradient magnitude
highThresh = 40; % in percentage of the maximum of the gradient magnitude

% the lower the highThresh the more details in the canny, makes sense
% everything above high threshold is passed as a strong edge
% everything below the low threshold is discarded
% things in between are candidates, can be evaluated if they are connected
% to a strong edge (grad higher than high thres.)

%% 1. convert image in double, grayscale
image = rgb2gray(image);
image = im2double(image);


%% 2. smoothing using a filter
% smoothedImg = zeros(height,width);

fSigma = 2; % the smaller the sigma the more detailed (the less smoothing)
fSize = 3 * fSigma;
gaussFilt = fspecial('gaussian', fSize, fSigma);
smoothedImg = imfilter(image, gaussFilt, 'symmetric');
imagesc(smoothedImg);


%% 3. compute gradient magnitude and angle
gradientModule = zeros(height,width);
gradientAngle = zeros(height,width);

Sx = [-1, 0, 1; ...
        -2, 0, 2; ...
        -1, 0, 1] * 1/8;

Sy = Sx';
    
% convolve img with filt with the function you wrote
resultx = imfilter( smoothedImg, Sx );
resulty = imfilter( smoothedImg, Sy );

gradient = [resultx; resulty];

gradientModule = sqrt(resultx .^ 2 + resulty .^ 2); % should the gradient have 3 channels?
% on one hand it seems suitable as different channels can have different
% information.
gradientAngle = atan2(resulty, resultx); % atan 2 determines right quadrant for the phase

figure, subplot(1,2,1), imagesc(gradientModule), title('module')
subplot(1,2,2), imagesc(gradientAngle), title ('angle')

%% 4.non maxima suppression
% maximaImg = gradientModule;
maximaImg = zeros(height, width);

for i=2:height-1
    for j=2:width-1
        angleNormal = gradientAngle(i,j);
        p1 = [j + cos(angleNormal); i + sin(angleNormal)];
        p2 = [j - cos(angleNormal); i - sin(angleNormal)];
        intensities = BilinearPixels(gradientModule, [p1(1) p2(1)], [p1(2) p2(2)]); % the input for biliner pixels is gradient magnitude!!!
        if(gradientModule(i,j) >= intensities(1) && gradientModule(i,j) >= intensities(2))
            maximaImg(i,j) = gradientModule(i,j);
        end
    end
end
% xcoordsA = repmat([1:width],height,1)+cos(gradientAngle(:,:,1));
% ycoordsA = repmat([1:height]',1,width)+sin(gradientAngle(:,:,1));
% intensitiesA = BilinearPixels(smoothedImg, xcoordsA(:), ycoordsA(:));
% 
% intensitiesA = reshape(intensitiesA, height, width);
% 
% xcoordsB = repmat([1:width],height,1)-cos(gradientAngle(:,:,1));
% ycoordsB = repmat([1:height]',1,width)-sin(gradientAngle(:,:,1));
% intensitiesB = BilinearPixels(smoothedImg, xcoordsB(:), ycoordsB(:));
% intensitiesB = reshape(intensitiesB, height, width);
% 
% for x=2:width-1 % not working though =S
%     for y=2:height-1
%         if(gradientModule(y,x) >= intensitiesA(y,x) && gradientModule(y,x) >= intensitiesB(y,x))
%             maximaImg(y,x) = gradient(y,x);
%         end
%     end
% end

% Pause at 16:45 not finished, not even closer =S

imagesc(maximaImg);
%% 5. hysteresis thresholding
edgeImage = HysteresisThresholding(maximaImg, lowThresh, highThresh);
imagesc(uint8(edgeImage));
%% 6. the end =)
figure, subplot(1,2,1), imshow(image), title('original image')
subplot(1,2,2), imshow(edgeImage), title ('Canny edge image')
                    
% Finally finished at 14:50, 50 mins extra required, problem found in BilinearPixels that should get gradientModule as argument and not the image. Arrrgh took me so much time, should have just checked the solution.

