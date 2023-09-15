function bicubic4 = bicubic4(x)

if abs(x) <= 1
    bicubic4 = 2*(abs(x)^3) - 3*(x^2) + 1;
else
    bicubic4 = 0;
end