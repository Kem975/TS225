function [V,D] = diago( M )
    
    [V,D] = eig(M);

%     lambda = ones(1,2);
%     
%     Id = [1 0 ; 0 1];
%     M = M-lambda.*Id;
%     
%     Q = M(1,1)*M(2,2) - M(1,2)*M(2,1);    
    
end

