close all; clc; clear all;
nuf = double(imread('nuf0c.tif'));
binvect = [0:1:255];
histo = hist(nuf(:), binvect);
T2 = 105;
T1 = 1.41 * (T2);
imT1 = nuf > T1;
imT2 = nuf > T2;
imHysteresis = hysteresis(nuf, imT1, imT2, true);
% Figures post-processed
% ======================
figure(1)
colormap(gray(256))
subplot(2, 3, 1), imagesc(nuf, [0 255]);
axis image; title('new image nuf0c'); colorbar
subplot(2, 3, 2), plot(binvect, histo, ' .- b');
axis tight; title('histogram')
subplot(2, 3, 4), imagesc(imT1, [0 1]);
axis image; title('thresholded image T1')
subplot(2, 3, 5), imagesc(imT2, [0 1]);
axis image; title('thresholded image T2')
subplot(2, 3, 6), imagesc(imHysteresis, [0 1]);
axis image; title('resulting image')
