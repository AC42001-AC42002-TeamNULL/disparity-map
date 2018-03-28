function [normalisedImage] = DISP_MAP(left_image_dir, right_image_dir, search_region_size, support_window_size, is_grey)
%DISP_MAP Calculate disparity map of two images
%   Calculates the disparity of the left image from the right image
%% Validate sizes
for i = 1:2
    if bitget(support_window_size(i), 1) && bitget(search_region_size(i), 1)
        search_region_size(i) = floor(search_region_size(i)/2);
        support_window_size(i) = floor(support_window_size(i)/2);
    elseif support_window_size(i) > search_region_size(i)
        error('Error. Search window must be larger than support window.');
    else
        error('Error. Support window size must be an odd number.');
    end
end
%% Read image files and convert to grayscale
if is_grey
    left_image = imread(left_image_dir);
    right_image = imread(right_image_dir);
else
    left_image = rgb2gray(imread(left_image_dir));
    right_image = rgb2gray(imread(right_image_dir));
end
%% Perform comparison
for column = 1 : size(left_image, 1)
    for row = 1 : size(left_image, 2)
        distance = 0;
        calcdist = 0;
        %% Build search region
        
        right_search_region = right_image( ... 
            CHECK_LOWER_BOUND(column - search_region_size(1)) : CHECK_UPPER_BOUND(column + search_region_size(1), size(right_image, 1)), ...
            CHECK_LOWER_BOUND(row - search_region_size(2)) : CHECK_UPPER_BOUND(row + search_region_size(2), size(right_image, 2)));
        %% Build left pixel window
        left_support_window = left_image( ...
            CHECK_LOWER_BOUND(column - support_window_size(1)) : CHECK_UPPER_BOUND(column + support_window_size(1), size(left_image, 1)), ...
            CHECK_LOWER_BOUND(row - support_window_size(2)) : CHECK_UPPER_BOUND(row + support_window_size(2), size(left_image, 2)));
        %right_support_window_size_column = floor(size(left_support_window, 1)/2);
        %right_support_window_size_row = floor(size(left_support_window, 2)/2);
        %% Check each right support window in search region
        
        for search_region_column = 1 : size(right_search_region, 1) - size(left_support_window, 1)
            for search_region_row = 1 : size(right_search_region, 2) - size(left_support_window, 2)
                %% Build right pixel window
                  %{  
                    right_support_window = right_search_region( ...
                    CHECK_LOWER_BOUND(search_region_column - support_window_size) : CHECK_UPPER_BOUND(search_region_column + support_window_size, size(right_search_region, 1)), ...
                    CHECK_LOWER_BOUND(search_region_row - support_window_size) : CHECK_UPPER_BOUND(search_region_row + support_window_size, size(right_search_region, 2)))
                %}
                right_support_window = right_search_region(search_region_column : search_region_column + size(left_support_window, 1) - 1, ...
                    search_region_row : search_region_row + size(left_support_window, 2) - 1);
                %% Calcuate distance
                X = im2double(right_support_window) - im2double(left_support_window);
                calculation = sum(X(:).^2);
                if calculation > distance
                    distance = calculation;
                    %calcdist = sqrt((column + search_region_column)^2)
                    %calcdist = sqrt(((search_region_column + size(left_support_window, 1)/2 - 1) - column)^2 + ...
                    %    ((search_region_row + size(left_support_window, 2)/2 - 1) - row)^2); 
                end
            end
        end
        if distance > 0.5
            output(column, row) = distance;
        else
            output(column, row) = distance / 2;
        end
    end
end
%{
%% Padding

left_image = padarray(left_image, [support_window_size support_window_size], NaN, 'both');
%% Call PIXEL_DISP on each pixel
%for i = 1 + support_window_size:size(image_1, 1) - support_window_size
 %   for j = 1 + support_window_size:size(image_1, 2) - support_window_size  
 for i = 1:size(image_1, 1)
     for j = 1:size(image_1, 2)
         if i - support_window_size > 0 && i + support_window_size < size(image_1, 1) && j - support_window_size > 0 && j + support_window_size > size(image_1, 2)
            corr_window = image_1(i - support_window_size: i + support_window_size, j - support_window_size: j + support_window_size);
            support_window = image_2(i - support_window_size: i + support_window_size, j - support_window_size: j + support_window_size);
            image_1(i,j) = PIXEL_DISP(corr_window, support_window);
         end
    end
end
%}
%% Normalise
output
normalisedImage = uint8(255*mat2gray(output));
normalisedImage = uint8(255) - normalisedImage;

%% Show image
figure
imshow(normalisedImage);
end

