function [k,idx] = otsu( H, N )
    crit = zeros(1,N); 

    for i=1:N
        w_k = sum( H(1:i) ) / sum( H(1:N) );
        mu_k_squared = mu(H,i,N)^2;
        premier_terme= ( mu(H, N, N)-mu(H,i,N) )^2;
        crit(i) = w_k*premier_terme + (1-w_k)*mu_k_squared;
    end
    [k,idx] = max(crit),
end


function rep = mu( H, u, N )
    rep = sum( [1:u].*H(1:u) ) / sum( H(1:N) );
end

