function [out] = doformat(in,A)
    
    out = [-1,-1];
    [h,w,~]=size(A);
    if (in(1)<1)
        out(1) = 1;
    end
    if (in(2)<1)
        out(2) = 1;
    end
    if (in(1)>w)
        out(1)=w;
    end
    if (in(2)>h)
        out(1)=h;
    end
    
    if (out(1) ==-1)
        out(1) = in(1);
    end
    if (out(2) ==-1)
        out(2) = in(2);
    end
    
end

