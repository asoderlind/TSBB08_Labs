function [outIm] = hysteresis(a, b, c, show_growing)
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    while true
        e = b;
        d = imdilate(b, ones(3)); %SE8
        b = d .* c;
        if show_growing
            pause(0.2);
            colormap(gray(256))
            figure(1); imagesc(b, [0 1]);
            axis image; title('image b');
        end
        if isequal(e, b)
            break
        end

    end

    outIm = b;
end
