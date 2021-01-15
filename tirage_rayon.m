function [ x,y,Ex,Ey ] = tirage_rayon( region_interet )
     [h,w,c] = size(region_interet);
%     x = [1;w];
%     y = randi([0 h],1,2);
    [cov,Ex,Ey]= matrix_cov(region_interet);
    [V,D] = diago(cov);
    dir = V(2,:);
    min = inf;
    max = 0;
    for i = 1:h
        for j = 1:w
            if (region_interet(i,j))
                proj = sum([i,j].*dir);
                if (min>proj)
                    min = proj;
                end
                if (max < proj)
                    max = proj;
                end
            end
        end
    end
    decx = 1.5*randn(1,2);
    decy = 1.5*randn(1,2);
    x = [Ex,Ey] + max * dir + decx;
    y = [Ex,Ey] - max * dir + decy;
    x = fix(x);
    y = fix(y);
    
    

end

