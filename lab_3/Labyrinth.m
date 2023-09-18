close all; clear all; clc;
Im = imread('labyrinth1.tif');
maxiter = 5000; % Number of iterations
maxval = 5000;
DistIm = maxval .* Im; % Set the obstacles to a high value
temp1  = 0 .* Im;
temp1(20,160) = 1; % Starting point
SE8 = [1 1 1;
    1 1 1;
    1 1 1];
for k=1:maxiter
    temp2 = imdilate(temp1, SE8);
    temp2 = temp2 .* ~Im;
    DistIm = DistIm + k*(temp2-temp1);
    temp1 = temp2;
end
figure(1)
colormap(gray(256))
imagesc(Im);
axis image; title('labyrinth'); colorbar

figure(2)
colormap(colorcube(5000+1))
imagesc(DistIm, [0 maxval]);
axis image; title('DistIm'); colorbar

trackDistIm = trackDist(Im, DistIm, 250, 450);
figure(3)
colormap(colorcube(5000+1))
imagesc(trackDistIm, [0 255]);
axis image; title('trackDistIm'); colorbar