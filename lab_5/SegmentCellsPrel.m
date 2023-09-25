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
figure(2), imagesc(im1r,[0 255]), axis image, colormap(gray), colorbar; 
title('Red image');
figure(3), imagesc(im1g,[0 255]), axis image, colormap(gray), colorbar;
title('Green image');
figure(4), imagesc(im1b,[0 255]), axis image, colormap(gray), colorbar; 
title('Blue image');

% Compute histogram of central part of the blue image
% ===================================================
histo = hist(im1bSmall(:),[0:255]);
figure(5), stem(histo);

%% ######################################################################

% Perform thresholding
% ====================
im1bT = im1b > 42;
figure(6), imagesc(im1bT), axis image, colormap(gray), colorbar;
title('After thresholding');

% Perform opening
% ===============
SE4 = [0 1 0;
       1 1 1;
       0 1 0];
SE8 = [1 1 1;
       1 1 1;
       1 1 1];
tmp = im1bT;
tmp = imerode(tmp, SE4);
tmp = imdilate(tmp, SE4);
im1bTmorph  = tmp;
figure(7), imagesc(im1bTmorph), axis image, colormap(gray), colorbar;
title('After morphological processing');

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