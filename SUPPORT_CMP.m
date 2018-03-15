function [difference] = SUPPORT_CMP(image1, image2, window_size)
%SUPPORT_CMP Summary of this function goes here
%   Detailed explanation goes here

image1 = imread(image1);
image2 = imread(image2);

window = [1:window_size, 1:window_size];

image_1_window = (image1(1:window_size, 1:window_size));
image_2_window = (image2(1:window_size, 1:window_size));

difference = sum((image_1_window(:) - image_2_window(:)).^2 );

end

