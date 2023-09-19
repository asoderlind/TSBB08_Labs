function ocrOut = ocr(im_path, sigma, n_prune)
% Read the image and cast it to double
% ====================================
nuf = double(imread(im_path));
figure;
colormap gray(256)
imagesc(nuf, [0 255]);
axis image; colorbar
title("enhanced image " + im_path);
% Extend the image
% ================
tmp = [nuf(:,64:-1:1) nuf nuf(:,128:-1:65)];
nufextend = [tmp(64:-1:1,:); tmp; tmp(128:-1:65,:)];
% Make a Gaussian filter
% ======================

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

histo = hist(nuf(:), 0:255);
T = mean(mean(nuf));
Tmid = mid_way(histo, T);
Tmin = min_error(histo, Tmid);
imTmin = nuf <= Tmin;




% Erode the image with a d(oct) to get rid of small objects
% =========================================================
SE4 = [0 1 0; 1 1 1; 0 1 0];
SE8 = ones(3,3);
nufOpen = imTmin;
%nufOpen = imclose1(nufOpen, n_erode);
nufOpen = imerode(nufOpen, SE4);
nufOpen = imerode(nufOpen, SE8);
nufOpen = imdilate(nufOpen, SE4);
nufOpen = imdilate(nufOpen, SE8);

% Dilate the image to get rid of holes
% ====================================
nufClosed = nufOpen;

nufClosed = imdilate(nufClosed, SE4);
nufClosed = imdilate(nufClosed, SE8);
nufClosed = imdilate(nufClosed, SE4);
nufClosed = imdilate(nufClosed, SE8);

nufClosed = imerode(nufClosed, SE4);
nufClosed = imerode(nufClosed, SE8);
nufClosed = imerode(nufClosed, SE4);
nufClosed = imerode(nufClosed, SE8);

% Get skeleton
% ============
nufSkeleton = bwmorph(nufClosed, "skel", Inf);

% Label image
% ===========

labeledImage = bwlabel(nufSkeleton);

% Compute region properties
stats = regionprops(labeledImage, 'Area');

mainSize = max([stats.Area]);

% Initialize a binary mask to keep only the larger components
filteredBinaryImage = zeros(size(labeledImage));

% Loop through the components and keep only the largest object
for i = 1:numel(stats)
  if stats(i).Area >= mainSize
    filteredBinaryImage(labeledImage == i) = 1;
  end
end

% Prune skeleton to get rid of spurs
% ==================================
nufPruned = bwmorph(filteredBinaryImage, 'shrink', n_prune);

% Clean the image to remove pixels
%nufCleaned = bwmorph(nufPruned, 'clean', Inf);


%{
 % Invert the image
% ================
nufInverted = ~nufCleaned;
%}


% OCR
% ===
ocrOut = ocrdecide(nufPruned, 8);

% PLOTTING ZONE %
% ==============


%{
 figure;
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

figure;
colormap gray(256)
subplot(2,2,1), imagesc(imTmin, [0 1])
axis image; colorbar
title ("min-error thresholding");

subplot(2,2,2), imagesc(nufSkeleton, [0 1])
axis image; colorbar
title ("skeleton");
%}



figure;
colormap gray(256)
subplot(2,2,1), imagesc(nufClosed, [0 1])
axis image; colorbar
title ("Opened and closed image " + im_path);

subplot(2,2,2), imagesc(nufSkeleton, [0 1])
axis image; colorbar
title ("Skeleton");

subplot(2,2,3), imagesc(filteredBinaryImage, [0 1])
axis image; colorbar
title ("Filtered Skeleton");

subplot(2,2,4), imagesc(nufPruned, [0 1])
axis image; colorbar
title ("Pruned & filtered skeleton");


%{
 subplot(2,2,4), imagesc(nufInverted, [0 1])
axis image; colorbar
title ("Inverted skeleton " + im_path);
%}
