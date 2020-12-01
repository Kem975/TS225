clear all; close all; clc 

%% Pré-exécution

addpath('codes_barres_img/')
A = imread('difficile.jpg');
figure,
imagesc(A);axis('square');
hold all

%% Paramètres

[h,w,c] = size(A);
[x y] = ginput(2);
x = [fix(x(1)) fix(x(2))];
y = [fix(y(1)) fix(y(2))];
X_dist = x(2)-x(1);
Y_dist = y(2)-y(1);
rayon_dist = round( sqrt( X_dist^2 + Y_dist^2 ) );
N = 256;
Y = 0.299*A(:,:,1) + 0.587*A(:,:,2) + 0.114*A(:,:,3);


rayon = zeros(3, rayon_dist);

for i=1:rayon_dist
    
    rayon(1:2,i) = round( [x(1);y(1)] + ((i-1)/rayon_dist-1)*([x(1);y(1)] - [x(2);y(2)]) );
    
    rayon(3, i) = double(Y( rayon(2,i), rayon(1,i) ));   
end

rayon(3,:) = flip(rayon(3,:));

%plot(rayon(1,:), rayon(2,:));



%% Otsu

H = hist(rayon(3,:),N);

[seuil,idx] = otsu(H,N);

bin = double(rayon(3,:)<idx);
%% Borne
unite = ceil(rayon_dist/95);
debut = [ones(1,unite),zeros(1,unite),ones(1,unite)];

tmp = conv(bin,debut,'same');

[~,ind] = max(tmp);

plot(rayon(1,ind:ind+3*unite),rayon(2,ind:ind+3*unite));
legend('test');