function [difference] = SUPPORT_CMP(matrix_1, matrix_2)
% Compute difference with SSD (Sum of squared differences) of two matrices
difference = sumsqr( matrix_1(:) - matrix_2(:) );
end
