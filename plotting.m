function [ output_args ] = plotting( input_args )
    % Plot the differences between consecutive frames
    clf
    hold on
    plot(cell2mat(T_xya));
    hold off

    % Plot trajectories
    clf
    hold on
    plot(cell2mat(traj_xya));
    plot(cell2mat(traj_xya_smud),':');
    hold off

end

