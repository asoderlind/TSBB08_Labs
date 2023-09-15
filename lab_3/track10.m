function [yout,xout] = track10(Im, y, x)
% This function tracks 10 pixels along a skeleton in image Im.
% It starts from the given end-point [y,x].
% It outputs the reached coordinates [yout,xout].

for k=1:10
  text = sprintf('y = %d, x = %d.', y, x); disp(text);
  ROI = Im(y-1:y+1,x-1:x+1); % grab ROI
  ROI(2,2) = 0;                % set current pos to 0
  if k>1
    ROI(4-ypos,4-xpos) = 0;    % set old pos to 0
  end
  [ypos,xpos] = find(ROI==1);  % look for the one
  y = y+ypos-2;                % update y-position
  x = x+xpos-2;                % update x-position
end

yout = y;
xout = x;
