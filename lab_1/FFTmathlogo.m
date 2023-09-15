load math_logo
im = math_logo;
IM = fftshift(fft2(ifftshift(im)));
maxIM = max(max(abs(IM)));
shiftim = circshift(circshift(im,5,2),10,1);
figure(1); colormap gray;
subplot(121); imagesc(im);
axis image; title('im')
colorbar('SouthOutside')
subplot(122); imagesc(shiftim);
axis image; title('shifted im')
colorbar('SouthOutside')
figure(2); colormap gray;
subplot(221); imagesc(abs(IM), [0 0.02*maxIM]);
axis image; colorbar; title('abs(F[im])')
subplot(222); imagesc(angle(IM), [-pi pi]);
axis image; colorbar; title('angle(F[im])')
subplot(223); imagesc(real(IM), [-0.02*maxIM 0.02*maxIM]);
axis image; colorbar; title('real(F[im])')
subplot(224); imagesc(imag(IM), [-0.02*maxIM 0.02*maxIM]);
axis image; colorbar; title('imag(F[im])')