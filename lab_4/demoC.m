function out = demoC(inputIm,A,b,pruning_n,sigma,showFigs)
% Read the image and cast it to double
% ====================================
nuf = double(imread(inputIm));

% Increase contrast of image
% ==========================
nuf = nuf*A-b;

% Extend the image
% ================
tmp = [nuf(:,64:-1:1) nuf nuf(:,128:-1:65)];
nufextend = [tmp(64:-1:1,:); tmp; tmp(128:-1:65,:)];

% Make a Gaussian filter
% ======================
lpH=exp(-0.5*([-64:64]/sigma).^2);
lpH=lpH/sum(lpH); % Horizontal filter
lpV=lpH';         % Vertical filter

% Convolve in the horizontal and vertical direction
% =================================================
nufblur = conv2(nufextend, lpH, 'valid');
nufblur = conv2(nufblur, lpV, 'valid');

% Make a new image
% ================
nuf = nuf - nufblur + 128;

if showFigs
    figure;
    colormap(gray(256))
    
    subplot(4,2,1),
    imagesc(nufextend, [0 255])
    axis image; colorbar
    title('extended image')
    
    subplot(4,2,2), imagesc(nufblur, [0 255])
    axis image; colorbar
    title('blurred image image')
    
    subplot(4,2,3), imagesc(nuf, [0 255])
    axis image; colorbar
    title('new image')
end

% thresholding the new image
% ==========================
histo = hist(nuf(:),[0:255]);

T = mean(mean(nuf));

Tmid = mid_way(histo, T);
Tmin = min_error(histo, Tmid);

imTmin = nuf < Tmin;

if showFigs
    subplot(4,2,4), imagesc(imTmin)
    axis image; colorbar
    title('thresholded image (Tmin)')    
end

% Open & Close the image to remove noise
% =========================================
SE4 = [0 1 0;
    1 1 1;
    0 1 0];
SE8 = [1 1 1;
    1 1 1;
    1 1 1];

% Open oct
imTmin = imerode(imTmin, SE4);
imTmin = imerode(imTmin, SE8);

imTmin = imdilate(imTmin, SE4);
imTmin = imdilate(imTmin, SE8);

% Close oct
imTmin = imdilate(imTmin, SE4);
imTmin = imdilate(imTmin, SE8);
imTmin = imdilate(imTmin, SE4);

imTmin = imerode(imTmin, SE4);
imTmin = imerode(imTmin, SE8);
imTmin = imerode(imTmin, SE4);

if showFigs
    subplot(4,2,5), imagesc(imTmin)
    axis image; colorbar
    title('Opened and closed image')
end

% Get the skeleton
% ================
imTminSkeleton = bwmorph(imTmin, 'skeleton', Inf);
if showFigs
    subplot(4,2,6), imagesc(imTminSkeleton)
    axis image; colorbar
    title('skeleton')
end

% Separate the image
% ==================
CC = bwconncomp(imTminSkeleton);
ImLabel = labelmatrix(CC);

% Compute region properties
stats = regionprops(ImLabel, 'Area');

% Define a minimum size threshold (adjust as needed)
minSize = max([stats.Area]);

% Initialize a binary mask to keep only the larger components
filteredBinaryImage = zeros(size(imTminSkeleton));

% Loop through the components and keep only those above the threshold
for i = 1:numel(stats)
    if stats(i).Area >= minSize
        filteredBinaryImage(ImLabel == i) = 1;
    end
end

filteredBinaryImagePruned = bwmorph(filteredBinaryImage, 'shrink', pruning_n);

if showFigs
    subplot(4,2,7); imagesc(filteredBinaryImage); 
    axis image; colorbar; title("separated image")
    subplot(4,2,8); imagesc(filteredBinaryImagePruned); 
    axis image; colorbar; title("separated pruned")
end

out = ocrdecide(filteredBinaryImagePruned, 8);



