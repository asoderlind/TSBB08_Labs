close all, clc, clear all;
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
%figure(2), imagesc(im1r,[0 255]), axis image, colormap(gray), colorbar; 
%title('Red image');
%figure(3), imagesc(im1g,[0 255]), axis image, colormap(gray), colorbar;
%title('Green image');
%figure(4), imagesc(im1b,[0 255]), axis image, colormap(gray), colorbar; 
%title('Blue image');

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
im1bTmorph = imclose(im1bTmorph, ones(3,3));

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
% Prepare for imhmin treatment
% ============================
E = Dinv;
E = imhmin(E,2);
% figure(10), imagesc(E);
% colormap('jet'), colorbar;
% title('imhmin treated landscape');
% Search local min
% ================
Emin = imregionalmin(E);
CC = bwconncomp(Emin,8);
ImLabel = labelmatrix(CC);
% figure(11), imagesc(ImLabel);
% colormap('jet'), colorbar;
% title('local means (water holes)')
% Perform watershed transform
% ===========================
W1 = double(watershed(E));
% figure(12), imagesc(W1);
% colormap("jet"), colorbar;
% title('Watershed transform of cells')
%% distance map outside cell

W1(W1 == 1) = 0;
W1(W1 > 0) = 1;
Im_eq = bwdist(W1);
Im_eq(Im_eq > 100) = 0;
% figure(13), imagesc(Im_eq);
% colormap('jet'), colorbar;
% title('distance map')

%% combined landscape
C = Im_eq + E .* im1bTmorph;
% figure(14), imagesc(C);
% colormap('jet'), colorbar;
% title('combined distance map and landscape')

%% Watershed on combined landscape
W2 = double(watershed(C));
figure(15), imagesc(W2);
colormap("jet"), colorbar;
title('Watershed transform of combined')

W3 = (W2==0);
% figure(16), imagesc(W3);
% colormap("jet"), colorbar;
% title('Binary outline')
%% ###########
% Overlay yellow circle

% Get the three colour components RGB
% ===================================
im1r=im1(:,:,1); im1g=im1(:,:,2); im1b=im1(:,:,3);

% Produce a mask image with an overlay pattern
% ============================================
immask = W3;

% Put the overlay pattern in magenta on the color image
% =====================================================
im2 = zeros(1000,1000,3);
im2(:,:,1) = (immask==1) .* 255 + (immask==0) .* im1r;
im2(:,:,2) = (immask==1) .* 255 + (immask==0) .* im1g;
im2(:,:,3) = (immask==1) .* 0 + (immask==0) .* im1b;

im2out = im2;

% figure, imshow(im2/255);
% title('yellow line overlay')
%% ==========================
% Convolve with laplace filter
F = [-2 -4 -4 -4 -2;
     -4  0  8  0 -4;
     -4  8 24  8 -4;
     -4  0  8  0 -4;
     -2 -4 -4 -4 -2]/64;
im1rConv = conv2(im1r, F, 'same');
% figure, imagesc(im1rConv), axis image, colormap("gray"), colorbar;
% title('Neg Laplace Filtered Red image');

%% ===========================
% Detect red padlock signals by threshold mult.
histo = hist(im1rConv(:),[0:255]);
padlockT = 40;
im1rConvT = im1rConv > padlockT;
im1rConvTmult = im1rConv .* im1rConvT;
im1rConvTmultMax = imregionalmax(im1rConvTmult);

selectedCell = input("please select your cell between 2-7: ");
variableMask = (W2 == selectedCell);
im1rConvTmultMax = im1rConvTmultMax .* variableMask;
amountOfCells = sum(sum(im1rConvTmultMax));
disp("amount of cells in area " + selectedCell + " = " + amountOfCells);

sum(sum(im1rConvTmultMax))

SE4 = [0 1 0;
       1 1 1;
       0 1 0];
SE8 = [1 1 1;
       1 1 1;
       1 1 1];

im1rConvTmultMaxDilated = im1rConvTmultMax;

% figure, imshow(im1rConvTmultMax), axis image, colormap('gray');
% title("max")

for i=1:5
    im1rConvTmultMaxDilated = imdilate(im1rConvTmultMaxDilated, SE8);
    im1rConvTmultMaxDilated = imdilate(im1rConvTmultMaxDilated, SE4);
end
im1rConvTmultMaxDilatedPunched = im1rConvTmultMaxDilated - im1rConvTmultMax;
im1rConvTmultMaxDilatedPunchedCirles = bwmorph(im1rConvTmultMaxDilatedPunched, 'shrink', inf);
% figure, imagesc(im1rConvTmultMaxDilatedPunchedCirles), axis image, colormap(gray), colorbar;
% title('Circles (WIP)');

%% ###########
% Overlay tip
% ###########

im1 = im2out;

% Get the three colour components RGB
% ===================================
im1r=im1(:,:,1); im1g=im1(:,:,2); im1b=im1(:,:,3);

% Produce a mask image with an overlay pattern
% ============================================
immask = im1rConvTmultMaxDilatedPunchedCirles;

% Put the overlay pattern in magenta on the color image
% =====================================================
im2 = zeros(1000,1000,3);
im2(:,:,1) = (immask==1) .* 0 + (immask==0) .* im1r;
im2(:,:,2) = (immask==1) .* 255 + (immask==0) .* im1g;
im2(:,:,3) = (immask==1) .* 255 + (immask==0) .* im1b;

figure, imshow(im2/255);
title('final')

