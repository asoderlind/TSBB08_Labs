close all; clc; clear;

files = ["nuf0a.tif", ...
    "nuf0b.tif", ...
    "nuf2a.tif", ...
    "nuf2b.tif", ...
    "nuf2c.tif", ...
    "nuf4a.tif", ...
    "nuf4b.tif", ...
    "nuf5.tif", ...
    "nuf6.tif", ...
    "nuf8a.tif", ...
    "nuf8b.tif", ...
    "nuf9.tif"];

A = 1.6;
b = 50;
pruning_n = 5;
sigma = 21;
sum = 0;

for i = 1:length(files)
    numericPart = str2double(regexp(files(i), '\d+', 'match'));

    % Print the figures for 2b
    if i == 1
        res = demoC(files(i), A, b, pruning_n, sigma, true);
    else 
        res = demoC(files(i), A, b, pruning_n, sigma, false);
    end

    % Check against expected val
    if  res == numericPart
        disp(files(i) + ' O')
        sum = sum + 1;
    else
        disp(files(i) + ' X')
    end
end
disp("Sum is " + sum)