function result = applyImageFilter( img, filt )
    result = zeros(size(img));
    N = (size(filt,1)-1)/2;
    M = (size(filt,2)-1)/2;
    W = size(img,1);
    H = size(img,2);
    for x=1:W
        for y=1:H
            for i=-N:N
                for j=-M:M
                    if(x+i < 1 || x+i > W || y+j < 1 || y+j > H)
                        buff = 0;
                    else
%                         x,i,y,j
                        buff = img(x+i, y+j) * filt(i+N+1,j+N+1);
                    end
                    result(x,y) = result(x,y) + buff;
                end
            end
        end
    end
end