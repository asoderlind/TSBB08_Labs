function P0_out = P(histo, T, bound)
%calculate P0 for the min-error method

T = floor(T);

upper_bound = T + 1;
lower_bound = 1;

switch bound
  case "lower"
  case "upper"
    upper_bound = max(size(histo));
    lower_bound = T + 2;
  otherwise
    error("bound must be either 'lower' or 'upper'")
end

p = histo/sum(histo); % prob that a pixel has a certain value

lowersum0 = sum(p(lower_bound:upper_bound));
lowersum1 = sum(p);

if lowersum1 == 0
  error('Cannot calculate new threshold');
end

P0_out = lowersum0/lowersum1;

end