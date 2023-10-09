f = double(imread('skylt.tif')); % load image
% h0 = ones(5, 5) / 25; % a suitable filter
%h1 = 1; % A very small filter
h2 = ones(7, 7) / 49; % A big filter
h3 = ones(11, 11) / 121; % A very big filter
g = circconv(f, h3); % convolve
%snr = 20;
%snr = 5;
snr = 40;
h = addnoise(g, snr); % add noise with SNR=20dB
rho = 0.80;
%r = 1.0;
r = 0;
fhat = wiener(h, h3, snr, rho, r); % Wiener filter

% PLOTS
figure; colormap(gray);
subplot(2, 2, 1), imagesc(f, [0 255]), axis image
title('original image'); colorbar
subplot(2, 2, 2), imagesc(h, [0 255]), axis image
title('degraded image'); colorbar
subplot(2, 2, 3), imagesc(fhat, [0 255]), axis image
title('restored image'); colorbar
