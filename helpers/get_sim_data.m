function [sim] = get_sim_data(logsout)
figure("Position",[0 0 1000 1000])
    sim.thrust = logsout{1}.Values.Data;
    fullstate = logsout{2}.Values.Data;
    sim.ref = logsout{3}.Values.Data;

    sim.position = fullstate(:,1:3);
    sim.angle = fullstate(:,7:9);

    sim.time = logsout{2}.Values.Time;
end

%[appendix]{"version":"1.0"}
%---
