Im = double(imread('baboon.tif'));

% circular mask
[Ny, Nx] = size(Im);
N = min(min(Nx,Ny));
[x,y] = meshgrid(-ceil((Nx-1)/2):floor((Nx-1)/2), ...
 -ceil((Ny-1)/2):floor((Ny-1)/2));
mask = (x.^2 + y.^2)<((N-1)/2)^2;
Im = Im.* mask;

figure(1); colormap gray;

% Initialize error variables
errNearest = 0;
errBilinear = 0;
errBicubic = 0;

rotImNearest = rotateimage(Im, -pi/(6.1), 'nearest');
rotImBilinear = rotateimage(Im, -pi/(6.1), 'bilinear');
rotImBicubic = rotateimage(Im, -pi/(6.1), 'bicubic16');

% Loop 11 times
for i = 1:11
    % nearest neighbor
    rotImNearest = rotateimage(rotImNearest, pi/(6.1), 'nearest');

    % bilinear
    rotImBilinear = rotateimage(rotImBilinear, pi/(6.1), 'bilinear');

    % bicubic16
    rotImBicubic = rotateimage(rotImBicubic, pi/(6.1), 'bicubic16');
end

subplot(221); imagesc(Im); title('im'), axis image; colorbar;
subplot(222); imagesc(rotImNearest); title('nImNearest'); axis image; colorbar;
subplot(223); imagesc(rotImBilinear); title('nImBilinear'); axis image; colorbar;
subplot(224); imagesc(rotImBicubic); title('nImBicubic'); axis image; colorbar;
