clear;clc;close all;


addpath('codes_barres_img/');
img = double(imread('bouteille2.jpg'));

%img = imresize(img, 1/2);

img_Y = (0.229*img(:,:,1)+0.587*img(:,:,2)+0.114*img(:,:,3));
[h,w] = size(img_Y);
sigma_g =1*[1/3 1/(2*sqrt(2)) 0.5 1/sqrt(2) 1 sqrt(2) 2];
D = zeros(h,w,length(sigma_g));
for i=1:length(sigma_g)
    fprintf(1,"Calcul n°%i\n",i);
    D(:,:,i) = detect_interest_area(img_Y,sigma_g(i));
end
% D=detect_interest_area(img_Y,sigma_g(1));
%%
close all;clc;
for i=1:length(sigma_g)
    seuil = 0.7;
    masque(:,:,i) = D(:,:,i) > seuil;
    if(max(max(masque(:,:,i))))
        figure,
        subplot(1,2,1)
        imshow(uint8(img_Y));
        subplot(1,2,2)
        imshow(uint8(masque(:,:,i).*img_Y));
    end
end

%%
%Recuperation des zones;
for i=1:length(sigma_g)
    m = masque(:,:,i);
    f = bwlabel(m);
    g = regionprops(f,'Area', 'BoundingBox');
    area_values = [g.Area];
    idx =  find((area_values==max(area_values)));
    masque_final(:,:,i) = ismember(f,idx);
end
for i=1:length(sigma_g)
    sum_area(i)=sum(sum(masque_final(:,:,i)));
end
for i=1:length(sigma_g)
    if(sum_area(i)==max(sum_area))
        M = masque_final(:,:,i);
    end
end
enlargeX=50
enlargeY=0
[row,col] = find(M);
code = img(min(row)-enlargeX:max(row)+enlargeX,min(col)-enlargeY:max(col)+enlargeY);

figure,
imshow(uint8(code))
