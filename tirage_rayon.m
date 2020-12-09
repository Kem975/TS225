function [ x,y ] = tirage_rayon( region_interet )
    [h,w,c] = size(region_interet);
       
    x = [0;w];
    y = randi([0 h],1,2);

end

