function [dmap_image] = DISP_MAP(left_image, right_image, support_window_size, search_scale, is_colour, is_rectified)
%% Confirm that support_window_size is odd value
if mod(support_window_size, 2) == 0
    error('Error. Support window must be odd value.');
end
%% Confirm that support_window_size and search scale are 0 divisable
if mod(support_window_size, search_scale) ~= 0
    error('Error. Support window and search scale are not divisable.');
end
%% Read image files
left_image = imread(left_image);
right_image = imread(right_image);
%% Confirm input images are the same size, else error
if size(left_image) ~= size(right_image)
    error('Error. Images must be the same shape.');
end
%% Convert to grayscale if colour images
if is_colour
    left_image = rgb2gray(left_image);
    right_image = rgb2gray(right_image);
end
%%
[R, C, ~] = size(left_image);

padded_reference_image = padarray(left_image,[support_window_size,support_window_size], 'both');
padded_nonreference_image = padarray(right_image,[support_window_size*search_scale,support_window_size*search_scale], 'both');

dmap_image = zeros(R, C); % Create empty/zeroed matrix of same size as input images
padded_dmap_image = padarray(dmap_image,[support_window_size,support_window_size], 'both');

search_support_diff = (support_window_size*search_scale) - support_window_size;

for r = (1+support_window_size)/2:R % Row
    for c = (1+support_window_size)/2:C % Column
        %% Get our support window for this current iteration
        support_x1 = r+1;
        support_x2 = r+support_window_size;
        support_y1 = c+1;
        support_y2 = c+support_window_size;
        
        support_window = padded_reference_image(support_x1:support_x2, support_y1:support_y2);
        %% Get our search window for this current iteration
        search_x1 = (r+1)+search_support_diff;
        search_x2 = (r+support_window_size)+search_support_diff;
        search_y1 = (c+1)+search_support_diff;
        search_y2 = (c+support_window_size*search_scale)+search_support_diff;
        
        search_window = padded_nonreference_image(search_x1:search_x2, search_y1:search_y2);
        
        [M, N, ~] = size(support_window);
        prev_col = 0;
        best_disp = -99999999;
        
        %% Iterate over our search window, using our support window for comparison and populate our dmap_image with disparity values
        for win = 1:search_scale
            %% Retrieve the inner_search_window as a sub-window of the search_window
            if win == 1
                inner_search_window = search_window(: , 1:support_window_size);
            else
                inner_search_window = search_window(: , 1+prev_col:win*support_window_size);
            end
            prev_col = prev_col + support_window_size;
            
            %% Compare the support window to the retrieved inner_search_window
            disp = SUPPORT_CMP(support_window, inner_search_window);
            %% Check if the current window disp is less than the previous window
            if disp > best_disp
                best_disp = disp;
            end
        end
        %% Insert the best disparity value into our zeroed dmap_image
        x1 = r+1*2;
        y1 = c+1*2;
        padded_dmap_image(x1,y1) = best_disp;
    end
end
normalisedImage = uint8(255*mat2gray(padded_dmap_image));
imshow(normalisedImage);
dmap_image = 1;
end
