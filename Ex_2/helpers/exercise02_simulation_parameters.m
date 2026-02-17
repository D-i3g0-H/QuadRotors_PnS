%[text] # Modelling, Control, and Estimation of N-rotor vehicles
%[text] CONTINUOUS TIME SIMULATION EXERCISE
%[text:tableOfContents]{"heading":"Table of Contents"}
%%
%[text] ## Introduction
%[text] This file is run automatically when the Simulink model is opened. (see the PreLoadFcn callback).
%[text] Please note that the file runs additional scripts/functions as follows:
%[text] - `exercise02_get_vehicle_parameters`: defines the `nrotor_vehicle` parameters and the initial conditions.
%[text] - `exercise02_get_default_controller`: defines LQR parametes for different controller rates.
%[text] - `exercise02_compute_equilibrium_thrusts.m` (function).
%[text] - `exercise02_get_reference_specification`; defines the reference signal that should be tracked by the controller. \
%[text] This will place all the necessary parameters for the simulation in the MATLAB workspace. The parameters are then accessed during runtime of the model.
%[text] Note: If you want to change the parameters for the simulation, you have to make sure that the model is already loaded before altering values. Otherwise your changes will be overwritten.
%%
%[text] ## Setup of Workspace
% > Close all open figures
close all;
% > Clear any text from the Command Window
clc;
%%
%[text] ## Parameters of the N-Rotor Vehicle
%[text] ASSUMPTIONS:
%[text] 1. The origin of the body frame is at the center of mass of the N-rotor vehicle.
%[text] 2. The thrusts from the propellers are all aligned with the positive z-axis of the body frame.
%[text] 3. Gravity is aligned with the negative z-axis of the inertial frame. \
%[text] The student should open the file "get\_vehicle\_parameters.m" and specify the N-rotor vehicle design as instructed in that file
exercise02_get_vehicle_parameters;
%[text] The exercise02\_`get_vehicle_parameters` script puts the following varibles into the workspace so that they can be used in the Simulink model:
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
%[text] - `nrotor_initial_condition` \
%%
%[text] ## Visualization of the N-Rotor vehicle
%[text] The following function "visualise\_nrotor\_vehicle" makes a nice plot showing the top view layout of the N-rotor vehicle. Note that the rotor size is scaled automatically so that the circles representing each rotor "just touch", but this may sometimes lead to a strange appearance.
%if exist( 'visualise_nrotor_vehicle' , 'file' )
%    visualise_nrotor_vehicle( nrotor_vehicle_layout_true );
%end
%%
%[text] ## Default Linear Quadratic Regulator (LQR) Controller
%[text] For the purposes of the template, an LQR controller feedback matrix is hard-coded and should stabilise most N-rotor vehicle layouts.
exercise02_get_default_controller;
%[text] The "exercise02\_get\_default\_controller" script puts the following varibles into the workspace so that they can be used here:
%[text] - `K_lqr_full_state.continous_time`
%[text] - `K_lqr_full_state.discrete_time_20Hz`
%[text] - `K_lqr_full_state.discrete_time_50Hz`
%[text] - `K_lqr_full_state.discrete_time_100Hz`
%[text] - `K_lqr_full_state.discrete_time_200Hz` \
%[text] **Selection of controller to be used in the exercise (select by (un-)commenting)**
K_lqr_full_state = K_lqr.continous_time;
%K_lqr_full_state = K_lqr.discrete_time_20Hz;
%K_lqr_full_state = K_lqr.discrete_time_50Hz;
%K_lqr_full_state = K_lqr.discrete_time_100Hz;
%K_lqr_full_state = K_lqr.discrete_time_200Hz;
%%
%[text] ## Student Controller
%[text] For students implementing their own LQR controller, they should add the necessary code to define the linearisation of the N-rotor vehicle and solve the Riccati equation to get their own LQR controller feedback matrix.
% this line could be used to overwrite the standard controller ;)
%%
%[text] ## Computation of Equilibrium Thrusts
%[text] The "exercise02\_compute\_equilibrium\_thrusts" function computes and returns the equilibrium thrusts as a column vector of length N. Thus the variable "nrotor\_vehicle\_equilibrium\_thrust" is in the workspace and can be used in the Simulink model.
nrotor_vehicle.equilibrium_thrust = exercise02_compute_equilibrium_thrusts(nrotor_vehicle.layout_for_controller,nrotor_vehicle.mass_for_controller,g);
%%
%[text] ## Reference Signal for (x,y,z,yaw)
%[text] The student can open the file "exercise02\_get\_reference\_specification.m" and follow the comments there to adjust the reference signal.
exercise02_get_reference_specification;
%[text] The "exercise02\_get\_reference\_specification.m" script puts the following varibles into the workspace so that they can be used in the Simulink model:
%[text] - `reference.step_xyz_yaw`
%[text] - `reference.step_period`
%[text] - `reference.sine_amplitude_xyz_yaw`
%[text] - `reference.sine_bias_xyz_yaw`
%[text] - `reference.sine_period`
%[text] - `reference.saw_tooth_amplitude_xyz_yaw`
%[text] - `reference.saw_tooth_bias_xyz_yaw`
%[text] - `reference.step_inclusion_multiplier`
%[text] - `reference.sine_wave_inclusion_multiplier`
%[text] - `reference.saw_tooth_inclusion_multiplier` \

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
