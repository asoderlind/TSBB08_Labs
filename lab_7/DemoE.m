% Make an image with a point
% ==========================
im = zeros(64, 64);
im(1, 1) = 1;
im(16, 16) = 1;
im(32, 32) = 1;
im(48, 48) = 1;
im(64, 64) = 1;
figure(1)
subplot(2, 2, 1), imagesc(im);
axis image; axis xy; colorbar;
title("Image"),
% Call the Hough transform
% ========================
[H, T, R] = hough(im, "Theta", -90:89);
subplot(2, 2, 2), imagesc(T, R, H);
xlabel(" \ theta"), ylabel(" \ rho");
title("Hough transform"), colorbar;

% Detect peaks
% ============
P = houghpeaks(H, 10, "threshold", ceil(0.5 * max(H(:))));
x = T(P(:, 2)); y = R(P(:, 1));
hold on
plot(x, y, "s", "color", "red"), hold off
% Inverse Hough transform give Hough lines
% ========================================
lines = houghlines(ones(size(im)), T, R, P);
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
