function [ssd] = SSD(matrix_1, matrix_2)
% Compute difference with SSD (Sum of squared differences) of two matrices
ssd = 0 - sumsqr( matrix_1(:) - matrix_2(:) );
end