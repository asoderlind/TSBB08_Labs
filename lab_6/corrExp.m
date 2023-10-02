im = double(imread('clic.tif'));
pattern = im(33:33 + 19, 18:18 + 19);
fact = 0.95;
rescorr = corr(im, pattern);
figure(1)
colormap(gray(256))
subplot(2, 2, 1), imagesc(im, [0 255]);
axis image; title('original image'); colorbar;
subplot(2, 2, 2), imagesc(pattern, [0 255]);
axis image; title('pattern'); colorbar;
subplot(2, 2, 3), imagesc(rescorr);
axis image; title('result corr'); colorbar;
subplot(2, 2, 4), imagesc(rescorr > (max(rescorr(:)) * fact));
axis image; title('thresh corr'); colorbar;
%%
rescorrn = corrn(im, pattern);
figure(2)
colormap(gray(256))
subplot(2, 2, 1), imagesc(im, [0 255]);
axis image; title('original image'); colorbar;
subplot(2, 2, 2), imagesc(pattern, [0 255]);
axis image; title('pattern'); colorbar;
subplot(2, 2, 3), imagesc(rescorrn);
axis image; title('result corr (normalized)'); colorbar;
subplot(2, 2, 4), imagesc(rescorrn > (max(rescorrn(:)) * fact));
axis image; title('thresh corr (normalized)'); colorbar;
%%
rescorrdc = corrdc(im, pattern);
figure(3)
colormap(gray(256))
subplot(2, 2, 1), imagesc(im, [0 255]);
axis image; title('original image'); colorbar;
subplot(2, 2, 2), imagesc(pattern, [0 255]);
axis image; title('pattern'); colorbar;
subplot(2, 2, 3), imagesc(rescorrdc);
axis image; title('result corr (no DC comp)'); colorbar;
subplot(2, 2, 4), imagesc(rescorrdc > (max(rescorrdc(:)) * fact));
axis image; title('thresh corr (no DC comp)'); colorbar;
%%
rescorrc = corrc(im, pattern);
figure(4)
colormap(gray(256))
subplot(2, 2, 1), imagesc(im, [0 255]);
axis image; title('original image'); colorbar;
subplot(2, 2, 2), imagesc(pattern, [0 255]);
axis image; title('pattern'); colorbar;
subplot(2, 2, 3), imagesc(rescorrc);
axis image; title('result corr (normalized without DC level)'); colorbar;
subplot(2, 2, 4), imagesc(rescorrc > (max(rescorrc(:)) * fact));
axis image; title('thresh corr (normalized without DC level)'); colorbar;
