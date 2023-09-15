Im = zeros(64,64);
Im(20,20) = 1; Im(50,30) = 1; Im(25,50) = 1;
SE4 = [0 1 0;
    1 1 1;
    0 1 0];
SE8 = [1 1 1;
    1 1 1;
    1 1 1];
Im_d4 = imdilate(Im, SE4);
Im_d8 = imdilate(Im, SE8);
Im_d4_10 = Im;
Im_d8_10 = Im;
Im_doct = Im;
for i = 1:10
    Im_d4_10 = imdilate(Im_d4_10, SE4);
    Im_d8_10 = imdilate(Im_d8_10, SE8);
end
for i = 1:5
    Im_doct = imdilate(Im_doct, SE4);
    Im_doct = imdilate(Im_doct, SE8);
end
figure(1)
colormap(gray(256))
subplot(2,3,1), imagesc(Im);
axis image; title('Three points');
subplot(2,3,2), imagesc(Im_d4);
axis image; title('1 iter d4');
subplot(2,3,3), imagesc(Im_d8);
axis image; title('1 iter d8');
subplot(2,3,4), imagesc(Im_d4_10);
axis image; title('10 iter d4');
subplot(2,3,5), imagesc(Im_d8_10);
axis image; title('10 iter d8');
subplot(2,3,6), imagesc(Im_doct);
axis image; title('5 iter d4 + 5 iter d8');
