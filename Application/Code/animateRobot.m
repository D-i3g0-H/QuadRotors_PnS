function animateRobot(app,t)

        %animate the full simulation
        [~,n]=min(abs(app.t - t));
        % for n=1:length(t) %for all the timesteps
        nr_comp=length(app.robot);
            for comp=1:nr_comp % should not be hardcoded if reused with other robots
                update(app.robot{comp}.component, n)
            end
            pause(0.01)
        % end


    % update the results plot... tbd
    timevec=linspace(0,t,n);
    app.resplt.xpos.XData=timevec;
    app.resplt.xpos.YData=app.sim_out.position(1:n,1);

    app.resplt.ypos.XData=timevec;
    app.resplt.ypos.YData=app.sim_out.position(1:n,2);

    app.resplt.zpos.XData=timevec;
    app.resplt.zpos.YData=app.sim_out.position(1:n,3);

    app.resplt.roll.XData=timevec;
    app.resplt.roll.YData=app.sim_out.angle(1:n,1);

    app.resplt.pitch.XData=timevec;
    app.resplt.pitch.YData=app.sim_out.angle(1:n,2);

    app.resplt.yaw.XData=timevec;
    app.resplt.yaw.YData=app.sim_out.angle(1:n,3);

    app.resplt.motors1.XData=timevec;
    app.resplt.motors1.YData=app.sim_out.thrust(1:n,1);

    app.resplt.motors2.XData=timevec;
    app.resplt.motors2.YData=app.sim_out.thrust(1:n,2);

    app.resplt.motors3.XData=timevec;
    app.resplt.motors3.YData=app.sim_out.thrust(1:n,3);

    app.resplt.motors4.XData=timevec;
    app.resplt.motors4.YData=app.sim_out.thrust(1:n,4);

    % %should get the number of traces done so far...) -> make an
    % %automatic legend from the settings...

    app.Slider.Value=t;
    % 
    % pause(0.01)
end