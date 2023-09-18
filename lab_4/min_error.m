function outT = min_error(histo, startT)

num = length(histo);
p = histo / sum(histo);
t0 = floor(startT);
t1 = t0;
t0 = t1+2; % cannot be the same when entering the loop

% Calculate the threshold
%------------------------
while abs(t0-t1) > 0.5
    t0 = t1
    
    % Lower probability
    P0_1= sum(p(1:t0+1));
    P0_2 = sum(p(1:end));
    if P0_2 ~= 0
        P0 = P0_1/P0_2;
    else
        error('Cannot calculate threshold')
    end
    
    % Upper probability
    P1_1 = sum(p(t0+2:end));
    P1_2 = sum(p(1:end));
    if P1_2 ~= 0
        P1 = P1_1/P1_2;
    else
        error('Cannot calculate threshold')
    end
    
    % Lower mean
    mu0_1 = sum(p(1:t0+1).*((0:t0)));
    mu0_2 = sum(p(1:t0+1));
    if mu0_2 ~= 0
        mu0 = mu0_1/mu0_2;
    else
        error('Cannot calculate threshold')
    end
    
    % Upper mean
    mu1_1 = sum(p(t0+2:end).*((t0+1:num-1)));
    mu1_2 = sum(p(t0+2:end));
    if mu1_2 ~= 0
        mu1 = mu1_1/mu1_2;
    else
        error('Cannot calculate threshold')
    end
    
    % Lower variance
    variance0_1 = sum(p(1:t0+1).*((0:t0) - mu0).^2);
    variance0_2 = sum(p(1:t0+1));
    if variance0_2 ~= 0
        variance0 = variance0_1/variance0_2;
    else
        error('Cannot calculate threshold')
    end
    
    % Upper variance
    variance1_1 = sum(p(t0+2:end).*((t0+2:num) - mu1).^2);
    variance1_2 = sum(p(t0+2:end));
    if variance1_2 ~= 0
        variance1 = variance1_1/variance1_2;
    else
        error('Cannot calculate threshold')
    end
    
    c_0 = -2 * log(P0/P1) + log(variance0/variance1) + (mu0^2)/variance0 - (mu1^2)/variance1 % T^0
    c_1 = 2*( -(mu0/variance0) + (mu1/variance1)) % T^1
    c_2 = (variance1 - variance0)/(variance0 * variance1) % T^2
    
    r = roots([c_2 c_1 c_0]);
    
    if r(1) > mu0 && r(1) < mu1
        t1 = round(r(1));
    else
        t1 = round(r(2));
    end
end

outT = t1;