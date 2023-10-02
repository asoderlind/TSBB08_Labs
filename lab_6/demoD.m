im = double(imread('blod256.tif'));
start_X = 155;
start_Y = 74;
kernel_size = 19;
pattern = im(start_X:start_X + kernel_size, start_Y:start_Y + kernel_size);
fact = 0.37;
rescorr = corr(im, pattern);

rescorrdc = corrdc(im, pattern);

threshim = rescorrdc > (max(rescorrdc(:)*fact));

threshimShrink = bwmorph(threshim, "shrink", inf);

sum(threshimShrink(:))

figure(1);
colormap(gray(256))
subplot(2, 2, 1), imagesc(im, [0 255]);
axis image; title('original image'); colorbar;
subplot(2, 2, 2), imagesc(pattern, [0 255]);
axis image; title('pattern'); colorbar;
subplot(2, 2, 3), imagesc(rescorrdc);
axis image; title('result corr (normalized)'); colorbar;
subplot(2, 2, 4), imagesc(threshim);
axis image; title('thresh corr (normalized)'); colorbar;

% Overlay
% =======
figure(2);
blod = im;
detectim2 = threshim;
resultim = zeros(256, 256, 3);
resultim(:, :, 1) = (detectim2 == 1) .* 255 + (detectim2 == 0) .* blod;
resultim(:, :, 2) = blod;
resultim(:, :, 3) = blod;
imshow(resultim / 255);