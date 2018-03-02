%% load images
leftImage = imread('./testL.jpg');
rightImage = imread('./testR.jpg');
%% show stereo anaglyph
figure
imshow(stereoAnaglyph(leftImage, rightImage));
%% compute disparity map
disparityRange = [-6 10];
disparityMap = disparity(rgb2gray(leftImage), rgb2gray(rightImage), 'BlockSize', 15, 'DisparityRange', disparityRange); 
figure
imshow(disparityMap, disparityRange);
title('Disparity Map');
colormap(gca, jet)
colorbar