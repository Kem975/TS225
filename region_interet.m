clear;clc;close all;


addpath('codes_barres_img/');
img = double(imread('bouteille2.jpg'));

img = imresize(img, 1/2);

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
    masque = D(:,:,i) > seuil;
    if(max(max(masque)))
        figure,
        subplot(1,2,1)
        imshow(uint8(img_Y));
        subplot(1,2,2)
        imshow(uint8(masque.*img_Y));
    end
end

%%
%Recuperation des zones;
% f = bwlabel(masque);
% g = regionprops(f,'Area', 'BoundingBox');
% area_values = [g.Area];
% area_min = h*w*0.1;
% area_max = h*w*0.5;
% idx =  find((area_values>=area_min) & (area_values<=area_max));
% masque_final = ismember(f,idx);
% figure(2),
% imshow(uint8(img.*masque_final))