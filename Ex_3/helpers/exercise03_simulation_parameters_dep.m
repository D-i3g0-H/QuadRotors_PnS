%% --------------------------------------------------------------------- %%
%  Modelling, Control, and Estimation of N-rotor vehicles
%
%% CONTROL ARCHITECTURE AND TUNING OF PID AND LQR CONTROLLERS
%  
%  Note:
%  PID stands for Proportional Integral Derivative
%  LQR stands for Linear Quadratic Regulator
%
%% --------------------------------------------------------------------- %%



%% ASSUMPTIONS:
%  1) The origin of the body frame is at the center of mass of the N-rotor
%     vehicle.
%  2) The thrusts from the propellers are all aligned with the positive
%     z-axis of the body frame.
%  3) Gravity is aligned with the negative z-axis of the inertial frame


%% CLEAR AND CLOSE EVERYTHING
% > Clear all variables:
% clear;
% > Close all open figures
close all;
% > Clear any text from the Command Window
clc;


%% PARAMETERS OF THE N-ROTOR VEHICLE

% INFO:
% The student should open the file "get_vehicle_paramters.m" and specify
% the N-rotor vehicle design as instructed in that file

exercise02_get_crazyflie_vehicle_paramters;

% The "get_vehicle_paramters_for_exercise02" script puts the following
% varibles into the workspace so that they can be used in the Simulink
% model:
% >> g
% >> g_vec
% >> nrotor_vehicle.mass_true
% >> nrotor_vehicle.mass_for_controller
% >> nrotor_vehicle.inertia_true
% >> nrotor_vehicle.inertia_true_inverse
% >> nrotor_vehicle.layout_true
% >> nrotor_vehicle.layout_for_controller
% >> nrotor_vehicle.thrust_min
% >> nrotor_vehicle.thrust_max
% >> nrotor_initial_condition(s)



% INFO:
% The following function "visualise_nrotor_vehicle" makes a nice plot
% showing the top view layout of the N-rotor vehicle. Note that the rotor
% size is scaled automatically so that the circles representing each rotor
% "just touch", but this may sometimes lead to a strange appearance.
%if exist( 'visualise_nrotor_vehicle' , 'file' )
%    visualise_nrotor_vehicle( nrotor_vehicle_layout_true );
%end





%% SPECIFY THE FREQUENCY OF THE MEASUREMENTS AND CONTROLLER

% For convenience of Simulink, the specifications here are in terms of the
% sample time, i.e., the recipricol of the frequency

% Sample time for the different types of measurements:
% > for the full state measurement
sample_time.measurements_full_state = 1/200;
% > for the body rates measurement taken by the on-board gyroscope
sample_time.measurements_body_rates = 1/500;
% > for the body accelerations measurement taken by the on-board
%   accelerometer
sample_time.measurements_body_accelerations = 1/500;

% Sample time for the OUTER loop controller
sample_time.controller_outer = 1/200;
% Sample time for the INNER loop controller
sample_time.controller_inner = 1/500;

%% LOAD THE HARD-CODED "DEFAULT" LINEAR QUADRATIC REGULATOR (LQR) CONTROLLER

% INFO:
% > For the purposes of the template, an LQR controller feedback matrix is
%   hard-coded and should stabilise most N-rotor vehicle layouts.

exercise02_get_default_outer_controller;

% The "get_vehicle_paramters_for_exercise02" script puts the following
% varibles into the workspace so that they can be used here:
% >> K_lqr.outer_loop_continous_time
% >> K_lqr.outer_loop_discrete_time_1Hz
% >> K_lqr.outer_loop_discrete_time_100Hz
% >> K_lqr.outer_loop_discrete_time_200Hz


% SELECT HERE THE CONTROLLER TO USE BY UN-COMMENTING THE DESIRED LINE
%K_lqr.outer_loop = K_lqr_outer_loop_continous_time;
%K_lqr.outer_loop = K_lqr_outer_loop_discrete_time_1Hz;
%K_lqr.outer_loop = K_lqr_outer_loop_discrete_time_100Hz;
K_lqr.outer_loop = K_lqr.outer_loop_discrete_time_200Hz;


%% THIS EXERCISE DOES NOT REQUIRE THE STUDENT TO DESIGN A CONTROLLER

% > For students implementing their own LQR controller, they should add
%   the necessary code to define the linearisation of the N-rotor vehicle
%   and solve the Riccati equation to get their own LQR controller feedback
%   matrix.


%% COMPUTE THE EQUILIBRIUM THRUSTS

% INFO:
% The "exercise02_compute_equilibrium_thrusts" function computes and
% returns the equilibrium thrusts as a column vector of length N. Thus the
% variable "nrotor_vehicle_equilibrium_thrust" is in the workspace and can
% be used in the Simulink model.

nrotor_vehicle.equilibrium_thrust = exercise02_compute_equilibrium_thrusts(nrotor_vehicle.layout_for_controller,nrotor_vehicle.mass_for_controller,g);


%% LOAD THE PID PARAMTERS OF THE RATE CONTROLLER THAT RUN ON-BOARD THE CRAZYFLIE

% INFO:
%  The PID Parameters are taken directly from the crazyflie firmware,

exercise02_get_crazyflie_inner_controller;


%% SPECIFY THE MEASUREMENT NOISE PARAMETERS

exercise02_get_measurement_noise_details;


%% SPECIFY THE REFERENCE SIGNAL FOR (x,y,z,yaw)

% INFO:
% The student can open the file
% "get_reference_specification_for_exercise02.m" and follow the comments
% there to adjust the reference signal
exercise02_get_reference_specification;


% The "get_reference_specification_for_exercise02" script puts the
% following varibles into the workspace so that they can be used in the
% Simulink model:
% >> reference.step_xyz_yaw
% >> reference.step_period
% >> reference.sine_amplitude_xyz_yaw
% >> reference.sine_bias_xyz_yaw
% >> reference.sine_period
% >> reference.saw_tooth_amplitude_xyz_yaw
% >> reference.saw_tooth_bias_xyz_yaw
% >> reference.step_inclusion_multiplier
% >> reference.sine_wave_inclusion_multiplier
% >> reference.saw_tooth_inclusion_multiplier

