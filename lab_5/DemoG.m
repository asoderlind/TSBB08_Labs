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
histo = hist(im1bSmall(:),[0:255]);
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
% figure(7), imagesc(im1bTmorph), axis image, colormap(gray), colorbar;
% title('After morphological processing');

%% ######################################################################

% Compute the distance transform within the cells
% ===============================================
bw = im1bTmorph;
D = bwdist(~bw);
% figure(8), imagesc(D); axis image, colormap(jet), colorbar;
% title('Distance transform of ~bw');
% colormap(jet), colorbar;

% Multiply the distance transform with -1
% and set pixels outside to the min-value.
% This is the desired landscape.
% ========================================
Dinv = -D;
Dinv(~bw) = min(min(Dinv));
% figure(9), imagesc(Dinv), axis image, colormap(jet), colorbar;
% title('Landscape 1');
% colormap(jet), colorbar;
%% ==========================
% Convolve with laplace filter
F = [-2 -4 -4 -4 -2;
     -4  0  8  0 -4;
     -4  8 24  8 -4;
     -4  0  8  0 -4;
     -2 -4 -4 -4 -2]/64;
im1rConv = conv2(F, im1r);
figure(10), imagesc(im1rConv), axis image, colormap("gray"), colorbar;
title('Neg Laplace Filtered Red image');

%% ===========================
% Detect red padlock signals by threshold mult.
histo = hist(im1rConv(:),[0:255]);

im1rConvT = im1rConv > 35;

im1rConvTmult = im1rConv .* im1rConvT;

figure(6), imagesc(im1rConvT), axis image, colormap(gray), colorbar;
title('After thresholding');

figure(8), imagesc(im1rConvTmult), axis image, colormap(gray), colorbar;
title('After thresholding and mult');

im1rConvTmultMax = imregionalmax(im1rConvTmult);
figure(9), imagesc(im1rConvTmultMax), axis image, colormap(gray), colorbar;
title('After thresholding and mult and max');

sum(sum(im1rConvTmultMax))

SE4 = [0 1 0;
       1 1 1;
       0 1 0];
SE8 = [1 1 1;
       1 1 1;
       1 1 1];

im1rConvTmultMaxDilated = im1rConvTmultMax;
for i=1:5
    im1rConvTmultMaxDilated = imdilate(im1rConvTmultMaxDilated, SE8);
    im1rConvTmultMaxDilated = imdilate(im1rConvTmultMaxDilated, SE4);
end
im1rConvTmultMaxDilatedPunched = im1rConvTmultMaxDilated - im1rConvTmultMax;
im1rConvTmultMaxDilatedPunchedCirles = bwmorph(im1rConvTmultMaxDilatedPunched, 'shrink', inf);

figure, imagesc(im1rConvTmultMaxDilatedPunchedCirles), axis image, colormap(gray), colorbar;
title('Circles');






