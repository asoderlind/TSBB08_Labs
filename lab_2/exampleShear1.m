Im = double(imread('logo.tif'));
T = [1 -1/3; 0 1];
figure(1); colormap gray;
tstart = tic()
shearIm = shearimage(Im,T);
elapsed = toc(tstart)
subplot(121); imagesc(Im); axis image; colorbar;
subplot(122); imagesc(shearIm); axis image; colorbar;
