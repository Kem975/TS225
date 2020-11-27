function rep = mu( H, u, N )
    rep = sum( [1:u].*H(1:u) ) / sum( H(1:N) );
end

