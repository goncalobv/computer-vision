% used to normalize images in terms of absolute values and
% to pass them through a sigmoid filter
% g and c are parameters of the filter: H = 1/(1+exp(g * exp(c -
% normalized_img))

% g decreases variance of values in image (values go towards zero,
% increases homogeneity) - bigger g less contrast, less g (negative) bigger contrast

% c sets a threshold to eliminate certain components


function processed_im = process_im(im, g, c)
    if ndims(im) > 2
        error('must be called on grayscale images!')
    end
    
    processed_im = im-min(min(im));
    
    processed_im = processed_im./max(max(processed_im)); % values are normalized
%     figure
%     imhist(int8(processed_im));
    processed_im =  1./(1 + exp(g*(c-processed_im)));  % Apply Sigmoid function
%     figure
%     imhist(int8(processed_im));

end