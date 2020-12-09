function tableau = fairetab(A,unite)
    [h,w] = size(A);
    
    tableau = zeros(h,w*unite);
    
    for i =1:h
        for j=1:w
            tableau(i,1+(j-1)*unite:j*unite) = A(i,j).*ones(1,unite);
        end
    end

end