clear;clc;close all

addpath('codes_barres_img/');
img = double(imread('code_barre_bouteille.jpg'));

img_Y = 0.229*img(:,:,1)+0.587*img(:,:,2)+0.114*img(:,:,3);

detect_interest_area(img_Y);

