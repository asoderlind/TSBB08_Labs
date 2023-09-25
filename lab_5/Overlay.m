close all, clc, clear all;
% ###########
% Overlay tip
% ###########

% Read a colour image
% ===================
im1 = double(imread('C9minpeps2.bmp'));
figure(50), imshow(im1/255);

% Get the three colour components RGB
% ===================================
im1r=im1(:,:,1); im1g=im1(:,:,2); im1b=im1(:,:,3);

% Produce a mask image with an overlay pattern
% ============================================
immask = zeros(1000,1000);
M = [ 1 1 0 0 0 0 0 0 0 0 1 1;
      1 1 1 0 0 0 0 0 0 1 1 1;
      1 1 1 1 0 0 0 0 1 1 1 1;
      1 1 0 1 1 0 0 1 1 0 1 1;
      1 1 0 0 1 1 1 1 0 0 1 1;
      1 1 0 0 0 1 1 0 0 0 1 1;
      1 1 0 0 0 0 0 0 0 0 1 1;
      1 1 0 0 0 0 0 0 0 0 1 1;
      1 1 0 0 0 0 0 0 0 0 1 1;
      1 1 0 0 0 0 0 0 0 0 1 1;
      1 1 0 0 0 0 0 0 0 0 1 1;
      1 1 0 0 0 0 0 0 0 0 1 1];
immask(500:511,500:511) = M; 

% Put the overlay pattern in magenta on the color image
% =====================================================
im2 = zeros(1000,1000,3);
im2(:,:,1) = (immask==1) .* 255 + (immask==0) .* im1r;
im2(:,:,2) = (immask==1) .*   0 + (immask==0) .* im1g;
im2(:,:,3) = (immask==1) .* 255 + (immask==0) .* im1b;

figure(51), imshow(im2/255);

