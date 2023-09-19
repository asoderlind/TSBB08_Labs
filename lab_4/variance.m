function variance = variance(histo, T, bound)
% variance for the lower part of the histogram

T = floor(T);

upper_bound = T + 1;
lower_bound = 1;

switch bound
  case "lower"
    values = (0:T);
  case "upper"
    upper_bound = max(size(histo));
    lower_bound = T + 2;
    values = (T+1:max(size(histo) - 1));
  otherwise
    error("bound must be either 'lower' or 'upper'");
end

p = histo / sum(histo);

% calulate the mean for the lower part of the histogram
mu = thresh_mean(histo, T, bound);

v_1 = sum(p(lower_bound:upper_bound) .* (values - mu).^2);
v_2 = sum(p(lower_bound:upper_bound));

variance = v_1 / v_2;

end