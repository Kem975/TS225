clear; close all; clc

%% Pré-exécution

addpath('codes_barres_img/')
%str = 'cahier.jpg';
%A = imread(str);
%A = imread('code_barre_bouteille.jpg');
%A = imread('difficile.jpg');
%A = imread('cahier.jpg');
%A = imread('casino.jpg');
%A = imread('mars.jpg');
A = imread('facile.png');
%A = imread('bouteille2.jpg');
%A = imresize(A,1/2);


nbre_essai = 200;

 Y = 0.299*A(:,:,1) + 0.587*A(:,:,2) + 0.114*A(:,:,3);
M = do_masque(double(Y));

%%
imagesc(A);
result = zeros(13,nbre_essai);

for i=1:nbre_essai
    result(:,i) = code(M,A,Y); 
end

final = zeros(13,1);

for i=1:13
    tab = zeros(10,1);
    for j=1:nbre_essai
        ind = result(i,j);
        tab(ind+1)=tab(ind+1)+1;
    end
    [~,nbr] = max(tab);
    final(i)=nbr-1;
end
final'

%%
figure;
imshow(uint8((0.3+M).*double(A)));
        
        
        
