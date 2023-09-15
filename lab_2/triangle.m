function triangle = triangle(x)

if abs(x) <= 1
    triangle = 1 - abs(x);
else
    triangle = 0;
end