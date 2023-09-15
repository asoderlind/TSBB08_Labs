Im = double(imread('logo.tif'));

% circular mask
[Ny, Nx] = size(Im);
N = min(min(Nx,Ny));
[x,y] = meshgrid(-ceil((Nx-1)/2):floor((Nx-1)/2), ...
    -ceil((Ny-1)/2):floor((Ny-1)/2));
mask = (x.^2 + y.^2)<((N-1)/2)^2;
Im = Im.* mask;

% rotated and normalized
figure(1); colormap gray;
rotIm = rotateimage(Im, -pi/6, 'nearest');
nIm = rotateimage(rotIm, pi/6, 'nearest');

% Error energy in spatial domain
err = sum(sum((nIm-Im).*(nIm-Im)))

% Fourier
IM = fftshift(fft2(ifftshift(Im)));
IMLOG = log10(1 + abs(IM));

ROTIM = fftshift(fft2(ifftshift(rotIm)));
ROTIMLOG = log10(1 + abs(ROTIM));

NIM = fftshift(fft2(ifftshift(nIm)));
NIMLOG = log10(1 + abs(NIM));

DIFF = log10(1 + abs(IM - NIM));
DIFFREL = abs(IM - NIM)./abs(IM);

% Error energy in Fourier domain
N = size(IM);
sum(sum((IM-NIM).*conj(IM-NIM)))/(N(1)*N(2))

subplot(231); imagesc(Im); axis image; title('original'); colorbar;
subplot(232); imagesc(rotIm); axis image; title('rotated'); colorbar;
subplot(233); imagesc(nIm); axis image; title('normalized'); colorbar;
subplot(234); imagesc(IMLOG); axis image; title('F(original)'); colorbar;
subplot(235); imagesc(ROTIMLOG); axis image; title('F(rotated)'); colorbar;
subplot(236); imagesc(NIMLOG); axis image; title('F(normalized)'); colorbar;

figure(2); colormap gray;
subplot(221); imagesc(Im - nIm); title('spatial error'); axis image; colorbar;
subplot(222); imagesc(DIFF); title('Fourier diff'); axis image; colorbar;
subplot(223); imagesc(DIFFREL, [0 2]); title('Relative err nearest'); axis image; colorbar;


