function y = circconv(f,k)
% Circular convolution function: y = circconv(f,k)
% f: image 
% k: filter kernel
% y: circular convolution result
%
% The size of the filter kernel must be <= the image f.

% Convert indata to double
% ========================
f = double(f); 
k = double(k);

% Check sizes
% ===========
[M,N] = size(f);
[Mk,Nk] = size(k);  
if (Mk>M) | (Nk>N)
  error('filter kernel size must smaller or equal to image size')
end

% Put kernel in center of M*N image
% =================================
k1 = zeros(M,N);
k1(round(M/2+1+[-Mk/2:Mk/2-1]),round(N/2+1+[-Nk/2:Nk/2-1])) = k;
  
% Circular convoultion in the Fourier domain
% ==========================================
F = fftshift(fft2(ifftshift(f)));
K = fftshift(fft2(ifftshift(k1)));
y = real(ifftshift(ifft2(fftshift(F.*K))));

  
