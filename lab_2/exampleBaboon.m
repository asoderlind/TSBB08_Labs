Im = double(imread('baboon.tif'));

% circular mask
[Ny, Nx] = size(Im);
N = min(min(Nx,Ny));
[x,y] = meshgrid(-ceil((Nx-1)/2):floor((Nx-1)/2), ...
 -ceil((Ny-1)/2):floor((Ny-1)/2));
mask = (x.^2 + y.^2)<((N-1)/2)^2;
Im = Im.* mask;

figure(1); colormap gray;

% nearest neighbor
rotImNearest = rotateimage(Im, -pi/(6.1), 'nearest');
nImNearest = rotateimage(rotImNearest, pi/(6.1), 'nearest');
errNearest = sum(sum((nImNearest-Im).*(nImNearest-Im)))

% bilinear
rotImBilinear = rotateimage(Im, -pi/(6.1), 'bilinear');
nImBilinear = rotateimage(rotImBilinear, pi/(6.1), 'bilinear');
errBilinear = sum(sum((nImBilinear-Im).*(nImBilinear-Im)))

% bicubic16
rotImBicubic = rotateimage(Im, -pi/(6.1), 'bicubic16');
nImBicubic = rotateimage(rotImBicubic, pi/(6.1), 'bicubic16');
errBicubic = sum(sum((nImBicubic-Im).*(nImBicubic-Im)))

subplot(221); imagesc(Im); title('im'), axis image; colorbar;
subplot(222); imagesc(nImNearest); title('nImNearest'); axis image; colorbar;
subplot(223); imagesc(nImBilinear); title('nImBilinear'); axis image; colorbar;
subplot(224); imagesc(nImBicubic); title('nImBicubic'); axis image; colorbar;
