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

%% Code-Barre

rayon = zeros(3, rayon_dist);

for i=1:rayon_dist
    
    rayon(1:2,i) = round( [x(1);y(1)] + (i/rayon_dist-1)*([x(1);y(1)] - [x(2);y(2)]) );
    
    rayon(3, i) = double(Y( rayon(2,i), rayon(1,i) ));   
end


rayon(1,:) = flip(rayon(1,:));
rayon(2,:) = flip(rayon(2,:));
rayon(3,:) = flip(rayon(3,:));

plot(rayon(1,:), rayon(2,:));



%% Otsu

H = hist(rayon(3,:),N);

[seuil,idx] = otsu(H,N);

bin = double(rayon(3,:)<idx);


%%  Bords

bin_bordered = bin;

for i=1:length(bin)
    if(bin(i)==1)
        coord_debut = [rayon(1,i), rayon(2,i)];
        bin_bordered = bin(i:end);
        break;
    end
end

for i=length(bin):-1:1
    if(bin(i)==1)
        coord_fin = [rayon(1,i), rayon(2,i)];
        bin_bordered = bin(1:i);
        break;
    end
end

%tab = iden(bin);


%% Ré-échantillonnage

rayon_echantillonne = zeros(3, 95);


coord_debut_mem = coord_debut;
coord_fin_mem = coord_fin;

if Y_dist>X_dist 
    coord_debut = [coord_debut(1); min(coord_debut(2), coord_fin(2))];
    coord_fin = [coord_fin(1); max(coord_debut_mem(2), coord_fin_mem(2))];
else
    coord_debut = [min(coord_debut(1), coord_fin(1)), coord_debut(2)];
    coord_fin = [max(coord_debut_mem(1), coord_fin_mem(1)) ; coord_fin(2)];
end

multiple = ceil(rayon_dist/95);
dist_finale = multiple*95;

for i=0:dist_finale-1
    rayon_echantillonne(1:2,i+1) = round( coord_debut' + (i/(dist_finale-1))*(coord_fin' - coord_debut') );
    rayon_echantillonne(3,i+1) = double(Y( rayon_echantillonne(2,i+1), rayon_echantillonne(1,i+1) ));
end

plot(rayon_echantillonne(1,:), rayon_echantillonne(2,:)),
legend('Rayon sélectionné', 'Rayon recadré et échantillonné');

%% Binarisation avec le rayon final

H_bordered = hist(rayon_echantillonne(3,:),N);

[seuil_finale,idx_final] = otsu(H_bordered,N);

bin_rayon = double(rayon_echantillonne(3,:)<idx_final);


figure,
subplot(121)
plot(rayon(3,:)), title('Intensité du rayon sélectionné');
subplot(122)
plot(bin_rayon), title('Binarisation du rayon recadré');




