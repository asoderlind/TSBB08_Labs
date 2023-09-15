ImC = imread('circles.tif');
SE4 = [0 1 0;
    1 1 1;
    0 1 0];
SE8 = [1 1 1;
    1 1 1;
    1 1 1];
ImE = ImC;
for k=1:4
    ImE = imerode(ImE, SE4);
    ImE = imerode(ImE, SE8);
end
ImS = bwmorph(ImC,'shrink',4);
figure(1)
colormap(gray(256))
subplot(2,3,1), imagesc(ImC);
axis image; title('Circles');
subplot(2,3,2), imagesc(ImE);
axis image; title('ImE');
subplot(2,3,3), imagesc(ImS);
axis image; title('ImS');

ImC_filled = imfill(ImC,'holes');

ImC_filled_shrunk = bwmorph(ImC_filled,'shrink',Inf);

ImC_filled_eroded = ImC_filled;
for k=1:4
    ImC_filled_eroded = imerode(ImC_filled_eroded,SE4);
    ImC_filled_eroded = imerode(ImC_filled_eroded,SE8);
end
ImC_filled_eroded_shrunk = bwmorph(ImC_filled_eroded,'shrink',Inf);

num_circles_filled_shrunk = sum(ImC_filled_shrunk(:));
disp(['Number of circles (filled shrunk) = ' num2str(num_circles_filled_shrunk)]);

num_circles_filled_eroded_shrunk = sum(ImC_filled_eroded_shrunk(:));
disp(['Number of circles (filled eroded shrunk) = ' num2str(num_circles_filled_eroded_shrunk)]);

subplot(2,3,4), imagesc(ImC_filled);
axis image; title('ImC filled');
subplot(2,3,5), imagesc(ImC_filled_shrunk);
axis image; title('ImC filled-shrunk');
subplot(2,3,6), imagesc(ImC_filled_eroded_shrunk);
axis image; title('ImC filled-eroded-shrunk');

