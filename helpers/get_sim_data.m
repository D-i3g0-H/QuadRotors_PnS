function [sim] = get_sim_data(logsout)
  % GET_SIM_DATA - This function extracts specific time-series signals from a Simulink logsout dataset and returns them in a structured sim output.  
  % The function get_sim_data reads three entries from the logsout cell array and maps their .Values.Data and .Values.Time into fields of the sim struct.
  % It also slices a combined state array (fullstate) to create separate position and angle fields.
  % The code assumes logsout entries 
  %
  % Input arguments:
  % logsout - cell array of logged simulation signals containing .Values.Data and .Values.Time as provided by Simulink logging.
  %
  % Output arguments:
  % sim - struct with fields: thrust, ref, position, angle, time
    sim.thrust = logsout{3}.Values.Data;
    fullstate = logsout{2}.Values.Data;
    sim.ref = logsout{1}.Values.Data;
    % position: first three columns are XYZ positions
    sim.position = fullstate(:,1:3);
    % angle: columns 7-9 contain Euler or attitude angles
    sim.angle = fullstate(:,7:9);
    sim.time = logsout{2}.Values.Time;
end

%[appendix]{"version":"1.0"}
%---
