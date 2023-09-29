function y = corrc(f,p)
% Normalized correlation without DC component (correlation coefficient):
% y = corrc(f,p)
% f: image 
% p: pattern
% y: correlation result
%
% The size of the pattern p must be even.
% The size of the pattern p must be <= the image f.

% Convert indata to double
% ========================
f = double(f); 
p = double(p);

% Check sizes
% ===========
[M,N] = size(f);
[Mp,Np] = size(p);
if mod(Mp,2)== 1 | mod(Np,2)== 1
  error('pattern size must be even')
end
if (Mp>M) | (Np>N)
  error('pattern size must smaller or equal to image size')
end

% Remove the DC-level from the pattern
% ====================================
p = p - mean(mean(p));

% Zero-pad pattern and ones-area
% ==============================
rvec = M/2+1+[-Mp/2:Mp/2-1];
cvec = N/2+1+[-Np/2:Np/2-1];
p1 = zeros(M,N);
p1(rvec,cvec) = p;
e = ones(size(p));
e1 = zeros(M,N);
e1(rvec,cvec) = e;

% Calculation of the patterns norm
% ================================
pnorm = sqrt(sum(sum(p.^2)));

% Calculation of mean in the image
% ================================
E = fftshift(fft2(ifftshift(e1)));
F = fftshift(fft2(ifftshift(f)));
fmean = real(ifftshift(ifft2(fftshift(F.*conj(E))))) / sum(e(:));
f = f - fmean; % Lokal DC-level removed

% Correlation in the Fourier domain
% =================================
F = fftshift(fft2(ifftshift(f)));
P = fftshift(fft2(ifftshift(p1)));
y = real(ifftshift(ifft2(fftshift(F.*conj(P)))));

% Calculation of the image norm
% =============================
F2 = fftshift(fft2(ifftshift(f.^2)));
sqf2norm = sqrt(real(ifftshift(ifft2(fftshift(F2.*conj(E))))));

% Normalize
% =========
y = (y./sqf2norm)/pnorm;



