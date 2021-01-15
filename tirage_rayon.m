function [ x,y,Ex,Ey ] = tirage_rayon( region_interet )
     [h,w,c] = size(region_interet);
%     x = [1;w];
%     y = randi([0 h],1,2);
    [cov,Ex,Ey]= matrix_cov(region_interet);
    [V,D] = diago(cov);
    dir = V(2,:);
    mint= inf;
    maxt = 0;
    for i = 1:h
        for j = 1:w
            if (region_interet(i,j))
                proj = sum([i,j].*dir);
                if (mint>proj)
                    mint = proj;
                end
                if (maxt < proj)
                    maxt = proj;
                end
            end
        end
    end
    
    dec = max(abs(mint),abs(maxt));
    decx = h/50*randn(1,2);
    decy = h/50*randn(1,2);
    x = [Ex,Ey] + dec/1.85 * dir + decx;
    y = [Ex,Ey] - dec/1.85 * dir + decy;
    x = fix(x);
    y = fix(y);
    
    

end

