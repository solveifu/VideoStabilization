function [vector] = get_vector(T,m,n)
%GET_VECTOR Makes a vector of the numbers at (m,n) in each matrix.


TT = cell2mat(T);
vector =  TT(m:3:end,n);
end

