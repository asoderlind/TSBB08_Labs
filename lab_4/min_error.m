function outT = min_error(histo, startT)

T = startT;

t0 = T;
t1 = t0;
t0 = t1 + 2; % so that we can enter the while loop

while abs(t0 - t1) > 0.5
  t0 = t1;
  % calculate lower and upper means
  mu0 = thresh_mean(histo, t0, "lower");
  mu1 = thresh_mean(histo, t0, "upper");
  
  % calculate lower and upper probalities
  P0 = P(histo, t0, "lower");
  P1 = P(histo, t0, "upper");
  
  % calculate lower and upper variances
  v0 = variance(histo, t0, "lower");
  v1 = variance(histo, t0, "upper");
  
  c2 = ((v1 - v0) / (v1 * v0));
  c1 = 2 * ( (mu1 / v1) - (mu0 / v0));
  c0 = -2 * log( (P0 / P1) ) + log((v0 / v1 )) + (mu0^2 / v0) - (mu1^2 / v1);
  
  r = roots([c2 c1 c0]);
  
  
  if r(1) > mu0 && r(1) < mu1
    t1 = round(r(1));
  else
    t1 = round(r(2));
  end
end
outT = t1;
end