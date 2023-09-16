ImC = imread('circles.tif');
CC = bwconncomp(ImC);
ImLabel = labelmatrix(CC);
figure(1)
colormap(jet(256))
subplot(2,2,1), imagesc(ImC);
axis image; title('Circles'); colorbar
subplot(2,2,2), imagesc(ImLabel);
axis image; title('Label image'); colorbar

ImBig = 0*ImLabel;
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
ImBig(CC.PixelIdxList{idx}) = 1;
subplot(2,2,4), imagesc(ImBig);
axis image; title('ImBig'); colorbar
