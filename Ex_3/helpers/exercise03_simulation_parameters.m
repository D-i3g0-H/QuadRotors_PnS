%[text] # Modelling, Control, and Estimation of N-rotor vehicles
%[text] ## CONTROL ARCHITECTURE AND TUNING OF PID AND LQR CONTROLLERS
%[text] ```
%[text] Note:
%[text] PID stands for Proportional Integral Derivative
%[text] LQR stands for Linear Quadratic Regulator
%[text] ```
%%
%[text] ## Introduction
%[text] This file is run automatically when the Simulink model is opened. (see the PreLoadFcn callback).
%[text] Please note that the file runs additional scripts/functions as follows:
%[text] - `exercise03_get_crazyflie_vehicle_paramters`: defines the `nrotor_vehicle` parameters and the initial conditions.
%[text] - `exercise03_get_default_outer_controller`: defines LQR parametes for different position and yaw controller.
%[text] - `exercise03_compute_equilibrium_thrusts.m` (function).
%[text] - `exercise03_get_crazyflie_inner_controller:` get PID values used by the crazyflie firmware;
%[text] - `exercise03_get_measurement_noise_details:` can be used to specify noise
%[text] - `exercise03_get_reference_specification`; defines the reference signal that should be tracked by the controller. \
%[text] This will place all the necessary parameters for the simulation in the MATLAB workspace. The parameters are then accessed during runtime of the model.
%%
%[text] ## CLEAR AND CLOSE EVERYTHING
%[text] \> Clear all variables: clear; \> Close all open figures
close all;
% > Clear any text from the Command Window
clc;
%%
%[text] ## PARAMETERS OF THE N-ROTOR VEHICLE
%[text] ASSUMPTIONS:
%[text] ```
%[text] 1) The origin of the body frame is at the center of mass of the N-rotor
%[text]    vehicle.
%[text] 2) The thrusts from the propellers are all aligned with the positive
%[text]    z-axis of the body frame.
%[text] 3) Gravity is aligned with the negative z-axis of the inertial frame
%[text] ```
%[text] The student should open the file "exercise03\_get\_crazyflie\_vehicle\_paramters.m" and specify the N-rotor vehicle design as instructed in that file
exercise03_get_crazyflie_vehicle_paramters;
%[text] The "get\_vehicle\_paramters\_for\_exercise02" script puts the following varibles into the workspace so that they can be used in the Simulink model:
%[text] - `g`
%[text] - `g_vec`
%[text] - `nrotor_vehicle.mass_true`
%[text] - `nrotor_vehicle.mass_for_controller`
%[text] - `nrotor_vehicle.inertia_true`
%[text] - `nrotor_vehicle.inertia_true_inverse`
%[text] - `nrotor_vehicle.layout_true`
%[text] - `nrotor_vehicle.layout_for_controller`
%[text] - `nrotor_vehicle.thrust_min`
%[text] - `nrotor_vehicle.thrust_max`
%[text] - `nrotor_initial_condition(s)` \
%%
%[text] ## Visualization of the N-Rotor vehicle
%[text] The following function "visualise\_nrotor\_vehicle" makes a nice plot showing the top view layout of the N-rotor vehicle. Note that the rotor size is scaled automatically so that the circles representing each rotor "just touch", but this may sometimes lead to a strange appearance.
%if exist( 'visualise_nrotor_vehicle' , 'file' )
%    visualise_nrotor_vehicle( nrotor_vehicle_layout_true );
%end
%%
%[text] ## SPECIFY THE FREQUENCY OF THE MEASUREMENTS AND CONTROLLER
%[text] For convenience of Simulink, the specifications here are in terms of the sample time, i.e., the recipricol of the frequency.
%[text] Sample time for the different types of measurements:
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
%%
%[text] ## LOAD THE HARD-CODED "DEFAULT" LINEAR QUADRATIC REGULATOR (LQR) CONTROLLER
%[text] For the purposes of the template, an LQR controller feedback matrix is hard-coded and should stabilise most N-rotor vehicle layouts.
exercise03_get_default_outer_controller;
%[text] The "get\_vehicle\_paramters\_for\_exercise03" script puts the following varibles into the workspace so that they can be used here:
%[text] - `K_lqr.outer_loop_continous_time`
%[text] - `K_lqr.outer_loop_discrete_time_1Hz`
%[text] - `K_lqr.outer_loop_discrete_time_100Hz`
%[text] - `K_lqr.outer_loop_discrete_time_200Hz` \
%[text] **Selection of controller to be used in the exercise (select by (un-)commenting)**
%K_lqr.outer_loop = K_lqr_outer_loop_continous_time;
%K_lqr.outer_loop = K_lqr_outer_loop_discrete_time_1Hz;
%K_lqr.outer_loop = K_lqr_outer_loop_discrete_time_100Hz;
K_lqr.outer_loop = K_lqr.outer_loop_discrete_time_200Hz;
%%
%[text] ## Student Controller
%[text] **THIS EXERCISE DOES NOT REQUIRE THE STUDENT TO DESIGN A CONTROLLER**
%[text] For students implementing their own LQR controller, they should add the necessary code to define the linearisation of the N-rotor vehicle and solve the Riccati equation to get their own LQR controller feedback matrix.
% this line could be used to overwrite the standard controller ;)
%%
%[text] ## COMPUTE THE EQUILIBRIUM THRUSTS
%[text] The "exercise02\_compute\_equilibrium\_thrusts" function computes and returns the equilibrium thrusts as a column vector of length N. Thus the variable "nrotor\_vehicle\_equilibrium\_thrust" is in the workspace and can be used in the Simulink model.
nrotor_vehicle.equilibrium_thrust = exercise03_compute_equilibrium_thrusts(nrotor_vehicle.layout_for_controller,nrotor_vehicle.mass_for_controller,g);
%%
%[text] ## LOAD THE PID PARAMTERS OF THE RATE CONTROLLER THAT RUN ON-BOARD THE CRAZYFLIE
%[text] The PID Parameters are taken directly from the crazyflie firmware.
exercise03_get_crazyflie_inner_controller;
%%
%[text] ## SPECIFY THE MEASUREMENT NOISE PARAMETERS
exercise03_get_measurement_noise_details;
%%
%[text] ## SPECIFY THE REFERENCE SIGNAL FOR (x,y,z,yaw)
%[text] The student can open the file "exercise03\_get\_reference\_specification.m" and follow the comments there to adjust the reference signal
exercise03_get_reference_specification;
%[text] The "exercise03\_get\_reference\_specification" script puts the following varibles into the workspace so that they can be used in the Simulink model:
%[text] - `reference.step_xyz_yaw`
%[text] - `reference.step_period`
%[text] - `reference.sine_amplitude_xyz_yaw`
%[text] - `reference.sine_bias_xyz_yaw`
%[text] - `reference.sine_period`
%[text] - `reference.saw_tooth_amplitude_xyz_yaw`
%[text] - `reference.saw_tooth_bias_xyz_yaw`
%[text] - `reference.step_inclusion_multiplier\\$`
%[text] - `reference.sine_wave_inclusion_multiplier`
%[text] - `reference.saw_tooth_inclusion_multiplier` \

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
