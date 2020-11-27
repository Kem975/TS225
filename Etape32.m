clear all; close all; clc 

%% Pré-exécution

addpath('codes_barres_img/')
A = imread('difficile.jpg');
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

rayon = zeros(3, rayon_dist);

for i=1:rayon_dist
    
    rayon(1:2,i) = round( [x(1);y(1)] + (i/rayon_dist-1)*([x(1);y(1)] - [x(2);y(2)]) );
    
    rayon(3, i) = double(Y( rayon(2,i), rayon(1,i) ));   
end

plot(rayon(1,:), rayon(2,:)),legend('Rayon sélectionné');
subplot(122)
plot(rayon(3,:))


%% Otsu

H = hist(rayon(3,:),N);

[seuil,idx] = otsu(H,N);

bin = double(rayon(3,:)<idx);


%%  Bords

for i=1:length(bin)
    if(bin(i)==1)
        coord_debut = [rayon(1,i), rayon(2,i)];
        bin = bin(i:end);
        break;
    end
end

for i=length(bin):-1:1
    if(bin(i)==1)
        coord_fin = [rayon(1,i), rayon(2,i)];
        bin = bin(1:i);
        break;
    end
end


%% Ré-échantillonnage

dist_xcb = abs(round(coord_debut(1) - coord_fin(1)));
dist_ycb = abs(round(coord_debut(2) - coord_fin(2)));

dist_cb = round( sqrt( dist_xcb^2 + dist_ycb^2 ) );

rayon_echantillonne = zeros(2, 95);

for i=1:95
    rayon_echantillonne(1:2,i) = round( [coord_debut(1);coord_debut(2)] + (i/94)*([coord_debut(1);coord_debut(2)] - [coord_fin(1);coord_fin(2)]) );
end






