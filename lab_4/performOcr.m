clc; clear; close all;
files = ["nuf0a.tif", "nuf0b.tif", "nuf2a.tif", "nuf2b.tif", "nuf2c.tif", "nuf4a.tif", "nuf4b.tif", "nuf5.tif", "nuf6.tif", "nuf8a.tif", "nuf8b.tif", "nuf9.tif"];

sum = 0;
for i = 1:length(files)
  numericPart = str2double(regexp(files(i), '\d+', 'match'));
  ocrOut = ocr(files(i), 20, 5);
  if ocrOut == numericPart
    %disp(files(i) + " O")
    sum = sum + 1;
  else
    disp(files(i) + " X")
    disp("numeric part is: " + numericPart);
    disp("ocr output is: " + ocrOut);
  end
end
disp("Sum is: " + sum);