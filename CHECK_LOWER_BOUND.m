function [bound] = CHECK_LOWER_BOUND(input, maxsize)
if input > 0
    bound = input;
else
    bound = 1;
end
end

