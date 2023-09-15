im = double(imread('baboon.tif'));
figure(1)

mycolormapR = gray(256);
mycolormapR(1:50, :) = ones(50, 1)*[0 1 0];
mycolormapR(201:256,:) = ones(56,1)*[0 0 1];

colormap(mycolormapR)

subplot(1,2,1), imagesc(im, [0 255])
axis image; title('original image')
colorbar('SouthOutside')

subplot(1,2,2), imagesc(im, [50, 200])
axis image; title('contrast image')
colorbar('SouthOutside')