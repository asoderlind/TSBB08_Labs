function out = ocrdecide(in, conn)
%
% Classifies objects in the image. 
% It is possible to classify digits between 0 and 9. 
% The classification is based on the number of holes and 
% the direction of the line ends of the digit.
%
% in: a binary skeleton image
% conn:	connectivity 4 or 8
% out: 
% If the classification fails, -1 is returned.
% If the classification is successful the number found is returned. 

if nargin ~= 2
   error('Funktionen ocrdecide kräver 2 argument in');
end;

[m,n] = size(in);
if (m ~= n)
   error('Bilden måste vara kvadratisk');
end;

if ~((conn == 4) | (conn == 8))
   error('Parametern conn ska vara 4 eller 8');
end;

if(conn == 8)
   ntemplates = 16;
else
   ntemplates = 12;
end;

% Zeropad and transpose image so that the same hit points 
% as in the old C routine are found.
z = zeros(m+2, n+2);
z(2:m+1, 2:n+1) = in';  

load('ocrdecide_lut');
lut = ocr_lut;

tmp = applylut(z,lut);
hits = find(tmp == -1);
z = z';  % Transpose image back to original direction

if isempty(hits)   % No end points, object must be 0 or 8
   eul = bweuler(z,conn);
   if eul == 0
      out = 0;
   elseif eul == -1
      out = 8;
   else
      out = -1;
   end;
else
   table = [3 3 -1 2 2 -1 7 7 9 ... 
         3 -1 4 -1 2 -1 1 3 9 ...
         -1 4 4 4 -1 1 1 1 6 ...
         5 5 4 4 -1 1 1 -1 6 ...
         5 5 -1 -1 -1 -1 -1 5 6 ...
         5 5 -1 -1 -1 -1 -1  5 -1 ...
         -1 -1 -1 -1 -1 -1 -1 -1 -1 ...
         3 3 -1 2 2 2 7 3 9 ...
         -1 -1 -1 -1 -1 -1 -1 -1 -1];
   
   for i=1:min(length(hits),2)
     % Swap row and column for hit points to compensate for
     % the transposed image used above.
     [hit_col, hit_row] = ind2sub(m+2,hits(i));
     row = hit_row;
     col = hit_col;
     for j=1:10
       z(row,col)=0;
       row = row - z(row-1,col);
       row = row + z(row+1,col);
       col = col - z(row,col-1);
       col = col + z(row,col+1);
       if conn == 8
         row = row - z(row-1,col-1);
         col = col - z(row-1,col-1);
         row = row - z(row-1,col+1);
         col = col + z(row-1,col+1);
         row = row + z(row+1,col-1);
         col = col - z(row+1,col-1);
         row = row + z(row+1,col+1);
         col = col + z(row+1,col+1);
       end;
     end;
     arg = atan2(hit_row-row,hit_col-col);
     entry(i) = mod(round(0.9999 * (arg + pi)/(pi/4)),8);
   end;
   if length(hits) == 1           %if only one point set the second entry to 8
     entry(2) = 8;
   end;
   out = table(9*entry(1)+entry(2)+1);   
end;
