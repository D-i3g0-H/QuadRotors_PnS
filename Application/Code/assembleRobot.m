function robot=assembleRobot(axs,out)
    %out is simulated data of the robot (i.e. the simulation output)
    
    %lighting flat
    %axs=gca;
    cla(axs)
    axis(axs,"equal")
    light(axs,'Position', [1 1 1], 'Style', 'infinite')
    hold(axs,"on")
    
    %define the robot
    % note if you only have step files instead of stl file you can consider the following to get an stl file.
    % gm1=fegeometry("wire_holder v5.step");
    % tri1 = triangulation(gm1);
    % stlwrite(tri1,'wire_holder v5.stl');
    
    %define ref frame
    robot{1}.component=stlcomponent(axs, out.position, out.angle, "Frame.stl",'green', true); %need stl file
    robot{2}.component=stlcomponent(axs, out.position, out.angle, "Arms.stl",'white', false); %need stl file
    robot{3}.component=stlcomponent(axs, out.position, out.angle, "Motors.stl",'cyan', false); %need stl file
    robot{4}.component=stlcomponent(axs, out.position, out.angle, "Propellers.stl",'white', false); %need stl file

    %

    hold(axs,"off")

    axis(axs,"equal")
    light(axs,'Position', [1 1 1], 'Style', 'infinite')
    %lighting flat

    xlabel(axs,'x-axis')
    ylabel(axs,'y-axis')
    title(axs,'Visualization of Simulation')
    view(axs,[-30 20])
    % xlim(axs,[0 a(end)+L/2+10])

end