function outT = min_error(histo, startT)

normalized_histo = histo / sum(histo);

T = startT;

w0 = sum(normalized_histo(1:T)); % sum bg intensity
w1 = sum(normalized_histo(T+1:end)); % sum object intensity

mu0 = sum(normalized_histo(1:T) .* (1:T)) / w0; % mean bg intensity
mu1 = sum(normalized_histo(T+1:end) .* (T+1:256)) / w1; % mean object intensity


outT = startT;