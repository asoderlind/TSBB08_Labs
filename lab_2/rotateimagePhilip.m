function RotateIm = rotateimage(Im, theta, intpol)

[rows, cols] = size(Im);
RotateIm = zeros(rows, cols);
cx = cols / 2;
cy = rows / 2; 

% Using homogenous coordinates
T_origin = [1 0 -cols/2; 0 1 -rows/2; 0 0 1];
R = [cos(theta), -sin(theta) 0; sin(theta), cos(theta), 0; 0, 0, 1];
T_back = [1 0 cx; 0 1 cy; 0 0 1];
S = T_back * R * T_origin;

for xg = 1:cols
    for yg = 1:rows
                xyff = inv(S) *  [xg; yg; 1];
                xff = xyff(1) / xyff(3);
                yff = xyff(2) / xyff(3);
        switch intpol
            case "nearest"
            % rotation code with nearest neighbour interpolation
                if ((xff <= cols && yff <= rows && xff >= 1 && yff >= 1))
                    xf = round(xff);
                    yf = round(yff);
                    RotateIm(yg, xg) = Im(yf, xf);
                end 
        
            case "bilinear"
            % rotation code with bilinear interpolation 
                 if ((xff <= cols && yff <= rows && xff >= 1 && yff >= 1))
                        xf = floor(xff);
                        yf = floor(yff);

                        xe = xff - xf;
                        ye = yff - yf;

                        A = Im(yf, xf) * triangle(xe) + Im(yf, xf + 1) * triangle(1-xe);
                        B = Im(yf + 1, xf) * triangle(xe) + Im(yf + 1, xf + 1) * triangle(1 - xe); 
                        
                        RotateIm(yg, xg) = A * triangle(ye) + B * triangle(1 - ye);
                end 

            
            case "bicubic4"
            % rotation code with bicubic4 interpolation 
                if ((xff <= cols && yff <= rows && xff >= 1 && yff >= 1))
                    xf = floor(xff);
                    yf = floor(yff);
        
                    xe = xff - xf;
                    ye = yff - yf;
        
                    A = Im(yf, xf) * bicubic4(xe) + Im(yf, xf + 1) * bicubic4(1-xe);
                    B = Im(yf + 1, xf) * bicubic4(xe) + Im(yf + 1, xf + 1) * bicubic4(1 - xe); 
                    
                    RotateIm(yg, xg) = A * h(ye) + B * h(1 - ye);
                end 
            case 'bicubic16'
                if (xff<cols-1 && yff<rows-1 && xff>2 && yff>2)
                  yf=floor(yff);
                  xf=floor(xff);
                     
                  dxf=xff-xf;
                  dxff=dxf+1;
                  dxc=1-dxf;
                  dxcc=1+dxc;
                     
                  dyf=yff-yf;
                  dyff=dyf+1;                    
                  dyc=1-dyf;                    
                  dycc=dyc+1;
                     
                  firstRow =  bicubic16(dxff)*bicubic16(dyff)*Im(yf-1,xf-1)+...
                  bicubic16(dxff)*bicubic16(dyf)* Im(yf,xf-1)+...
                  bicubic16(dxff)*bicubic16(dyc)* Im(yf+1,xf-1)+...
                  bicubic16(dxff)*bicubic16(dycc)*Im(yf+2,xf-1);
                
                  secondRow = bicubic16(dxf)*bicubic16(dyff)* Im(yf-1,xf)+...
                  bicubic16(dxf)*bicubic16(dyf)*  Im(yf,xf)+...
                  bicubic16(dxf)*bicubic16(dyc)*  Im(yf+1,xf)+...
                  bicubic16(dxf)*bicubic16(dycc)* Im(yf+2,xf);
                
                  thirdRow =  bicubic16(dxc)*bicubic16(dyff)* Im(yf-1,xf+1)+...
                  bicubic16(dxc)*bicubic16(dyf)*  Im(yf,xf+1)+...
                  bicubic16(dxc)*bicubic16(dyc)*  Im(yf+1,xf+1)+...
                  bicubic16(dxc)*bicubic16(dycc)* Im(yf+2,xf+1);
                
                  fourthRow = bicubic16(dxcc)*bicubic16(dyff)*Im(yf-1,xf+2)+...
                  bicubic16(dxcc)*bicubic16(dyf)* Im(yf,xf+2)+...
                  bicubic16(dxcc)*bicubic16(dyc)* Im(yf+1,xf+2)+...
                  bicubic16(dxcc)*bicubic16(dycc)*Im(yf+2,xf+2);
                
                  RotateIm(yg,xg) = firstRow+secondRow+thirdRow+fourthRow;
              elseif (xff<cols && yff<rows && xff>1 && yff>1)
                    xf = floor(xff);
                    yf = floor(yff);
        
                    xe = xff - xf;
                    ye = yff - yf;
        
                    A = Im(yf, xf) * bicubic4(xe) + Im(yf, xf + 1) * bicubic4(1-xe);
                    B = Im(yf + 1, xf) * bicubic4(xe) + Im(yf + 1, xf + 1) * bicubic4(1 - xe); 
                    
                    RotateIm(yg, xg) = A * bicubic4(ye) + B * bicubic4(1 - ye);
                end

        otherwise 
             error("Unknown interpolation method")
        end
    end
end
end