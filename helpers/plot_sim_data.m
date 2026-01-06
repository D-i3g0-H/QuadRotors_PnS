function plot_sim_data(varargin)


num_arg=nargin;

for n=1:num_arg
    sim{n}=varargin{n};
end

    figure("position",[0 0 1000 800])
    tiledlayout(7,1)
    nexttile
    plot(sim{1}.time, sim{1}.ref(:,1), sim{1}.time,sim{1}.position(:,1))
    
    if n>1
        hold on
        for n=2:num_arg
            plot(sim{n}.time,sim{n}.position(:,1),':')
        end
        hold off
    end

    title('x-position')
    legend('Ref','Sim')

    nexttile
    plot(sim{1}.time, sim{1}.ref(:,2), sim{1}.time,sim{1}.position(:,2))

    if n>1
        hold on
        for n=2:num_arg
            plot(sim{n}.time,sim{n}.position(:,2),':')
        end
        hold off
    end

    title('y-position')
    legend('sim.ref','Sim')
    nexttile

    plot(sim{1}.time, sim{1}.ref(:,3), sim{1}.time,sim{1}.position(:,3))

    if n>1
        hold on
        for n=2:num_arg
            plot(sim{n}.time,sim{n}.position(:,3),':')
        end
        hold off
    end

    title('z-position')
    legend('sim.ref','Sim')

    nexttile
    plot(sim{1}.time,sim{1}.angle(:,1))

    if n>1
        hold on
        for n=2:num_arg
            plot(sim{n}.time,sim{n}.angle(:,1),':')
        end
        hold off
    end

    title('Pitch')
    legend('Sim')

    nexttile
    plot(sim{1}.time,sim{1}.angle(:,2))

    if n>1
        hold on
        for n=2:num_arg
            plot(sim{n}.time,sim{n}.angle(:,2),':')
        end
        hold off
    end

    title('Roll')
    legend('Sim')

    nexttile
    plot(sim{1}.time,sim{1}.ref(:,4),sim{1}.time,sim{1}.angle(:,3))

    if n>1
        hold on
        for n=2:num_arg
            plot(sim{n}.time,sim{n}.angle(:,3),':')
        end
        hold off
    end

    title('Yaw')
    legend('sim.ref','Sim')
    nexttile
    plot(sim{1}.time, sim{1}.thrust(:,1), sim{1}.time,sim{1}.thrust(:,2), sim{1}.time,sim{1}.thrust(:,3), sim{1}.time,sim{1}.thrust(:,4));
    title('thrusts')
    legend('Motor 1','Motor 2', 'Motor 3', 'Motor 4')
end