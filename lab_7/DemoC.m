imSkylt = double(imread('skylt.tif')); % load image skylt
imBaboon = double(imread('baboon256.tif')); % load image baboon
imFoppa = double(imread('foppa.tif')); % load image foppa

% ACF signal
rf_skylt = ACF_f(imSkylt);
rf_baboon = ACF_f(imBaboon);
rf_foppa = ACF_f(imFoppa);

% SURFACE PLOTS X Y
[X_skylt, Y_skylt] = meshgrid(1:size(rf_skylt, 2), 1:size(rf_skylt, 1)); % Create X and Y coordinates
[X_baboon, Y_baboon] = meshgrid(1:size(rf_baboon, 2), 1:size(rf_baboon, 1)); % Create X and Y coordinates
[X_foppa, Y_foppa] = meshgrid(1:size(rf_foppa, 2), 1:size(rf_foppa, 1)); % Create X and Y coordinates

% p ESTIMATES
px_skylt = rf_skylt(66, 65) / rf_skylt(65, 65);
py_skylt = rf_skylt(65, 66) / rf_skylt(65, 65);
p_skylt = (px_skylt + py_skylt) / 2

px_baboon = rf_baboon(130, 129) / rf_baboon(129, 129);
py_baboon = rf_baboon(129, 130) / rf_baboon(129, 129);
p_baboon = (px_baboon + py_baboon) / 2

px_foppa = rf_foppa(66, 65) / rf_foppa(65, 65);
py_foppa = rf_foppa(65, 66) / rf_foppa(65, 65);
p_foppa = (px_foppa + py_foppa) / 2

% PLOTS
figure;
subplot(1, 3, 1), surf(X_skylt, Y_skylt, rf_skylt);
title("rf skylt")
subplot(1, 3, 2), surf(X_baboon, Y_baboon, rf_baboon);
title("rf baboon");
subplot(1, 3, 3), surf(X_foppa, Y_foppa, rf_foppa);
title("rf foppa")

figure; colormap(jet);
subplot(1, 3, 1), imagesc(rf_skylt); axis("image");
title("rf skylt")
subplot(1, 3, 2), imagesc(rf_baboon); axis("image");
title("rf baboon")
subplot(1, 3, 3), imagesc(rf_foppa); axis("image");
title("rf foppa")
