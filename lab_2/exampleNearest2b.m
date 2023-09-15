Im = double(imread('logo.tif'));

% circular mask
[Ny, Nx] = size(Im);
N = min(min(Nx,Ny));
[x,y] = meshgrid(-ceil((Nx-1)/2):floor((Nx-1)/2), ...
 -ceil((Ny-1)/2):floor((Ny-1)/2));
mask = (x.^2 + y.^2)<((N-1)/2)^2;
Im = Im.* mask;

figure(1); colormap gray;
rotIm = rotateimage(Im, -pi/6, 'nearest');
nIm = rotateimage(rotIm, pi/6, 'nearest');

sum(sum((nIm-Im).*(nIm-Im)))

subplot(221); imagesc(Im); axis image; colorbar;
subplot(222); imagesc(rotIm); axis image; colorbar;
subplot(223); imagesc(nIm); axis image; colorbar;
subplot(224); imagesc(nIm-Im); axis image; axis off; colorbar;
