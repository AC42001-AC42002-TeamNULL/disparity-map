comparison_map = imread('pentagon_dispmap.bmp');
parfor search_size = 3 : 51
    for support_size = 3 : 51
        if bitget(search_size, 1) && bitget(support_size, 1) && search_size >= support_size
            our_disparity_map = DISP_MAP('./images/pentagon_left.bmp', './images/pentagon_right.bmp', search_size, support_size, true);
            similarity = ssim(our_disparity_map, comparison_map);
            disp([search_size support_size similarity])
        end
    end
end