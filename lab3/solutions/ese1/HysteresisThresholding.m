function edgeImage = HysteresisThresholding(maximaImage, lowThresh, highThresh)
    %edgeImage = HysteresisThresholding(maximaImage, lowThresh, highThresh)
    % maximaImage = double valued image, issued from the non-maxima suppression step
    % lowThresh, highThresh : Canny threshold values
    % edgeImage : output binay edge image
 
    assert(isa(maximaImage, 'double'),'input should be a double image')
    assert(lowThresh >= 0 && lowThresh<=100 ,'low threshold must be between 0 and 100 %')
    assert(highThresh >= 0 && highThresh<=100 ,'high threshold must be between 0 and 100 %')
    assert(lowThresh < highThresh,'did you invert high and low thresholds?')

    maxval = max(maximaImage(:));
    highThresh = highThresh * maxval/100;
    lowThresh = lowThresh * maxval/100;
    
    [h,w] = size(maximaImage);
    edgeImage = 0.5 * ones(h,w);
    
    edgeImage(maximaImage>highThresh) = 1;
    
    edgeImage(maximaImage < lowThresh) = 0;
    
    [vForeground, uForeground] = find(edgeImage ==1);
    while(~isempty(vForeground))
        [edgeImage, vForeground, uForeground] = RecursiveThresholding(edgeImage, vForeground, uForeground);    
    end
    edgeImage(edgeImage == 0.5) = 0;
end


function [edgeImage, vForeground, uForeground] = RecursiveThresholding(edgeImage, vForeground, uForeground)
    [h,w] = size(edgeImage);
    if isempty(vForeground)
        return
    end
    
    i = vForeground(1);
    j = uForeground(1);
    vForeground = vForeground(2:end);
    uForeground = uForeground(2:end);
    
    minx = max(1,j-1);
    maxx = min(w,1+j);
    miny = max(1,i-1);
    maxy = min(h,1+i);
    for ii = miny:maxy
        for jj = minx:maxx
            if edgeImage(ii,jj) == 0.5
                edgeImage(ii,jj) = 1;
                vForeground = [vForeground; ii];
                uForeground = [uForeground; jj];
            end
        end
    end
end
