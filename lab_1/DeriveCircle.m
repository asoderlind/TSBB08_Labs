im = double(imread('circle.tif'));
figure(1)
colormap(gray(256))
subplot(2,2,1), imagesc(im, [0 255])
axis image; axis off; title('original image'); colorbar

cd = [1 0 -1]/2;
imdx = conv2(im,cd,'same');
imdx2 = imdx.^2;

Rcd = [1; 0; -1]/2;
imdy = conv2(im, Rcd, 'same');
imdy2 = imdy.^2;

gradient = sqrt(imdx2 + imdy2);

subplot(2,2,2), imagesc(abs(gradient), [0 255]);
axis image; axis off; title('magngrad image'); colorbar

subplot(2,2,3), imagesc(imdx, [-128 127])
axis image; axis off; title('imdx image'); colorbar

subplot(2,2,4), imagesc(imdy, [-128, 127])
axis image; axis off; title('imdy image'); colorbar
