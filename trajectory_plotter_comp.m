function trajectory_plotter_comp(T,T_litvin,T_matsu)

%Calculate the original trajectory by accumulating T.
T_acc = matrix_accum(T);
T_unit = cell(1,1);
T_unit{1} = eye(3);
T_acc = [T_unit;T_acc];
T_litvin = [T_litvin;T_unit];
T_matsu = [T_matsu;T_unit];

T_acc_x = get_vector(T_acc,1,3);
T_acc_y = get_vector(T_acc,2,3);
T_acc_a1 = get_vector(T_acc,1,1);
T_acc_a2 = get_vector(T_acc,1,2);
T_acc_a3 = get_vector(T_acc,2,1);
T_acc_a4 = get_vector(T_acc,2,2);


%Method 2: Multiplication of the warp and original trajectory matrices.
T1_final = cell(length(T_litvin),1);
T2_final = cell(length(T_matsu),1);
for i=1:length(T_litvin)
    T1_final{i} = T_litvin{i}*T_acc{i};
    T2_final{i} = T_matsu{i}*T_acc{i};
end

T1_final_x = get_vector(T1_final,1,3);
T1_final_y = get_vector(T1_final,2,3);
T1_final_a1 = get_vector(T1_final,1,1);
T1_final_a2 = get_vector(T1_final,1,2);
T1_final_a3 = get_vector(T1_final,2,1);
T1_final_a4 = get_vector(T1_final,2,2);

T2_final_x = get_vector(T2_final,1,3);
T2_final_y = get_vector(T2_final,2,3);
T2_final_a1 = get_vector(T2_final,1,1);
T2_final_a2 = get_vector(T2_final,1,2);
T2_final_a3 = get_vector(T2_final,2,1);
T2_final_a4 = get_vector(T2_final,2,2);

N=0:length(T_acc_x)-1;
subplot(3,2,1)
plot(N,T1_final_x,'r',N,T2_final_x,'b',N,T_acc_x,'k','LineWidth',2)
xlabel('Frame number');
ylabel('Displacement');
legend('Original','Litvin','Matsushita','location','NorthWest')
title('b_{1}, x direction');
subplot(3,2,2)
plot(N,T1_final_y,'r',N,T2_final_y,'b',N,T_acc_y,'k','LineWidth',2)
xlabel('Frame number');
ylabel('Displacement');
legend('Original','Litvin','Matsushita','location','NorthWest')
title('b_{2}, y direction');
subplot(3,2,3)
plot(N,T1_final_a1,'r',N,T2_final_a1,'b',N,T_acc_a1,'k','LineWidth',2)
xlabel('Frame number');
ylabel('Displacement');
legend('Original','Litvin','Matsushita','location','NorthWest')
title('a_{1}, zoom');
subplot(3,2,4)
plot(N,T1_final_a2,'r',N,T2_final_a2,'b',N,T_acc_a2,'k','LineWidth',2)
xlabel('Frame number');
ylabel('Displacement');
legend('Original','Litvin','Matsushita','location','NorthWest')
title('a_{2}, rotation');
subplot(3,2,5)
plot(N,T1_final_a3,'r',N,T2_final_a3,'b',N,T_acc_a3,'k','LineWidth',2)
xlabel('Frame number');
ylabel('Displacement');
legend('Original','Litvin','Matsushita','location','NorthWest')
title('a_{3}, rotation');
subplot(3,2,6)
plot(N,T1_final_a4,'r',N,T2_final_a4,'b',N,T_acc_a4,'k','LineWidth',2)
xlabel('Frame number');
ylabel('Displacement');
legend('Original','Litvin','Matsushita','location','NorthWest')
title('a_{4}, zoom');




