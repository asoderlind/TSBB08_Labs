% Read the image and cast it to double
% ====================================
nuf = double(imread("nuf0b.tif"));
% Extend the image
% ================
tmp = [nuf(:,64:-1:1) nuf nuf(:,128:-1:65)];
nufextend = [tmp(64:-1:1,:); tmp; tmp(128:-1:65,:)];
% Make a Gaussian filter
% ======================
sigma=14;
lpH=exp(-0.5*((-64:64)/sigma).^2);
lpH=lpH/sum(lpH); % Horizontal filter
lpV=lpH';         % Vertical filter
% Convolve in the horizontal and vertical direction
% =================================================
nufblur = conv2(nufextend, lpH, "valid");
nufblur = conv2(nufblur, lpV, "valid");
% Make a new image
% ================
nuf = nuf - nufblur + 128;
figure(1)
colormap(gray(256))
subplot(2,2,1),
imagesc(nufextend, [0 255])
axis image; colorbar
title("extended image")
subplot(2,2,2),
plot(-64:64, lpH, ".-r")
axis tight; title("Gaussian kernel")
subplot(2,2,3), imagesc(nufblur, [0 255])
axis image; colorbar
title("blurred image image")
subplot(2,2,4), imagesc(nuf, [0 255])
axis image; colorbar
title("new image")

histo = hist(nuf(:), 0:255);
T = mean(mean(nuf));
Tmid = mid_way(histo, T);
Tmin = min_error(histo, Tmid)
disp(nuf);
imTmin = nuf <= Tmin;

figure(2)
colormap gray(256)
%subplot(2,2,1), imagesc(imTmin, [0 255])
imagesc(imTmin, [0 1])
axis image; colorbar
title ("min-error thresholding");
