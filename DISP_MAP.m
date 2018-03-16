function DISP_MAP(image_1, image_2, output_image, support_window_size)
%% Read image files and convert to grayscale
image_1 = rgb2gray(imread(image_1));
image_2 = rgb2gray(imread(image_2));
%% Call PIXEL_DISP on each pixel
for i = 1:size(image_1, 1)
    for j = 1:size(image_1, 2)
        support_window = image_2(i - support_window_size: i + support_window_size, i - support_window_size: i + support_window_size);
        image_1(i,j) = PIXEL_DISP(image(i,j), support_window);
    end
end
%% Show image
figure
imshow(image_1)
end

