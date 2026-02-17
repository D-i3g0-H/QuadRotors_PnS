%% SPECIFY WHICH REFERENCES TO INCLUDE AND THEIR SIGNAL PROPERTIES

% INFO:
% The following three variables specify which of the reference signal types
% should be included. If multiple types are "turned-on" then teh reference
% signals are simply summed together.

% Each of these should be set to {'on','yes'} or {'off,'no'}
% > For a STEP CHANGE reference signal:
reference.step_include = 'on';
% > For a SINUSOID reference signal
reference.sine_wave_include = 'off';
% > For a SAW TOOTH reference signal
reference.saw_tooth_wave_include = 'off';



%% SPECIFY THE DETAILS OF THE DIFFERENT REFERENCE SIGNALS

% INFO:
% The variables in this section speficy the properties of each of the
% reference signal types.

% Degrees to radians conversion
deg2rad = pi/180;

% STEP CHANGE REFERENCE:
% > Setpoint for: x, y, z and yaw pose [m, m, m, rad]
reference.step_xyz_yaw = [0.5; 0.5; 0.5; 10*deg2rad];
% > Period [seconds], this is how ofter the setpoint should change between
%   zero and the setpoint specified 
reference.step_period = 5;
                       

% SINUSOID REFERENCE SIGNAL:
% > Amplitude and bias for: x, y, z and yaw pose [m, m, m, rad]
reference.sine_amplitude_xyz_yaw = [0.3; 0.3; 0.3; 3*deg2rad];
reference.sine_bias_xyz_yaw      = [0.0; 0.0; 0.0; 0*deg2rad];
% > Period [seconds]
reference.sine_period = 5;


% SAW TOOTH REFERENCE SIGNAL:
% > Amplitude and bias for: x, y, z and yaw pose [m, m, m, rad]
reference.saw_tooth_amplitude_xyz_yaw = [0.3; 0.3; 0.3; 3*deg2rad];
reference.saw_tooth_bias_xyz_yaw      = [0.0; 0.0; 0.0; 0*deg2rad];



%% CONSTRUCT THE "REFERENCE INCLUSION MULTIPLIERS"

% > For the step reference
switch reference.step_include
    case {'on','yes'}
        reference.step_inclusion_multiplier = 1;
    otherwise
        reference.step_inclusion_multiplier = 0;
end

% > For the sine wave referene
switch reference.sine_wave_include
    case {'on','yes'}
        reference.sine_wave_inclusion_multiplier = 1;
    otherwise
        reference.sine_wave_inclusion_multiplier = 0;
end

% > For the saw tooth reference
switch reference.saw_tooth_wave_include
    case {'on','yes'}
        reference.saw_tooth_inclusion_multiplier = 1;
    otherwise
        reference.saw_tooth_inclusion_multiplier = 0;         
end



% Clear the variables that are not needed
clear reference.step_include;
clear reference.sine_wave_include;
clear reference.saw_tooth_wave_include;
clear deg2rad;