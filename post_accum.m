function [T_acc] = prev_accum(T)

    T_acc = cell(length(T),1);
    T_acc{length(T)} = T{length(T)};

    for i=flip(1:length(T)-1)
        T_acc{i} = T_acc{i+1}*T{i};
    end
end

