im = double(imread('baboon.tif'));
figure(1)

colormap(gray(256))

aver = [1 2 1; 2 4 2; 1 2 1] / 16;
imaver = conv2(im, aver,'same');
imaver2 = conv2(imaver, aver, 'same');
imaver3 = conv2(imaver2, aver, 'same');

subplot(1,2,1), imagesc(im, [0 255])
axis image; title('original image')
colorbar('SouthOutside')

subplot(1,2,2), imagesc(imaver3, [0, 255])
axis image; title('convolved image')
colorbar('SouthOutside')