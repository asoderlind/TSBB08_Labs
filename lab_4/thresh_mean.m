function mu = thresh_mean(histo, T, bound)

T = floor(T);

upper_bound = T + 1;
lower_bound = 1;

switch bound
  case "lower"
    values = (0:T);
  case "upper"
    upper_bound = max(size(histo));
    lower_bound = T + 2;
    values = (T+1:upper_bound - 1);
  otherwise
    error("bound must be either 'lower' or 'upper'");
end

p = histo / sum(histo);


% calulate the mean for the lower part of the histogram
mu_1 = sum(p(lower_bound:upper_bound).* values);
mu_2 = sum(p(lower_bound:upper_bound));

if mu_2 == 0
  error("cannot calculate mean for empty histogram");
end
mu = mu_1 / mu_2;
end