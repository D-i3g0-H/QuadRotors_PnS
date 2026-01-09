function [sim] = get_sim_data(logsout)
    sim.thrust = logsout{3}.Values.Data;
    fullstate = logsout{2}.Values.Data;
    sim.ref = logsout{1}.Values.Data;

    sim.position = fullstate(:,1:3);
    sim.angle = fullstate(:,7:9);



    sim.time = logsout{2}.Values.Time;
end

%[appendix]{"version":"1.0"}
%---
