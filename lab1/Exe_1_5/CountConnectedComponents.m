function [imageColor, nConnectedComponents] = CountConnectedComponents(binaryImage, epsilon)
    % [imageColor, nConnectedComponents] = CountConnectedComponents(binaryImage, elementsThreshold)
    % finds connected components of a binary image
    %
    % inputs :
    %   binaryImage = a binary image
    %   epsilon = threshold for considering only components with >= epsilon pixels
    %
    % outputs:
    % imageColor = image showing the connected components
    % nConnectedComponents = the number of connected components
    
    
    
    if(min(binaryImage(:)) < 0 || max(binaryImage(:)) > 1 || ndims(binaryImage) ~= 2)
        error('first input should be a binary image!')
    end
    CC = bwconncomp(binaryImage);
    imageApplesR = zeros(size(binaryImage));
    imageApplesG = zeros(size(binaryImage));
    imageApplesB = zeros(size(binaryImage));
    
    nElem = zeros(1, numel(CC.PixelIdxList));
    
    cmap = hsv;
    nConnectedComponents = 0;
    for i= 1: numel(CC.PixelIdxList)
        nElem(i) = numel(CC.PixelIdxList{i});
        if (nElem(i) < epsilon)
            continue
        end
        nConnectedComponents = nConnectedComponents +1;
        colorIdx = randi(size(cmap,1));
        imageApplesR(CC.PixelIdxList{i}) = cmap(colorIdx,1);
        imageApplesG(CC.PixelIdxList{i}) = cmap(colorIdx,2);
        imageApplesB(CC.PixelIdxList{i}) = cmap(colorIdx,3);
    end
    %figure, plot(nElem)
    imageColor = zeros(size(binaryImage,1), size(binaryImage,2), 3);
    imageColor(:,:,1) = imageApplesR;
    imageColor(:,:,2) = imageApplesG;
    imageColor(:,:,3) = imageApplesB;
    disp ([' Found n = ' num2str(nConnectedComponents) ' connected Components'])
end