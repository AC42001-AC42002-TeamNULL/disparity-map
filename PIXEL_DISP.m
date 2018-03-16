function [disp] = PIXEL_DISP(ref_pixel, ins_mat)

height = size(ins_mat, 1);
width = size(ins_mat, 2);

SMP_vals = zeros(size(ins_mat));

for i=1:height
    for j=1:width
        SMP_vals(i,j) = SUPPORT_CMP(ref_pixel, ins_mat(i,j));
    end
end

SMP_vals = reshape(SMP_vals, [1, height*width]);

disp = min(abs(SMP_vals));

end
