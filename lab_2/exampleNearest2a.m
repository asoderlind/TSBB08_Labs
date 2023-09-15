Im = double(imread('logo.tif'));
theta = -pi/6;
figure(1); colormap gray;
rotIm = rotateimage(Im, theta, 'nearest');
subplot(131); imagesc(Im); axis image; colorbar;
subplot(132); imagesc(rotIm); axis image; colorbar;
subplot(133); imagesc(rotateimage(rotIm, -theta, 'nearest')); axis image; colorbar;

