function rf = ACF_f(im)
m = mean(mean(im));
imNorm = im - m;

rf = corr(imNorm, imNorm);

end