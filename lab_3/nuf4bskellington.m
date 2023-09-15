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
histoT = hist(nuf4bT(:), [0 1]);,

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
subplot(2,1,1), imagesc(nuf4bSkeleton, [0 1]);
axis image; title('Skeleton image'); colorbar
subplot(2,1,2), imagesc(nuf4bpruned, [0 1]);
axis image; title('Pruned skeleton image n=' + string(n)); colorbar