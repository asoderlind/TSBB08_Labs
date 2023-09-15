clear; close all; clc

binvect = [0:1:255];

load clic.mat
histo = hist(clic(:), binvect);
figure
colormap(gray(256))
subplot(2,1,1), imagesc(clic, [0 255]);
axis image; title('light image'); colorbar
subplot(2,1,2), plot(binvect, histo, '.-b');
axis tight; title('histogram')

load blod256.mat
histo = hist(blod256(:), binvect);
figure
colormap(gray(256))
subplot(2,1,1), imagesc(blod256, [0 255]);
axis image; title('dark image'); colorbar
subplot(2,1,2), plot(binvect, histo, '.-b');
axis tight; title('histogram')

Im = double(imread('baboon.tif'));
histo = hist(Im(:), binvect);
figure
colormap(gray(256))
subplot(2,1,1), imagesc(Im, [0 255]);
axis image; title('low contrast baboon'); colorbar
subplot(2,1,2), plot(binvect, histo, '.-b');
axis tight; title('histogram')

% grayscale transformation to increase contrast
A = 1.7; B = 85;
Im = A * Im - B;
histo = hist(Im(:), binvect);
figure
colormap(gray(256))
subplot(2,1,1), imagesc(Im, [0 255]);
axis image; title('high contrast baboon'); colorbar
subplot(2,1,2), plot(binvect, histo, '.-b');
axis tight; title('histogram')