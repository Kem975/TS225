clear all; close all; clc 

%% Pré-exécution

addpath('codes_barres_img/')
A = imread('facile.png');
figure,
subplot(121)
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

%% Code-Barre


rayon = zeros(2, rayon_dist);

line_x = linspace( x(1), x(2), rayon_dist );
line_y = linspace( y(1), y(2), rayon_dist );

rayon = zeros(3, rayon_dist);

for i=1:rayon_dist
    
    rayon(1:2,i) = round( [x(1);y(1)] + (i/rayon_dist-1)*([x(1);y(1)] - [x(2);y(2)]) );
    
    rayon(3, i) = double(Y( rayon(2,i), rayon(1,i) ));   
end

plot(line_x, line_y),legend('Rayon sélectionné');
subplot(122)
plot(rayon(3,:))


%% Otsu

H = hist(rayon(3,:),N);
[k,idx] = max(H);

w_k = sum( H(1:idx) ) / sum( H(1:N) );

crit_k = w_k*( mu(H, N, N)-mu(H,idx,N) )^2 + (1-w_k)*mu(H,idx,N)^2;






