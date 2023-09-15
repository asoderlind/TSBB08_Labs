function TrackIm = trackDist(Im, DistIm, starty, startx);
% This function performs tracking in the distance map DistIm
% towards lower values.
% Im is the original image with obstacles.
% starty is the starting position in y (row). 
% startx is the starting position in x (column). 
% The function returns an image with the tracking result.

y = starty;
x = startx;
val = DistIm(y,x);
TrackIm = double(Im);
iter = max(DistIm(:))+1;
k=0;
while val>0 & iter>0
  k=k+1;
  if k<=10
    text = sprintf('iter = %d: y = %d, x = %d, val = %d.', k, y, x, val);
    disp(text);
  end
  if k==10
    disp('I will only display the result of 10 iterations.');
  end
  val = DistIm(y,x);
  if (DistIm(y-1,x-1)<val) ypos=y-1; xpos=x-1; val=DistIm(y-1,x-1); end
  if (DistIm(y+1,x-1)<val) ypos=y+1; xpos=x-1; val=DistIm(y+1,x-1); end
  if (DistIm(y-1,x+1)<val) ypos=y-1; xpos=x+1; val=DistIm(y-1,x+1); end
  if (DistIm(y+1,x+1)<val) ypos=y+1; xpos=x+1; val=DistIm(y+1,x+1); end
  if (DistIm(y-1,x)<=val)  ypos=y-1; xpos=x;   val=DistIm(y-1,x); end
  if (DistIm(y+1,x)<=val)  ypos=y+1; xpos=x;   val=DistIm(y+1,x); end
  if (DistIm(y,x-1)<=val)  ypos=y;   xpos=x-1; val=DistIm(y,x-1); end
  if (DistIm(y,x+1)<=val)  ypos=y;   xpos=x+1; val=DistIm(y,x+1); end
  y = ypos; % update y-position
  x = xpos; % update x-position
  TrackIm(y,x) = 2;
end

if k == 1 disp('Failed to track, only one iteration'); end
if iter == 0 disp('Failed to track, too many iterations'); end

