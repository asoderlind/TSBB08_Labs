function out = addnoise(g, SNR)
% Add noise function: out = addnoise(g, SNR)
% g: image 
% SNR: signal-to-noise ratio in dB 
% out: result
%
% Adds noise to the image g. 
% The resulting image will have signal-to-noise ratio SNR [dB].
  
n = randn(size(g));
sigma2n = std2(n)^2;
sigma2g = std2(g)^2;

n = sqrt((sigma2g/sigma2n)*10^(-SNR/10))*n; % adjust noise

out = g + n;
