function trajectory_plotter(T,T_smud,title_name)
%TRAJECTORY_PLOTTER Plots the translation trajectories pre and post
%stabilization.

%Calculate the original trajectory by accumulating T.
T_acc = matrix_accum(T);
T_unit = cell(1,1);
T_unit{1} = eye(3);
T_acc = [T_unit;T_acc];
T_smud = [T_smud;T_unit];
%Method 1: Just adding translation coordinates for the original trajectory
%and the warp matrices.
T_acc_x = get_vector(T_acc,1,3);
T_acc_y = get_vector(T_acc,2,3);

T_smud_x = get_vector(T_smud,1,3);
T_smud_y = get_vector(T_smud,2,3);

T_final_x = T_acc_x + T_smud_x;
T_final_y = T_acc_y + T_smud_y;

%Method 2: Multiplication of the warp and original trajectory matrices.
T2_final = cell(length(T_smud),1);
for i=1:length(T_smud)
    T2_final{i} = T_smud{i}*T_acc{i};
end

T2_final_x = get_vector(T2_final,1,3);
T2_final_y = get_vector(T2_final,2,3);

N=0:length(T_acc_x)-1;
subplot(2,1,1)
plot(N,T_acc_x,N,T_final_x,N,T2_final_x)
legend('Original','Compensated, method 1','Compensated, method 2')
title([title_name ', x displacement']);
subplot(2,1,2)
plot(N,T_acc_y,N,T_final_y,N,T2_final_y)
legend('Original','Compensated, method 1','Compensated, method 2')
title([title_name ', y displacement']);



