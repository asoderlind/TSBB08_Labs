close all; clc; clear all;
blod = double(imread('blod256.tif'));
binvect = [0:1:255];
histo = hist(blod(:), binvect);
T2 = 76;
T1 = 83;
imT1 = blod > T1;
imT2 = blod > T2;
imT2open = bwareaopen(imT2, 9);
detectim = hysteresis(blod, imT1, imT2open, false);
T2prim = 65;
imT2prim = blod > T2prim;
imT1prim = detectim;
detectim2 = hysteresis(blod, imT1prim, imT2prim, false);

% image labeling
CC = bwconncomp(detectim2);
ImLabel = labelmatrix(CC);
figure;
colormap(jet(256))
subplot(1,2,1), imagesc(detectim2);
axis image; title('Circles'); colorbar
subplot(1,2,2), imagesc(ImLabel);
axis image; title('Label image'); colorbar

numberOfCells = max(ImLabel(:))

% Figures post-processed
% ======================
figure;
colormap(gray(256))
subplot(2, 3, 1), imagesc(blod, [0 255]);
axis image; title('new image blod0c'); colorbar
subplot(2, 3, 2), imagesc(imT2open, [0 1]);
axis image; title('imT2open')
subplot(2, 3, 4), imagesc(imT1, [0 1]);
axis image; title('thresholded image T1')
subplot(2, 3, 5), imagesc(imT2, [0 1]);
axis image; title('thresholded image T2')
subplot(2, 3, 6), imagesc(detectim2, [0 1]);
axis image; title('resulting image')

% Overlay
% =======
resultim = zeros(256, 256, 3);
resultim(:, :, 1) = (detectim2 == 1) .* 255 + (detectim2 == 0) .* blod;
resultim(:, :, 2) = blod;
resultim(:, :, 3) = blod;
subplot(2, 3, 3), imshow(resultim / 255);
