% Read a color image and convert to a gray-scale image
% ====================================================
[X,map] = imread('corn.tif');
newmap = rgb2gray(map);
corn = ind2gray(X,newmap);
im1gray = double(corn);
figure(1), imagesc(im1gray,[0 255]), colormap(gray), colorbar,
title('original image');
% Negate the image
% =================
im2gray = double(255-im1gray);
figure(2), imagesc(im2gray,[0 255]), colormap(gray), colorbar,
title('negated image = landscape');
% Prepare for smoothing
% =====================
kernel = [1 2 1; 2 4 2; 1 2 1] / 16;
D = im2gray;
k=1;
while k<5
  D = conv2(D, kernel, 'same');
  k = k+1; 
end
figure(3), imagesc(D);
colormap(gray), colorbar;
title('smoothed landscape');
% Perform watershed transform
% ===========================
W1 = double(watershed(D));
figure(4), imagesc(W1);
colormap(colorcube(300)), colorbar;
title('Watershed transform of smoothed landscape')
% Prepare for imhmin treatment
% ============================
E = im2gray;
E = imhmin(E,30);
figure(5), imagesc(E);
colormap(gray), colorbar;
title('imhmin treated landscape');
% Search local min
% ================
Emin = imregionalmin(E);
CC = bwconncomp(Emin,8);
ImLabel = labelmatrix(CC);
figure(6), imagesc(ImLabel);
colormap(colorcube(300)), colorbar;
title('local means (water holes)')
% Perform watershed transform
% ===========================
W2 = double(watershed(E));
figure(7), imagesc(W2);
colormap(colorcube(300)), colorbar;
title('Watershed transform of imhmin treated landscape')