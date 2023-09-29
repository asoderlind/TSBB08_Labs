% Read original image;
im = double(imread('cmanmod.png'));

figure(1)
colormap(gray(256))
subplot(1,1,1); imagesc(im, [0 256]); colorbar;
axis image; axis off;

% Compute derivative images
df = [1 0 -1; 2 0 -2; 1 0 -1]/8; % sobelx
fx=conv2(im,df, 'valid'); % With valid you get rid of the dark frame
maxv = max(max(abs(fx)))/2;

figure(2)
colormap(gray(256))
subplot(1,2,1); imagesc(fx, [-maxv maxv]); colorbar('horizontal'); 
axis image; axis off;
title('f_x')
