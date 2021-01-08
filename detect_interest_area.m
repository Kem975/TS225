function [D] = detect_interest_area(img_Y,sigma_g)
    
    [h,w] = size(img_Y);

    %Canny
    fprintf(1,"Calcul du gradient...\n");
    N_canny = fix(3*sigma_g);
    [X, Y] = meshgrid(-N_canny:N_canny);
    canny_x = X/(2*pi*sigma_g^4).*exp(-(X.^2+Y.^2)/(2*sigma_g^2));
    canny_y = Y/(2*pi*sigma_g^4).*exp(-(X.^2+Y.^2)/(2*sigma_g^2));
    grad_x = conv2(img_Y,canny_x,'same');
    grad_y = conv2(img_Y,canny_y,'same');
    norm_grad = sqrt(grad_x.^2+grad_y.^2);
    grad_x = grad_x./norm_grad;
    grad_y = grad_y./norm_grad;
    fprintf(1,"Gradient calculé\n");
    %Gaussien
    sigma_t =sigma_g*25;
    N_gauss = fix(3*sigma_t);
    [X,Y] = meshgrid(-N_gauss:N_gauss);
    Wx = 1/(2*pi*sigma_t^2).*exp(-X.^2/(2*sigma_t^2));  
    Wy = Wx';
    %Tenseur
    fprintf(1,"Calcul du tenseur...\n");
    T = zeros(h,w,3);
    grad_xy = grad_x.*grad_y;
    fprintf(1,"Calcul de Gxy\n");
    grad_xx = grad_x.*grad_x;
    fprintf(1,"Calcul de Gxx\n");
    grad_yy = grad_y.*grad_y;
    fprintf(1,"Calcul de Gyy\n");
    T(:,:,1)=conv2(conv2(grad_xx,Wx,'same'),Wy,'same');
    fprintf(1,"Calcul de Txx\n");
    T(:,:,2) = conv2(conv2(grad_xy,Wx,'same'),Wy,'same');
    fprintf(1,"Calcul de Txy\n");
    T(:,:,3) = conv2(conv2(grad_yy,Wx,'same'),Wy,'same');
    fprintf(1,"Calcul de Tyy\n");
    D = sqrt((T(:,:,1)-T(:,:,3)).^2+4*T(:,:,2).^2)./(T(:,:,1)+T(:,:,3));
    
end

