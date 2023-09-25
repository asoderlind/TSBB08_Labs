% ################################
% Cell segmentation, preliminary 
% ################################

% Read a color image
% ==================
im1 = double(imread('C9minpeps2.bmp'));
figure(1), imshow(im1/255);
title('Original color image');

% Look at the three colour components RGB
% =======================================
im1r=im1(:,:,1); im1g=im1(:,:,2); im1b=im1(:,:,3); 
im1bSmall = im1(200:800,200:800,3);
% figure(2), imagesc(im1r,[0 255]), axis image, colormap(gray), colorbar; 
% title('Red image');
% figure(3), imagesc(im1g,[0 255]), axis image, colormap(gray), colorbar;
% title('Green image');
% figure(4), imagesc(im1b,[0 255]), axis image, colormap(gray), colorbar; 
% title('Blue image');

% Compute histogram of central part of the blue image
% ===================================================
% histo = hist(im1bSmall(:),[0:255]);
% figure(5), stem(histo);

%% ######################################################################

% Perform thresholding
% ====================
T = mean(mean(im1b));

Tmid = mid_way(histo, T);
Tmin = min_error(histo, Tmid);

im1bT = im1b > Tmin;
% figure(6), imagesc(im1bT), axis image, colormap(gray), colorbar;
% title('After thresholding');

% Perform opening
% ===============
im1bTmorph = bwareaopen(im1bT, 800); % automate P value?
im1bTmorph = imclose(im1bTmorph, ones(3,3));

% figure(7), imagesc(im1bTmorph), axis image, colormap(gray), colorbar;
% title('After morphological processing');

%% ######################################################################

% Compute the distance transform within the cells
% ===============================================
bw = im1bTmorph;
D = bwdist(~bw);
figure(8), imagesc(D); axis image, colormap(jet), colorbar;
title('Distance transform of ~bw');
colormap(jet), colorbar;

% Multiply the distance transform with -1
% and set pixels outside to the min-value.
% This is the desired landscape.
% ========================================
Dinv = -D;
Dinv(~bw) = min(min(Dinv));
figure(9), imagesc(Dinv), axis image, colormap(jet), colorbar;
title('Landscape 1');
colormap(jet), colorbar;
% Prepare for imhmin treatment
% ============================
E = Dinv;
E = imhmin(E,2);
figure(10), imagesc(E);
colormap(gray), colorbar;
title('imhmin treated landscape');
% Search local min
% ================
Emin = imregionalmin(E);
CC = bwconncomp(Emin,8);
ImLabel = labelmatrix(CC);
figure(11), imagesc(ImLabel);
colormap('jet'), colorbar;
title('local means (water holes)')
% Perform watershed transform
% ===========================
W1 = double(watershed(E));
figure(12), imagesc(W1);
colormap("jet"), colorbar;
title('Watershed transform of cells')
%% distance map outside cell

W1(W1 == 1) = 0;
W1(W1 > 0) = 1;
Im_eq = bwdist(W1);
Im_eq(Im_eq > 100) = 0;
figure(13), imagesc(Im_eq);
colormap('jet'), colorbar;
title('distance map')
