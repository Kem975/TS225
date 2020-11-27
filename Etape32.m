clear all; close all; clc 

%% Pr�-ex�cution

addpath('codes_barres_img/')
A = imread('facile.png');
figure,
subplot(121)
imagesc(A);axis('square');
hold all

%% Param�tres

[h,w,c] = size(A);
[x y] = ginput(2);
x = [fix(x(1)) fix(x(2))];
y = [fix(y(1)) fix(y(2))];
X_dist = x(2)-x(1);
Y_dist = y(2)-y(1);
rayon_dist = round( sqrt( X_dist^2 + Y_dist^2 ) );
vect = zeros(1, round(rayon_dist));
N = 256;


%% Code-Barre

line_x = linspace( x(1), x(2), rayon_dist );
line_y = linspace( y(1), y(2), rayon_dist );

rayon = zeros(3, rayon_dist);

for i=1:rayon_dist
    rayon(1:3, i) = [ round(line_x(i)); round(line_y(i));  double(A(round(line_y(i)), round(line_x(i)),1)) ];   
end

plot(line_x, line_y),legend('Rayon s�lectionn�');
subplot(122)
plot(rayon(3,:))

%% Otsu

H = hist(rayon(3,:),N);
[k,idx] = max(H);

w_k = sum( H(1:idx) ) / sum( H(1:N) );

crit_k = w_k*( mu(H, N, N)-mu(H,idx,N) )^2 + (1-w_k)*mu(H,idx,N)^2;





