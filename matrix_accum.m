function [T_acc] = matrix_accum(T)
    %MATRIX_ACCUM Computes the accumulative transforms with respect to T{1}
    %   Returns a cell array of matrices where T_acc{n} equals
    %T{n}*T{1-1}*...*T{1}

    T_acc = cell(length(T),1);
    T_acc{1} = T{1};

    for i=2:length(T)
        T_acc{i} = T{i};
        for j=flip(1:i-1)
           T_acc{i} = T_acc{i}*T{j}; 
        end
    end
end

