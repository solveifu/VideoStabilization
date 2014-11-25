function trajectory_compare(T1,T2,title_name)

    T1_acc = matrix_accum(T1);
    T2_acc = matrix_accum(T2);

    T1_acc_x = get_vector(T1_acc,1,3);
    T1_acc_y = get_vector(T1_acc,2,3);
    T1_acc_a1 = get_vector(T1_acc,1,1);
    T1_acc_a2 = get_vector(T1_acc,1,2);
    T1_acc_a3 = get_vector(T1_acc,2,1);
    T1_acc_a4 = get_vector(T1_acc,2,2);

    T2_acc_x = get_vector(T2_acc,1,3);
    T2_acc_y = get_vector(T2_acc,2,3);
    T2_acc_a1 = get_vector(T2_acc,1,1);
    T2_acc_a2 = get_vector(T2_acc,1,2);
    T2_acc_a3 = get_vector(T2_acc,2,1);
    T2_acc_a4 = get_vector(T2_acc,2,2);


    N=0:length(T1_acc_x)-1;
    subplot(3,2,1)
    plot(N,T1_acc_x,N,T2_acc_x,'r')
    legend('Trajectory 1','Trajectory 2')
    title([title_name ', x displacement']);
    subplot(3,2,2)
    plot(N,T1_acc_y,N,T2_acc_y,'r')
    legend('Trajectory 1','Trajectory 2')
    title([title_name ', y displacement']);
    subplot(3,2,3)
    plot(N,T1_acc_a1,N,T2_acc_a1,'r')
    legend('Trajectory 1','Trajectory 2')
    title([title_name ', a1 displacement']);
    subplot(3,2,4)
    plot(N,T1_acc_a2,N,T2_acc_a2,'r')
    legend('Trajectory 1','Trajectory 2')
    title([title_name ', a2 displacement']);
    subplot(3,2,5)
    plot(N,T1_acc_a3,N,T2_acc_a3,'r')
    legend('Trajectory 1','Trajectory 2')
    title([title_name ', a3 displacement']);
    subplot(3,2,6)
    plot(N,T1_acc_a4,N,T2_acc_a4,'r')
    legend('Trajectory 1','Trajectory 2')
    title([title_name ', a4 displacement']);
end



