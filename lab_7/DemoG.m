close all; clear;
% Make an image with a point
% ==========================
im = imread("polyg.tif");
%invect = [0:1:255];
%histo = hist(im(:), binvect);
T = 0.5;
cannyim = edge(im, "canny", [0.4 * T T]);
SE8 = ones(3, 3);
dilatedCannyIm = imdilate(cannyim, SE8);
figure;
subplot(2, 2, 1), imagesc(im);
axis image; axis xy; colorbar;
title("Image"),
% Call the Hough transform
% ========================
[H, T, R] = hough(dilatedCannyIm, "Theta", -90:89);
subplot(2, 2, 2), imagesc(T, R, H);
xlabel(" \ theta"), ylabel(" \ rho");
title("Hough transform"), colorbar;

% Detect peaks
% ============
P = houghpeaks(H, 4, "threshold", ceil(0.5 * max(H(:))));
x = T(P(:, 2)); y = R(P(:, 1));
hold on
plot(x, y, "s", "color", "red"), hold off
% Inverse Hough transform give Hough lines
% ========================================
lines = houghlines(dilatedCannyIm, T, R, P, "FillGap", 10, "MinLength", 35);
% Overlay Hough lines on image
% ============================
subplot(2, 2, 3), imagesc(im), hold on
title("Result"),
axis image; axis xy; colorbar;

for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:, 1), xy(:, 2), "LineWidth", 2, "Color", "green");
end

hold off
subplot(2, 2, 4), imagesc(dilatedCannyIm); axis image; axis xy; colorbar;
title("Canny edges");
