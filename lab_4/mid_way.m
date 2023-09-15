function outT = mid_way(histo, startT)
% Calculates a threshold value from a histogram using the mid-way method. 
%
% histo: A 1D array histogram. 
% The histogram bins must correspond to gray value 0, 1, 2,...
% startT: start threshold
% outT: the calculated threshold (integer)
%
% Programmed by Maria Magnusson 2018-08

num = length(histo);
t0 = floor(startT);
t1 = t0+2;

% Calculate the threshold
%------------------------
while abs(t0-t1) > 0.5

  t0 = t1;
    
  % Calculate mean for the lower part of the histogram
  %---------------------------------------------------
  lowersum1 = sum(histo(1:t0+1).*[0:t0]);
  lowersum2 = sum(histo(1:t0+1));
  if lowersum2 ~= 0
    mean0 = lowersum1/lowersum2;
  else
    error('Cannot calculate new threshold');
  end;
    
  % Calculate mean for the upper part of the histogram
  %---------------------------------------------------
  uppersum1 = sum(histo(t0+2:num).*[t0+1:num-1]);
  uppersum2 = sum(histo(t0+2:num));
  if uppersum2 ~= 0
    mean1 = uppersum1/uppersum2;
  else
    error('Cannot calculate new threshold');
  end;

  % Calculate new threshold
  %------------------------
  t1 = floor((mean0+mean1)/2);

end;

outT = t1;
