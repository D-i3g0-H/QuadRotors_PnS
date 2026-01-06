%[text] # Parameters of the N-rotor Vehicle
%[text:tableOfContents]{"heading":"Table of Contents"}
%%
%[text] ## Layout Parameters of the N-Rotor Vehicle
%[text] %[text:anchor:TMP_535b] STUDENTS TO SPECIFY LAYOUT AND PARAMETERS OF THEIR N-ROTOR DESIGN HERE
%[text] #### Gravitational constant
g = 9.81;
g_vec = [0; 0; -g];
%[text] #### Mass of the N-rotor vehicle
%[text] The TRUE mass of the N-rotor vehicle, used for simulating the equations of motion \[kg\]
nrotor_vehicle.mass_true = 0.200;
%[text] #### Measured Mass of the Vehicle
%[text] The "measured" mass of the N-rotor vehicle, USED FOR computing the FEED-FORWARD THRUST and CONTROLLER GAINS \[kg\]
nrotor_vehicle.mass_for_controller = 0.200;
%[text] #### Moment of Inertia
%[text] The TRUE mass moment of inertia of the N-rotor vehicle, used for simulating the equations of motion \[kg m^2\]
nrotor_vehicle.inertia_true = [...
        11.0 ,   0.0 ,   0.0 ;...
         0.0 ,  11.0 ,   0.0 ;...
         0.0 ,   0.0 ,  22.0  ...
    ] * 1e-4;
%[text] Inverse of the moment of inertia for convenience
nrotor_vehicle.inertia_true_inverse = inv(nrotor_vehicle.inertia_true);
%[text] **NOTE:** that an "nrotor\_vehicle\_inertia\_for\_controller" is not specified because it is not needed for the controller design used by the template. However, if the controller design is changed to use the mass moment of inertia, then a "for controller" variable should be added to allow for the possibility of model mis-match
%[text] ```matlabCodeExample
%[text] nrotor_vehicle.inertia_for_controller = ...
%[text] ```
%%
%[text] ## The the layout of the N-rotor vehicle:
%[text] NOTE: the layout is specified as a matrix with the following format:
%[text] ```matlabCodeExample
%[text] nrotor_vehicle.layout = [...
%[text]     x_1  ,  x_2  ,  ...  ,  x_{N-1}  ,  x_{N}  ;...
%[text]     y_1  ,  y_2  ,  ...  ,  y_{N-1}  ,  y_{N}  ;...
%[text]     c_1  ,  c_2  ,  ...  ,  c_{N-1}  ,  c_{N}   ...
%[text]     ];
%[text] ```
%[text] where:
%[text] - x\_i   is the x coordinate of propeller "i" relative to the CoG
%[text] - y\_i   is the y coordinate of propeller "i" relative to the CoG
%[text] - c\_i   is the thurst to torque coefficient of the propeller, with the sign used to indicate the propeller's direction of rotation, +ve indicates clock-wise propeller rotation. \
%[text] Specify a "baseline" value for the x and y coordinates of the propellers in the layout \[meters\]
x_baseline = 0.300;
y_baseline = 0.300;
%[text] Specify a "baseline" value for the "torque-to-thrust" ratio to make constructing the "nrotor\_vehicle\_layout" matrix cleaner
c_baseline = 0.1;
%[text] The true N-rotor vehicle layout, used for simulating the equations of motion:
%[text] #### Symmetric 4-rotor Example:
nrotor_vehicle.layout_true = [...
        [ -1 , -1 ,  1 ,  1 ] * x_baseline  ;...
        [ -1 ,  1 , -1 ,  1 ] * y_baseline  ;...
        [ -1 ,  1 ,  1 , -1 ] * c_baseline   ...
    ];
%[text] #### Symmetric 8-rotor Example:
%[text] ```matlabCodeExample
%[text] nrotor_vehicle.layout_true = [...
%[text]         [ -1 , -1 ,  1 ,  1 , -1.414 ,  0      ,  1.414 ,  0.0   ] * x_baseline  ;...
%[text]         [ -1 ,  1 , -1 ,  1 ,  0     ,  1.414  ,  0     , -1.414 ] * y_baseline  ;...
%[text]         [  1 ,  1 ,  1 ,  1 , -1     , -1      , -1     , -1     ] * c_baseline   ...
%[text]     ];
%[text] ```
%[text] The "measured" symmetric Quad-rotor layout in "X" formation, USED FOR computing the FEED-FORWARD THRUST and CONTROLLER GAINS
%[text] Specify an offset in the X and Y body frame directions, in \[meters\]
x_offset = x_baseline * 0.00;
y_offset = y_baseline * 0.00;
%[text] Make the layout used for controller design the true layout shifted by the offsets specified
nrotor_vehicle.layout_for_controller = nrotor_vehicle.layout_true + repmat( [x_offset;y_offset;0.000] , 1 , size(nrotor_vehicle.layout_true,2) );
%%
%[text] #### SPECIFY THE MAXIMUM AND MINIMUM THRUST THAT CAN BE PRODUCED BY EACH PROPELLER:
%[text] - This should be in unit of \[Newtons\]
%[text] - For the minimum thrust: (this should always be zero) \
nrotor_vehicle.thrust_min =   zeros( size(nrotor_vehicle.layout_true,2) , 1 );
%[text] For the maximum thrust:
nrotor_vehicle.thrust_max = 10*ones( size(nrotor_vehicle.layout_true,2) , 1 );
%[text] Clear the variable that are not needed
clear c_baseline;
clear x_offset;
clear y_offset;
%%
%[text] ## INITIAL CONDITIONS FOR THE INTEGRATORS IN THE SIMULINK MODEL
%[text] % NOTE: It is important to set the initial condition of any integrator block in the Simulnk mode because Simulink use the size of the initial conidition to determine the size the vector signals.
%[text] #### Initial conditions for the full state
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
%[text] #### Initial conditions for the body rates
nrotor_initial_condition.body_rates = [0; 0; 0];

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":18}
%---
