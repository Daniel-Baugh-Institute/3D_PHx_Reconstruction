%% Justin Melunis, PhD
% Thomas Jefferson University

function [m_out] = shift_matrix(m_in)
%This function shifts a matrix (m_in) from values to a matrix into an
%ordered matrix in which each value of the output matrix corresponds to the 
%ordered position of the value of the input matrix, values of 0 stay 0
%ex1 [7 4 1 3] -> [4 3 1 2]
%ex2 [0.52 4 0 1.2 4] -> [1 3 0 2 3]
m_out = im2uint16(zeros(size(m_in)));
u = unique(m_in(:));
u(u==0) = [];
for i = 1:numel(u)
    m_out(m_in == u(i)) = i;
end

