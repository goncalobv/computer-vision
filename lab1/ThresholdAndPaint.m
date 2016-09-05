function img = ThresholdAndPaint(img, th1, th2, val)
    img(find(img < th1 | img > th2)) = val;
    img = img / max(img(:));
%     img = (img >= th1) .* (img <= th2) .* double(img); % this sets some
%     pixels to zero (black) where the others keep original colors
end