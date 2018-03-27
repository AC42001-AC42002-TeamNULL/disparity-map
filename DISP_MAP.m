function [dmap_image] = DISP_MAP(left_image, right_image, support_window_size, search_region_size, is_gray, is_rectified)
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
padded_nonreference_image = padarray(right_image,[search_region_size,search_region_size], 'both');

dmap_image = uint8(zeros(R, C)); % Create empty/zeroed matrix of same size as input images
padded_dmap_image = padarray(dmap_image,[support_window_size,support_window_size], 'both');

% Compute our search and support size differences
search_support_diff = search_region_size - support_window_size;

% Iterate over the reference image by column into row
for r = (1+support_window_size):(R+support_window_size) % Row
    for c = (1+support_window_size):(C+support_window_size) % Column
        
        % ADD RECTIFICATION CHECK HERE FOR IS_ELONGATED
        
        % Define our support window as a segment of our reference image
        support_window = padded_reference_image(r:r, c:c+support_window_size-1);
        [H, W, ~] = size(support_window);
        % Define our search region as a segment of our non-reference image
        search_region = padded_nonreference_image(r+search_support_diff:r+search_support_diff, c+search_support_diff:c+search_support_diff+search_region_size-1);
        
        for i = 1:H
            for j = 1:W
                padded_dmap_image(r,c) = PIXEL_DISP(support_window(i,j), search_region);
            end
        end
    end
end
padded_dmap_image = padded_dmap_image(1+support_window_size:R+support_window_size, 1+support_window_size:C+support_window_size);
normalisedImage = uint8(255*mat2gray(padded_dmap_image));

imshow(normalisedImage);
dmap_image = 1;
end
