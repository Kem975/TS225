clear;clc;close all;


%bwlabel
addpath('codes_barres_img/');
img = double(imread('code_barre_bouteille.jpg'));
[h,w] = size(img);

%img = imresize(img, 1/2);

img_Y = (0.229*img(:,:,1)+0.587*img(:,:,2)+0.114*img(:,:,3));

D = detect_interest_area(img_Y);
%%
N_otsu = 1000;
D_hist = hist(D,min(D):1/N_otsu:max(D));
[k,idx] = otsu(D_hist,N_otsu);
tmp = (min(D):(max(D)-min(D))/(N_otsu-1):max(D));
seuil = tmp(idx);
masque = D > seuil;
figure,
subplot(1,2,1)
imshow(uint8(img_Y));
subplot(1,2,2)
imshow(uint8(masque.*img_Y));