function [bound] = CHECK_UPPER_BOUND(input, max)
if input <= max
    
    bound = input;
else
    bound = max;
end
end

