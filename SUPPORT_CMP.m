function [difference] = SUPPORT_CMP(image1, image2, window_size)
%SUPPORT_CMP Summary of this function goes here
%   Detailed explanation goes here

image1 = imread(image1);
image2 = imread(image2);

image_1_window = (image1(1:window_size, 1:window_size));
image_2_window = (image2(1:window_size, 1:window_size));

% Compute difference with SSD (Sum of squared differences)
difference = sumsqr( image_1_window(:) - image_2_window(:) );

end
