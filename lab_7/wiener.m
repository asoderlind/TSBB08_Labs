function fhat = wiener(g,h,snr,rho,par)
% Wiener filter: fhat = wiener(g,h,snr,rho,par)
% g: input image 
% h: filter kernel
% snr: signal-to-noise ratio [dB]
% rho: normalized correlation between two consecutive pixels, interval: [0,1]
% par: adjustment value, interval: [0,1]
% fhat: wiener filter result
%
% Height and width of the input image must be equal.
% The size of the filter kernel h must be odd.

% Convert indata to double
% ========================
g = double(g); 
h = double(h);

% Check sizes
% ===========
[M,N] = size(g);
if M~=N
  error('Height and width of the input image must be equal.');
end
[Mh,Nh] = size(h);
if mod(Mh,2)== 0 | mod(Nh,2)== 0
  error('filter kernel must be odd')
end
Mh = (Mh-1)/2;
Nh = (Nh-1)/2;

% Sum of filter kernel coefficients
% =================================
hm = sum(sum(h));

% Put the filter kernel in the center of the image
% ================================================
h1 = zeros(M,N);
h1(M/2+1+[-Mh:Mh],N/2+1+[-Nh:Nh]) = h;

% Remove mean before Wiener filtering
% ===================================
gm = mean(mean(g));
g = g - gm;

% Fourier transform
% =================
G = fftshift(fft2(ifftshift(g)));
H = fftshift(fft2(ifftshift(h1)));

% Wiener filtering
% ================
[x,y] = meshgrid(-N/2:N/2-1,-N/2:N/2-1);

Sff = rho.^(sqrt(x.*x + y.*y));
Sff = abs(fftshift(fft2(ifftshift(Sff))));
  
Snn = 10^(-snr/10);

W = (conj(H).*Sff) ./ (abs(H).^2 .* Sff + par*Snn);

fhat = gm/hm + real(ifftshift(ifft2(fftshift(W.*G))));



