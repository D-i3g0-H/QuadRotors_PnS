%% PARAMETERS OF THE N-ROTOR VEHICLE

%% STUDENTS TO SPECIFY LAYOUT AND PARAMETERS OF THEIR N-ROTOR DESIGN HERE:

% Gravitational constant:
g = 9.81;
g_vec = [0; 0; -g];

% The TRUE mass of the N-rotor vehicle, used for simulating the equations
% of motion [kg]
nrotor_vehicle.mass_true = 32e-3;

% The "measured" mass of the N-rotor vehicle, USED FOR computing the
% FEED-FORWARD THRUST and CONTROLLER GAINS [kg]
nrotor_vehicle.mass_for_controller = 32e-3 * 1.00;

% The TRUE mass moment of inertia of the N-rotor vehicle, used for
% simulating the equations of motion [kg m^2]
nrotor_vehicle.inertia_true = [...
        16.57 ,   0.83 ,   0.72 ;...
         0.83 ,  16.66 ,   1.80 ;...
         0.72 ,   1.80 ,  29.26  ...
    ] * 1e-6;

% Inverse of the moment of inertia for convenience
nrotor_vehicle.inertia_true_inverse = inv(nrotor_vehicle.inertia_true);

% NOTE: that an "nrotor_vehicle_inertia_for_controller" is not specified
% because it is not needed for the controller design used by the template.
% However, if the controller design is changed to use the mass moment of
% inertia, then a "for controller" variable should be added to allow for
% the possibility of model mis-match
%nrotor_vehicle.inertia_for_controller = ...





% The the layout of the N-rotor vehicle:
% NOTE: the layout is specified as a matrix with the following format:
% nrotor_vehicle.layout = [...
%       x_1  ,  x_2  ,  ...  ,  x_{N-1}  ,  x_{N}  ;...
%       y_1  ,  y_2  ,  ...  ,  y_{N-1}  ,  y_{N}  ;...
%       c_1  ,  c_2  ,  ...  ,  c_{N-1}  ,  c_{N}   ...
%   ];
% where:
%   > x_i   is the x coordinate of propeller "i" relative to the CoG
%   > y_i   is the y coordinate of propeller "i" relative to the CoG
%   > c_i   is the thurst to torque coefficient of the propeller, with the
%           sign used to indicate the propeller's direction of rotation,
%           +ve indicates clock-wise propeller rotation.


% Specify a "baseline" value for the x and y coordinates of the propellers
% in the layout [meters]
x_baseline = (0.092/2) / sqrt(2);
y_baseline = (0.092/2) / sqrt(2);

% Specify a "baseline" value for the "torque-to-thrust" ratio to make
% constructing the "nrotor_vehicle_layout" matrix cleaner
c_baseline = 0.00596;


% The TRUE Quad-rotor layout in "X" formation, used for simulating the
% equations of motion:

% Symmetric 4-rotor Example:
nrotor_vehicle.layout_true = [...
        [  1 , -1 , -1 ,  1 ] * x_baseline  ;...
        [ -1 , -1 ,  1 ,  1 ] * y_baseline  ;...
        [ -1 ,  1 , -1 ,  1 ] * c_baseline   ...
    ];


% The "measured" symmetric Quad-rotor layout in "X" formation, USED FOR
% computing the FEED-FORWARD THRUST and CONTROLLER GAINS

% Specify an offset in the X and Y body frame directions, in [meters]
x_offset = x_baseline * 0.00;
y_offset = y_baseline * 0.00;

% Make the layout used for controller design the true layout shifted by the
% offsets specified
nrotor_vehicle.layout_for_controller = nrotor_vehicle.layout_true + repmat( [x_offset;y_offset;0.000] , 1 , size(nrotor_vehicle.layout_true,2) );





% SPECIFY THE MAXIMUM AND MINIMUM THRUST THAT CAN BE PRODUCED BY EACH
% PROPELLER:
% > This should be in unit of [Newtons]
% > For the minimum thrust: (this should always be zero)
nrotor_vehicle.thrust_min =       zeros( size(nrotor_vehicle.layout_true,2) , 1 );
% > For the maximum thrust:
nrotor_vehicle.thrust_max = 0.1597*ones( size(nrotor_vehicle.layout_true,2) , 1 );





% Clear the variable that are not needed
clear c_baseline;
clear x_offset;
clear y_offset;

%% INITIAL CONDITIONS FOR THE INTEGRATORS IN THE SIMULINK MODEL

% NOTE:
% It is important to set the initial condition of any integrator block in
% the Simulnk mode because Simulink use the size of the initial conidition
% to determine the size the vector signals.

% Initial conditions for the full state
nrotor_initial_condition.p       =    [0; 0; 0];
nrotor_initial_condition.p_dot   =    [0; 0; 0];
nrotor_initial_condition.psi     =    [0; 0; 0];
nrotor_initial_condition.psi_dot =    [0; 0; 0];
nrotor_initial_conditions = [...
        nrotor_initial_condition.p          ;...
        nrotor_initial_condition.p_dot      ;...
        nrotor_initial_condition.psi        ;...
        nrotor_initial_condition.psi_dot    ;...
    ];

% Initial conditions for the body rates
nrotor_initial_condition.body_rates = [0; 0; 0];





%% ASCII ART OF THE CRAZYFLIE 2.0 LAYOUT
%
%  > M1 to M4 stand for Motor 1 to Motor 4
%  > "CW"  indicates that the motor rotates Clockwise
%  > "CCW" indicates that the motor rotates Counter-Clockwise
%
%
%        ____                         ____
%       /    \                       /    \
%  (CW) | M4 |           x           | M1 | (CCW)
%       \____/\          ^          /\____/
%            \ \         |         / /
%             \ \        |        / /
%              \ \______ | ______/ /
%               \        |        /
%                |       |       |
%        y <-------------o       |
%                |               |
%               / _______________ \
%              / /               \ \
%             / /                 \ \
%        ____/ /                   \ \____
%       /    \/                     \/    \
% (CCW) | M3 |                       | M2 | (CW)
%       \____/                       \____/
%
%
%
%  ---------------------------------------------------------------------  %