clear;clc;

addpath('codes_barres_img/');
img = double(imread('code_barre_bouteille.jpg'));
[h,w] = size(img);

img = imresize(img, 0.25);

img_Y = 0.229*img(:,:,1)+0.587*img(:,:,2)+0.114*img(:,:,3);

D = detect_interest_area(img_Y);

%%
D_hist = hist(D,10000);
[k,idx] = otsu(D_hist,10000); 
masque =D> idx/10000;
masque = abs(masque-1);
figure,
subplot(1,2,1)
imshow(uint8(img_Y));
subplot(1,2,2)
imshow(uint8(masque.*img_Y));