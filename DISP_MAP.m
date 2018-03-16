function DISP_MAP(image_1, image_2, output_image, support_window_size)
%% Validate odd support window
if bitget(support_window_size, 1)
    support_window_size = floor(support_window_size/2);
else
    error('Error. support window size must be an odd number');
end
%% Read image files and convert to grayscale
image_1 = rgb2gray(imread(image_1));
image_2 = rgb2gray(imread(image_2));
%% Padding
image_2 = padarray(image_1, [support_window_size support_window_size], NaN, 'both');
%% Call PIXEL_DISP on each pixel
%for i = 1 + support_window_size:size(image_1, 1) - support_window_size
 %   for j = 1 + support_window_size:size(image_1, 2) - support_window_size  
 for i = 1:size(image_1, 1)
     for j = 1:size(image_1, 2)
            support_window = image_2(i - support_window_size: i + support_window_size, j - support_window_size: j + support_window_size);
            image_1(i,j) = PIXEL_DISP(image_1(i,j), support_window);
    end
end
%% Normalise
image_1;
normalisedImage = uint8(255*mat2gray(image_1));
%% Show image
figure
imshow(normalisedImage)
end

