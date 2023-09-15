Im = double(imread('logo.tif'));

% circular mask
[Ny, Nx] = size(Im);
N = min(min(Nx,Ny));
[x,y] = meshgrid(-ceil((Nx-1)/2):floor((Nx-1)/2), ...
    -ceil((Ny-1)/2):floor((Ny-1)/2));
mask = (x.^2 + y.^2)<((N-1)/2)^2;
Im = Im.* mask;

figure(1); colormap gray;

% spatial domain
rotIm = rotateimage(Im, -pi/6, 'bilinear');
nIm = rotateimage(rotIm, pi/6, 'bilinear');

err = sum(sum((nIm-Im).*(nIm-Im)))

% Fourier
IM = fftshift(fft2(ifftshift(Im)));
IMLOG = log10(1 + abs(IM));

NIM = fftshift(fft2(ifftshift(nIm)));
NIMLOG = log10(1 + abs(NIM));

subplot(231); imagesc(Im); title('im'), axis image; colorbar;
subplot(232); imagesc(rotIm); title('rotIm)'); axis image; colorbar;
subplot(233); imagesc(nIm); title('nIm'); axis image; colorbar;
subplot(234); imagesc(Im - nIm); title('Im - nIm'); axis image; colorbar;
subplot(235); imagesc(IMLOG); title('IMLOG'); axis image; colorbar;
subplot(236); imagesc(NIMLOG); title('NIMLOG'); axis image; colorbar;

DIFFREL = abs(IM - NIM)./abs(IM);
figure(2); colormap gray;
imagesc(DIFFREL, [0 2]); title('Relative err bilinear'); axis image; colorbar;



