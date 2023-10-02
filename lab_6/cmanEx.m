close all; clear all; clc;
% Read original image;
im = double(imread('cmanmod.png'));

figure(1)
colormap(gray(256))
subplot(1, 1, 1); imagesc(im, [0 256]); colorbar;
axis image; axis off;

% Compute derivative images
dx = [1 0 -1;
      2 0 -2;
      1 0 -1] / 8; % sobelx
fx = conv2(im, dx, 'valid'); % With valid you get rid of the dark frame
maxx = max(max(abs(fx))) / 2;

dy = [1 2 1;
      0 0 0;
      -1 -2 -1] / 8; % sobely
fy = conv2(im, dy, 'valid'); % With valid you get rid of the dark frame
maxy = max(max(abs(fy))) / 2;

% structure tensor
% TODO: ask if there is a better way to do this
T11 = fx .* fx;
maxT11 = max(max(abs(T11))) / 2;

T22 = fy .* fy;
maxT22 = max(max(abs(T22))) / 2;

figure;
colormap(gray(256))
subplot(1, 2, 1); imagesc(fx, [-maxx maxx]); colorbar('horizontal');
axis image; axis off;
title('f_x')
subplot(1, 2, 2); imagesc(fy, [-maxy maxy]); colorbar('horizontal');
axis image; axis off;
title('f_y')

figure;
colormap(gray(256))
subplot(1, 2, 1); imagesc(T11, [0 6000]);
colorbar('vertical'); axis image; axis off;
title('T11')
colormap(gray(256))
subplot(1, 2, 2); imagesc(T22, [0 6000]);
colorbar('vertical'); axis image; axis off;
title('T22 ')
