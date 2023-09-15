clear; close all; clc

binvect = [0:1:255];

%% NUF5

load nuf5.mat

histo = hist(nuf5(:), binvect);
figure
colormap(gray(256))
subplot(2,1,1), imagesc(nuf5, [0 255]);
axis image; title('nuf5'); colorbar
subplot(2,1,2), plot(binvect, histo, '.-b');
axis tight; title('histogram')

T = 179;
nuf5T = (nuf5 < T);
histoT = hist(nuf5(:), [0 1]);,

figure
colormap(gray(2)) % Since it is binary, we only need two colors: black and white
subplot(2,1,1), imagesc(nuf5T, [0 1]);
axis image; title('thresholded image'); colorbar
subplot(2,1,2), plot([0 1], histoT, '.-b');
axis tight; title('histogram')

%% NUF0

load nuf0a.mat

histo = hist(nuf0a(:), binvect);
figure
colormap(gray(256))
subplot(2,1,1), imagesc(nuf0a, [0 255]);
axis image; title('nuf0a'); colorbar
subplot(2,1,2), plot(binvect, histo, '.-b');
axis tight; title('histogram')

T = 138;
nuf0aT = (nuf0a < T);
histoT = hist(nuf0a(:), [0 1]);,

figure
colormap(gray(2)) % Since it is binary, we only need two colors: black and white
subplot(2,1,1), imagesc(nuf0aT, [0 1]);
axis image; title('thresholded image'); colorbar
subplot(2,1,2), plot([0 1], histoT, '.-b');
axis tight; title('histogram')

%% OPERATION

SE4 = [0 1 0;
    1 1 1;
    0 1 0];
SE8 = [1 1 1;
    1 1 1;
    1 1 1];

%% NUF5

nuf5T_closed_4 = imdilate(nuf5T, SE4);
nuf5T_closed_4 = imerode(nuf5T_closed_4, SE4);

nuf5T_closed_8 = imdilate(nuf5T, SE8);
nuf5T_closed_8 = imerode(nuf5T_closed_8, SE8);

nuf0aT_closed_4 = imerode(nuf0aT, SE4);
nuf0aT_closed_4 = imerode(nuf0aT_closed_4, SE4);
nuf0aT_closed_4 = imdilate(nuf0aT_closed_4, SE4);
nuf0aT_closed_4 = imdilate(nuf0aT_closed_4, SE4);
nuf0aT_closed_4 = imdilate(nuf0aT_closed_4, SE4);
nuf0aT_closed_4 = imerode(nuf0aT_closed_4, SE4);

nuf0aT_closed_8 = imerode(nuf0aT, SE8);
nuf0aT_closed_8 = imerode(nuf0aT_closed_8, SE8);
nuf0aT_closed_8 = imdilate(nuf0aT_closed_8, SE8);
nuf0aT_closed_8 = imdilate(nuf0aT_closed_8, SE8);
nuf0aT_closed_8 = imdilate(nuf0aT_closed_8, SE8);
nuf0aT_closed_8 = imerode(nuf0aT_closed_8, SE8);


figure
%NUF5
colormap(gray(2)) % Since it is binary, we only need two colors: black and white
subplot(3,2,1), imagesc(nuf5T, [0 1]);
axis image; title('thresholded image'); colorbar
subplot(3,2,3), imagesc(nuf5T_closed_4, [0 1]); colorbar
axis image; title('closed image (D4)')
subplot(3,2,5), imagesc(nuf5T_closed_8, [0 1]); colorbar
axis image; title('closed image (D8)')
% NUF0
subplot(3,2,2), imagesc(nuf0aT, [0 1]);
axis image; title('thresholded image'); colorbar
subplot(3,2,4), imagesc(nuf0aT_closed_4, [0 1]); colorbar
axis image; title('closed image (D4)')
subplot(3,2,6), imagesc(nuf0aT_closed_8, [0 1]); colorbar
axis image; title('closed image (D8)')

