function out = demoC(inputIm,pruning_n,sigma,showFigs)
% Read the image and cast it to double
% ====================================
nuf = double(imread(inputIm));

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
    figure(1)
    colormap(gray(256))
    
    subplot(2,2,1),
    imagesc(nufextend, [0 255])
    axis image; colorbar
    title('extended image')
    
    subplot(2,2,2), imagesc(nufblur, [0 255])
    axis image; colorbar
    title('blurred image image')
    
    subplot(2,2,3), imagesc(nuf, [0 255])
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
    subplot(2,2,4), imagesc(imTmin)
    axis image; colorbar
    title('thresholded image (Tmin)')
    
    figure(2)
    colormap(gray(256))
end

% Open the image to remove noise
% =========================================
SE4 = [0 1 0;
    1 1 1;
    0 1 0];
SE8 = [1 1 1;
    1 1 1;
    1 1 1];

imTmin = imerode(imTmin, SE4);
imTmin = imerode(imTmin, SE8);

imTmin = imdilate(imTmin, SE4);
imTmin = imdilate(imTmin, SE8);

imTmin = imdilate(imTmin, SE4);
imTmin = imdilate(imTmin, SE8);

imTmin = imerode(imTmin, SE4);
imTmin = imerode(imTmin, SE8);

if showFigs
    subplot(2,2,1), imagesc(imTmin)
    axis image; colorbar
    title('Opened and closed image')
end

% Get the skeleton
% ================
imTminSkeleton = bwmorph(imTmin, 'skeleton', Inf);
if showFigs
    subplot(2,2,2), imagesc(imTminSkeleton)
    axis image; colorbar
    title('skeleton')
end

imTminPruned = bwmorph(imTminSkeleton, 'shrink', pruning_n);
if showFigs
    subplot(2,2,3), imagesc(imTminPruned)
    axis image; colorbar
    title('post-prune')
end

imTminClean = bwmorph(imTminPruned, 'clean');
if showFigs
    subplot(2,2,4), imagesc(imTminClean)
    axis image; colorbar
    title('post-clean')
end

out = ocrdecide(imTminClean, 8);


