function tab = code(A)
    Y = 0.299*A(:,:,1) + 0.587*A(:,:,2) + 0.114*A(:,:,3);
    %figure,
    %imshow(Y);
    %imshow(A);
    %hold all

    M = do_masque(double(Y));
    [x,y,Ex,Ey] = tirage_rayon(M); % Remplacer A par "région d'intérêt"
    x = doformat(x,A);
    y = doformat(y,A);
    %[x, y] = ginput(2); 
%     x = [max(fix(x(1)),fix(x(2))),min(fix(x(1)),fix(x(2)))]; 
%     y = [max(fix(y(1)),fix(y(2))),min(fix(y(1)),fix(y(2)))]; 
    X_dist = max(x(2)-x(1),x(1)-x(2));
    Y_dist = max(y(2)-y(1),y(1)-y(2));
    rayon_dist = round( sqrt( X_dist^2 + Y_dist^2 ) );
    N = 256;
    %% Code-Barre

    rayon = zeros(3, rayon_dist);

    for i=1:rayon_dist

        rayon(1:2,i) = round( x - ((i-1)/rayon_dist)*(x - y) );
        rayon(1:2,i)
        rayon(3, i) = double(Y( rayon(2,i), rayon(1,i) ));   
    end



    rayon(1,:) = flip(rayon(1,:));
    rayon(2,:) = flip(rayon(2,:));
    rayon(3,:) = flip(rayon(3,:));

    %plot(rayon(1,:), rayon(2,:));



    %% Otsu

    H = hist(rayon(3,:),0:N-1);

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



    %% Ré-échantillonnage

    rayon_echantillonne = zeros(3, 95)+1;

    multiple = ceil(rayon_dist/95)*4;
    dist_finale = multiple*95;

    for i=0:dist_finale-1
        rayon_echantillonne(1:2,i+1) = round( coord_debut' + (i/(dist_finale-1))*(coord_fin' - coord_debut') );
        rayon_echantillonne(3,i+1) = double(Y( rayon_echantillonne(2,i+1), rayon_echantillonne(1,i+1) ));
    end




    %% Binarisation avec le rayon final

    H_bordered = hist(rayon_echantillonne(3,:),0:N-1);

    [seuil_finale,idx_final] = otsu(H_bordered,N);

    bin_rayon = double(rayon_echantillonne(3,:)<idx_final);


    %% Affichage

    %Toujours la figure avec le code-barre
%     plot(rayon_echantillonne(1,:), rayon_echantillonne(2,:)),
%     legend('Rayon sélectionné', 'Rayon recadré et échantillonné');
% 
%     figure,
%     subplot(121)
%     plot(rayon(3,:)), title('Intensité du rayon sélectionné');
%     subplot(122)
%     plot(bin_rayon), title('Binarisation du rayon recadré');


    %% Identification

    tab = iden(bin_rayon,multiple);


end

