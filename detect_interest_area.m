function [D] = detect_interest_area(img_Y)
    
    [h,w] = size(img_Y);

    %Canny
    sigma_g = 80;
    sigma_g = min(sigma_g,100);
    N_canny = fix(3*sigma_g);
    [X, Y] = meshgrid(-N_canny:N_canny);
    canny_x = -X/(2*pi*sigma_g^4).*exp(-(X.^2+Y.^2)/(2*sigma_g^2));
    canny_y = -Y/(2*pi*sigma_g^4).*exp(-(X.^2+Y.^2)/(2*sigma_g^2));
    9
    grad_x = conv2(img_Y,canny_x,'same');
    10
    grad_y = conv2(img_Y,canny_y,'same');
        
    norm_grad = sqrt(grad_x.^2+grad_y.^2);
    
    grad_x = grad_x./norm_grad;
    grad_y = grad_y./norm_grad;
    11
    %Gaussien
    sigma_t = 1;
    sigma_t = min(sigma_t,25);
    N_gauss = fix(3*sigma_t);
    [X,Y] = meshgrid(-N_gauss:N_gauss);
    W = 1/(2*pi*sigma_t^2).*exp(-(X.^2+Y.^2)/(2*sigma_t^2));  
    12
    
    %Tenseur
    T = zeros(h,w,3);
    13
    grad_xy = grad_x.*grad_y;
    14
    grad_xx = grad_x.*grad_x;
    15
    grad_yy = grad_y.*grad_y;
    16
    T(:,:,1)=conv2(grad_xx,W,'same');
    17
    T(:,:,2) = conv2(grad_xy,W,'same');
    18
    T(:,:,3) = conv2(grad_yy,W,'same');
    19
    D = sqrt((T(:,:,1)-T(:,:,3)).^2+4*T(:,:,2).^2)./(T(:,:,1)+T(:,:,3));
    
end

