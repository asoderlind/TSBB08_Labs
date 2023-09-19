
%% Make image
close all; clc; clear;

binvect = [0:1:255];

% Read the image and cast it to double
% ====================================
nuf = double(imread('nuf2b.tif'));
sigma = 21;

% Extend the image
% ================
tmp = [nuf(:,64:-1:1) nuf nuf(:,128:-1:65)];
nufextend = [tmp(64:-1:1,:); tmp; tmp(128:-1:65,:)];

% Make a Gaussian filter
% ======================
lpH=exp(-0.5*([-64:64]/sigma).^2);
lpH=lpH/sum(lpH); % Horizontal filter
lpV=lpH';         % Vertical filter

% Convolve in the horizontal and vertical direction
% =================================================
nufblur = conv2(nufextend, lpH, 'valid');
nufblur = conv2(nufblur, lpV, 'valid');

% Make a new image
% ================
nuf = nuf - nufblur + 128;

figure;
colormap(gray(256))

subplot(3,2,1),
imagesc(nufextend, [0 255])
axis image; colorbar
title('extended image')

subplot(3,2,2), imagesc(nufblur, [0 255])
axis image; colorbar
title('blurred image image')

subplot(3,2,3), imagesc(nuf, [0 255])
axis image; colorbar
title('new image')

A = 1.6;
b = 50;

nuf = nuf-b;
nuf = nuf*A;

subplot(3,2,4), imagesc(nuf, [0 255])
axis image; colorbar
title('new image')

histo = hist(nuf(:), binvect);
subplot(3,2,5), plot(binvect, histo, '.-b');
axis tight; title('histogram')


%% Run OCR
close all; clc; clear;


A = 2.7;
b = 80;
pruning_n = 5;
sigma = 21;
sum = 0;

res = demoC("nuf2b.tif", A, b, pruning_n, sigma, true)

disp("Sum is " + sum)