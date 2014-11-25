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
T_acc_a1 = get_vector(T_acc,1,1);
T_acc_a2 = get_vector(T_acc,1,2);
T_acc_a3 = get_vector(T_acc,2,1);
T_acc_a4 = get_vector(T_acc,2,2);

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
T2_final_a1 = get_vector(T2_final,1,1);
T2_final_a2 = get_vector(T2_final,1,2);
T2_final_a3 = get_vector(T2_final,2,1);
T2_final_a4 = get_vector(T2_final,2,2);

N=0:length(T_acc_x)-1;
subplot(3,2,1)
plot(N,T_acc_x,N,T2_final_x,'r')
legend('Original','Compensated')
title([title_name ', x displacement']);
subplot(3,2,2)
plot(N,T_acc_y,N,T2_final_y,'r')
legend('Original','Compensated')
title([title_name ', y displacement']);
subplot(3,2,3)
plot(N,T_acc_a1,N,T2_final_a1,'r')
legend('Original','Compensated')
title([title_name ', a1 displacement']);
subplot(3,2,4)
plot(N,T_acc_a2,N,T2_final_a2,'r')
legend('Original','Compensated')
title([title_name ', a2 displacement']);
subplot(3,2,5)
plot(N,T_acc_a3,N,T2_final_a3,'r')
legend('Original','Compensated')
title([title_name ', a3 displacement']);
subplot(3,2,6)
plot(N,T_acc_a4,N,T2_final_a4,'r')
legend('Original','Compensated')
title([title_name ', a4 displacement']);




