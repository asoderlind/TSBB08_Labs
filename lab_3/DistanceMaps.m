Im = zeros(64,64);
Im(20,20) = 1;
Im(50,30) = 1;
Im(25,50) = 1;
Im_eq = bwdist(Im);
Im_chess = bwdist(Im,'chessboard');
Im_cityblock = bwdist(Im,'cityblock');
figure(1)
colormap(colorcube(51))
subplot(1,4,1), imagesc(Im);
axis image; title('Three points'); colorbar
subplot(1,4,2), imagesc(Im_eq, [0 50]);
axis image; title('Euclidian'); colorbar
subplot(1,4,3), imagesc(Im_chess, [0 50]);
axis image; title('chessboard'); colorbar
subplot(1,4,4), imagesc(Im_cityblock, [0 50]);
axis image; title('cityblock'); colorbar