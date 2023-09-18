clear; close all; clc

binvect = [0:1:255];

load nuf4b.mat
histo = hist(nuf4b(:), binvect);
figure
colormap(gray(256))
subplot(2,1,1), imagesc(nuf4b, [0 255]);
axis image; title('dark image'); colorbar
subplot(2,1,2), plot(binvect, histo, '.-b');
axis tight; title('histogram')

T = 133;
nuf4bT = (nuf4b < T);
histoT = hist(nuf4bT(:), [0 1]);

figure
colormap(gray(2)) % Since it is binary, we only need two colors: black and white
subplot(2,1,1), imagesc(nuf4bT, [0 1]);
axis image; title('thresholded image'); colorbar
subplot(2,1,2), plot([0 1], histoT, '.-b');
axis tight; title('histogram')

nuf4bSkeleton = bwmorph(nuf4bT, 'skeleton', Inf);
n = 3;
nuf4bpruned = bwmorph(nuf4bSkeleton, 'shrink', n);

figure
colormap(gray(2))
subplot(3,1,1), imagesc(nuf4bSkeleton, [0 1]);
axis image; title('Skeleton image'); colorbar
subplot(3,1,2), imagesc(nuf4bpruned, [0 1]);
axis image; title('Pruned skeleton image n=' + string(n)); colorbar
subplot(3,1,3), imagesc(bwskel(nuf4bT), [0 1]);
axis image; title('Thresholded image (MATLAB)'); colorbar

% Stroke detection
B1 = [0 0 0;
    0 1 0;
    0 1 0];

% Background detection
B2 = [1 1 1;
    1 0 1;
    0 0 0];

% Hit or miss transform
nuf4bStrokeErode = imerode(nuf4bpruned, B1);
nuf4bStrokeErodeComp = imerode(~nuf4bpruned, B2);
Hit_or_Miss = nuf4bStrokeErode .* nuf4bStrokeErodeComp;

figure
colormap(gray(2))
subplot(2,1,1), imagesc(nuf4bpruned, [0 1]);
axis image; title('Pruned skeleton image n=' + string(n)); colorbar
subplot(2,1,2), imagesc(Hit_or_Miss, [0 1]);
axis image; title('Stroke image'); colorbar

% point of endpoint
x = 57;
y = 23;
[yout, xout] = track10(nuf4bpruned, y, x); % output is 31, 49
angle = atan2(-(y-yout), (x-xout)) % output is 2.4150