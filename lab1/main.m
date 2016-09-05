close all;
clear all;
I1 = double(imread('street1.gif'));
I2 = double(imread('street2.gif'));

%I1 = imread('street1.gif');
%I2 = imread('street2.gif');


figure
imagesc(I1-I2);
colormap gray;
colorbar
truesize
figure
imhist(uint8(I1-I2)); % histogram of integers, rather than doubles
figure
I3 = uint8(imsubtract(I1, I2));
imagesc(I3);
colormap gray;
colorbar


% for g=[0 .1 0.7 1]
%     for c=[0 .1 .7 1]
%         imagesc(process_im(I1, g, c));
%         input('');
%         close;
%     end
% end


%% Test of process_im
close all
clear all
I1 = double(imread('street1.gif'));

processed_I1 = process_im(I1, 1, 0);
figure
imagesc(processed_I1);
colormap gray
colorbar

%% Segmentation
clear all
close all
I1 = imread('wdg.png');
%imshow(I1);

I1 = uint8(rgb2gray(I1));
figure
imagesc(I1)
colormap gray;
colorbar;
figure
imhist(uint8(I1));
figure
imagesc(threshold_im(I1, 120, 160));
colormap gray;
colorbar
%%
imagesc(ThresholdAndPaint(I1, 0, 120, 255));
colorbar
colormap gray

%% Background subtraction (1)
clear all
close all
srcFiles = dir('sequence1/*.jpg');  % the folder in which ur images exists
length(srcFiles);
background = zeros(576,720,3);
for i = 1 : length(srcFiles)
    filename = strcat(pwd, '/sequence1/', srcFiles(i).name);
    I = double(imread(filename));
    background = background + I/length(srcFiles);
%    figure, imshow(I);
end
hist(reshape(background,[],3),1:max(background(:)));
colormap([1 0 0; 0 1 0; 0 0 1]);
figure
imagesc(uint8(background));

% figure
% imshow(uint8(background)) % similar to the line above
%%
close all
%imshow(uint8(background));
for i = 1 : length(srcFiles)
    filename = strcat(pwd, '/sequence1/', srcFiles(i).name);
    image = double(imread(filename));
    person = background-image;
    average_difference = mean(person, 3);
    subplot(1,2,1)
    imshow(uint8(average_difference));
    subplot(1,2,2)
    imshow(uint8(image));
    input('')
    close
end


%% Background subtraction (2) - Gaussian model
clear all
close all
srcFiles = dir('sequence1/*.jpg');  % the folder in which ur images exists
length(srcFiles)
background = zeros(576, 720, 3, length(srcFiles));
for i = 1 : length(srcFiles)
    filename = strcat(pwd, '/sequence1/', srcFiles(i).name);
    I = double(imread(filename));
    background(:,:,:,i) = I;
%    figure, imshow(I);
end

mean_model = mean(background,4); % gives a 3-channel model
% figure
% imshow(uint8(mean_model));
var_model = std(background,0,4); % gives a 3-channel model
figure
imagesc(uint8(mean(var_model,3)));

%%
img = mean(background(:,:,:,15),3); % image #1 - avg over channels
max = mean(mean_model+1*var_model,3);
min = mean(mean_model-1*var_model,3);
for i=1:576
    for j=1:720
        if(img(i,j)<max(i,j) && img(i,j)>min(i,j))
            img(i,j) = 255; %if value inside mean of pixel+-std put white
            % means very close to background, little variation
        end
    end
end
% img(find(img < mean(mean_model+var_model,3) & img > mean(mean_model-var_model,3))) = 255;
imshow(uint8(img));

%%
addpath /../
I = imread('apples.jpg');
imshow(I);
red = I(:,:,1);
green = I(:,:,2);
blue = I(:,:,3);
% figure
% imshow(red)
% colorbar
figure
imshow(green)
colorbar
% figure
% imshow(blue)
% colorbar
% figure
% imhist(green)
img = green;
img(find(img > 50)) = 255;
img(find(img <= 50)) = 0;
%     img = img / max(img(:));
% processed_green = threshold_im(green, 50, 255);
figure
processed_green = img;
imshow(processed_green)
img(find(img == 0)) = 1;
img(find(img == 255)) = 0;
processed_green = img;
binaryImage = (red > 150) .* (green < 80) .* (blue < 80);
[imageColor, nConnectedComponents] = CountConnectedComponents(processed_green, 50); % or binaryImage