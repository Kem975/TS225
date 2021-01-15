function [cov,Ex,Ey] = matrix_cov( region_interet )
    N = sum( sum( region_interet ) );
    [h,w] = size( region_interet );
    Ex = 0;
    Ey = 0;
    for i = 1:h
        for j = 1:w
            if (region_interet(i,j))
                Ex=Ex+j;
                Ey=Ey+i;
            end
        end
    end
    Ex=Ex/N;
    Ey=Ey/N;
    cov = zeros(2);
    for i=1:h
        for j=1:w
            if (region_interet(i,j))
                cov(1,1) = cov(1,1)+ (j-Ex)^2;
                cov(2,2) = cov(2,2)+ (i-Ey)^2;
                cov(1,2) = cov(1,2)+ (j-Ex)*(i-Ey);
            end
        end
    end
    cov = 1/N*cov;
    cov(2,1)=cov(1,2);
    
end

