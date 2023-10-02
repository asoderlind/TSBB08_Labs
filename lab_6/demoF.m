%im = double(rgb2gray(imread('chess.png')));

im = double(imread('cmanmod.png'));
% TODO: maria how you do this so good

figure(1)
subplot(2, 2, 1); colormap(gray(256)); imagesc(im, [0 256]); colorbar;
colormap(gray(256)); imagesc(im, [0 256]); colorbar;
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

% Compute the corner response function
[row, col] = size(fx);

% Initialize Harris corner response
C_harris = zeros(row, col);

% Compute the corner response function
k = 0.05;

for i = 3:row - 2

    for j = 3:col - 3
        % For each pixel, form the structure tensor T for that pixel

        T11_matrix = T11(i - 2:i + 2, j - 2:j + 2);
        T11_mean = mean(T11_matrix(:));

        T12_matrix = T12(i - 2:i + 2, j - 2:j + 2);
        T12_mean = mean(T12_matrix(:));

        T22_matrix = T22(i - 2:i + 2, j - 2:j + 2);
        T22_mean = mean(T22_matrix(:));

        T = [T11_mean, T12_mean;
             T12_mean, T22_mean];

        % Compute determinant and trace of T
        detT = det(T);
        traceT = trace(T);

        % Compute corner response
        res = detT - k * (traceT ^ 2);

        C_harris(i, j) = res;

    end

end

% Threshold the corner response function
fact = 0.10;
C_harrisT = (C_harris > fact * max(C_harris(:)));
C_harrisTshrink = bwmorph(C_harrisT, 'shrink', Inf);

subplot(2, 2, 2); colormap(gray); imagesc(C_harris); colorbar;
title('Harris corner response function');
axis image; axis off;

subplot(2, 2, 3); colormap(gray(256)); imagesc(T11, [0 6000]); colorbar;
title('T11');
axis image; axis off;

subplot(2, 2, 4); colormap(gray(256)); imagesc(T22, [0 6000]); colorbar;
title('T22');
axis image; axis off;

figure(2)
subplot(1, 2, 1); colormap(gray(256)); imagesc(C_harrisTshrink); colorbar;
title('Thresholded response function');
axis image; axis off;

% overlay
subplot(1, 2, 2); colormap(gray(256)); imagesc(im(2:end-1, 2:end-1)); colorbar;
% Find coordinates of all ones
[row, col] = find(C_harrisTshrink == 1);

% Display the coordinates
for i = 1:length(row)
    viscircles([col(i) row(i)], 3, 'EdgeColor', 'r');
end

axis image; axis off;
title('Overlay');
