function [] = detect_interest_area(img_Y)
    
    [h,w] = size(img_Y);

    %Canny
    sigma_g = 2.5;
    N_canny = fix(3*sigma_g);
    [X, Y] = meshgrid(-N_canny:N_canny);
    canny_x = -X./(2*pi*sigma_g^4)*exp(-(X.^2+Y.^2)/(2*sigma_g^2));
    canny_y = -Y./(2*pi*sigma_g^4)*exp(-(X.^2+Y.^2)/(2*sigma_g^2));
    
    grad_x= conv2(img_Y,canny_x,'same');
    grad_y = conv2(img_Y,canny_y,'same');
    
    norm_grad = sqrt(grad_x.^2+grad_y.^2);
    
    grad_x = grad_x./norm_grad;
    grad_y = grad_y./norm_grad;
    
    %Gaussien
    sigma_t = 2;
    N_gauss = fix(3*sigma_t);
    [X,Y] = meshgrid(-N_gauss:N_gauss);
    gaussien = -1/(2*pi*sigma_t^2).*exp(-(X.^2+Y.^2)/(2*sigma_t^2));    
    W = conv2(img_Y,gaussien,'same');
    
    %Tenseur
     T = zeros(h,w,3);
%     for x=1:h
%         for y=1:w
%             for u=1:h
%                 for v=1:w
%                     if(x+u)<=h && (y+v)<=w
%                         T(x,y,1)=T(x,y,1)+W(u,v)*grad_x(x+u,y+v)*grad_x(x+u,y+v);
%                         T(x,y,2) = T(x,y,2)+W(u,v)*grad_x(x+u,y+v)*grad_y(x+u,y+v);
%                         T(x,y,4)=T(x,y,4)+W(u,v)*grad_y(x+u,y+v)*grad_y(x+u,y+v);
%                     end
%                 end
%             end
%             T(x,y,3)=T(x,y,2);
%         end
%     end
    grad_xy = grad_x.*grad_y;
    grad_xx = grad_x.*grad_x;
    grad_yy = grad_y.*grad_y;
    T(:,:,1)=conv2(grad_xx,W,'same');
    T(:,:,2) = conv2(grad_xy,W,'same');
    T(:,:,3) = conv2(grad_yy,W,'same');
    D = sqrt((T(:,:,1)-T(:,:,3)).^2+4*T(:,:,2).^2)./(T(:,:,1)+T(:,:,3));
    
    figure,
    imshow(uint8(abs(D)));
end

