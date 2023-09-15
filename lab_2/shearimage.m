function shearIm = shearimage(Im, T)
  
[rows, cols] = size(Im);
shearIm = zeros(rows, cols);
for xg = 1:cols	
  for yg = 1:rows
    c = [rows/2; cols/2]; % calculate the center coordinate
    offset = T*c - c; % calculate the resulting offset from center
    xyff = inv(T)*[xg;yg] + offset; % reverse mapping + offset 
    xff  = xyff(1);
    yff  = xyff(2);
    if (xff<=cols & yff<=rows & xff>=1 & yff>=1)
      xf = round(xff);
      yf = round(yff);	
      shearIm(yg,xg) = Im(yf,xf);	
    end
  end
end       
