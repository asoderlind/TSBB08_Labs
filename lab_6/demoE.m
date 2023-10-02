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

T12 = fx .* fy;

T22 = fy .* fy;
maxT22 = max(max(abs(T22))) / 2;

% let's do some lp filtering
sigma = 1.5;
lpH = exp(-0.5 * ([-9:9] / sigma) .^ 2);
lpH = lpH / sum(lpH); % Horizontal filter
lpV = lpH'; % Vertical filter

T11LP = conv2(T11, lpH, 'same');
T22LP = conv2(T22, lpV, 'same');

z = T11 - T22 + 1j * 2 * T12;

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
subplot(2, 2, 1); imagesc(T11, [0 6000]);
colorbar('vertical'); axis image; axis off;
title('T11')

colormap(gray(256))
subplot(2, 2, 2); imagesc(T22, [0 6000]);
colorbar('vertical'); axis image; axis off;
title('T22')

subplot(2, 2, 3); imagesc(T11LP, [0 3000]);
colorbar('vertical'); axis image; axis off;
title('T11 low passed')

colormap(gray(256))
subplot(2, 2, 4); imagesc(T22LP, [0 3000]);
colorbar('vertical'); axis image; axis off;
title('T22 low passed')

figure;
sub1 = subplot(1, 2, 1);
imagesc(abs(z), [0 6000]);
colorbar('horizontal');
axis image; axis off;
title('abs(z)')
colormap(sub1, gray(256))

arg_z = atan2(imag(z), real(z));
% add 2pi to negative values
arg_z(arg_z < 0) = arg_z(arg_z < 0) + 2 * pi;
sub2 = subplot(1, 2, 2);
imagesc(arg_z, [0 2 * pi]);
colorbar('horizontal'); axis image; axis off;
title('arg(z)')
colormap(sub2, 'goptab')
% TODO: ask about the green line at the top
