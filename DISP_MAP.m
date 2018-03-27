function [dmap_image] = DISP_MAP(left_image, right_image, support_window_size, search_scale, is_gray, is_rectified)
%% Read image files and convert to grayscale
if is_gray
    left_image = imread(left_image);
    right_image = imread(right_image);
else
    left_image = rgb2gray(imread(left_image));
    right_image = rgb2gray(imread(right_image));
end
%% Iterate over left and right images, generating a disparity map from left to right with left as reference image
[R, C, ~] = size(left_image); % Assumes both images are the same size

% Pad our images with zeros to avoid out-of-bounds errors
padded_reference_image = padarray(left_image,[support_window_size,support_window_size], 'both');
padded_nonreference_image = padarray(right_image,[support_window_size*search_scale,support_window_size*search_scale], 'both');

dmap_image = zeros(R, C); % Create empty/zeroed matrix of same size as input images
padded_dmap_image = padarray(dmap_image,[support_window_size,support_window_size], 'both');

search_support_diff = (support_window_size*search_scale) - support_window_size;

% Iterate over the reference image by column into row
for r = (1+support_window_size):(R+support_window_size) % Row
    for c = (1+support_window_size):(C+support_window_size) % Column
        % ADD RECTIFICATION CHECK HERE FOR IS_ELONGATED
        
        % Define our support window as a segment of our reference image
        support_window = padded_reference_image(r:r+support_window_size-1, c:c+support_window_size-1);
        
        % Define our search window as a segment of our non-reference image
        x1 = r+search_support_diff;
        x2 = r+search_support_diff+support_window_size-1;
        y1 = c+search_support_diff;
        y2 = (c+search_support_diff*search_scale-1)-support_window_size;
        
        search_window = padded_nonreference_image(x1:x2, y1:y2);
        
        prev_search_col = 0;
        min_diff = -2147483648;
        
        %% Iterate over the search window and find the best matching window difference of the support window using a similiarity metric
        for win_scale = 1:search_scale
            if win_scale == 1
                inner_search_window = search_window(: , 1:prev_search_col+support_window_size);
            else
                inner_search_window = search_window(: , 1+prev_search_col:prev_search_col+support_window_size);
            end
            [~, psC, ~] = size(inner_search_window);
            prev_search_col = psC;
            
            diff = SUPPORT_CMP(support_window, inner_search_window);
            
            if diff > min_diff
                min_diff = diff;
            end
        end
        
        padded_dmap_image(r,c) = min_diff;
    end
end
padded_dmap_image(1+support_window_size:R+support_window_size, 1+support_window_size:C+support_window_size);
normalisedImage = uint8(255*mat2gray(padded_dmap_image));
imshow(normalisedImage);
dmap_image = 1;
end
