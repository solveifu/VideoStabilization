function [T_acc] = prev_accum(T)

    T_acc = cell(length(T),1);
    T_acc{1} = T{1};

    for i=2:length(T)
        T_acc{i} = T_acc{i-1}*T{i};
    end
end

