%[text] ## 2.2 Sensitivity to model mis-match and feed-forward (equilibrium) thrust
%[text] In this section, we will assess how the controller handles inaccuracies of model parameters and how this impacts the drone behavior. 
%[text] To do so please specify the name of your simulink model:
clear
modelname='exercise01_simulation_model_template_R2025b';
%%
%[text] Before we start comparing the influence of model deviations we record a simulation using accurate parameters (reference).
load_system(modelname)
% make sure that the system is not loaded yet to ensure parameters are loaded correctly
% if the simulation does not run type close_system('exercise01_simulation_model_solution_partA_R2017b') in the command line

% Simulate a reference run
sim(modelname);
sim_out_ref = get_sim_data(logsout);
%%
%[text] ### 2.2.1 Sensitivity to Deviations of Mass
%[text] Use the slider below to adjust the mass used for the controller and measure the steady-state offset from the reference.
mass_deviation=4; %in percent %[control:slider:983a]{"position":[16,17]}

%Adjust the nrotor_vehicle.mass_for_controller value accordingly and recalculate the nrotor_vehicle.equilibrium_thrusts

nrotor_vehicle.mass_for_controller = nrotor_vehicle.mass_true*(1+mass_deviation*0.01);
nrotor_vehicle.equilibrium_thrust = exercise01_compute_equilibrium_thrusts(nrotor_vehicle.layout_for_controller,nrotor_vehicle.mass_for_controller,g);

%Simulate the model with the modified parameters and visualize the model
sim(modelname);
sim_out = get_sim_data(logsout);
plot_sim_data(sim_out_ref, sim_out)
%%
%[text] Make several runs using different mass deviations. Is the offset of the response linear in the mis-match?
%[text] ```
%[text] Hint: to answer this you can read the offset from the plot using data tips.
%[text] ```
%%
%[text] Before we investigate another parameter lets close the model, so that we can start with the correct reference again. 
close_system(modelname)
%%
%[text] ### 2.2.2 Sensitivity to Deviations of Layout
%[text] Use the slider to adjust the propeller layout dimensions used for the controller and measure the steady-state offset from the reference.
load_system(modelname)
% make sure that the system is not loaded yet to ensure parameters are loaded correctly
% if there the simulation does not run type close_system('exercise01_simulation_model_solution_partA_R2017b') in the command line

% redo the same as before... students could adapt code accordingly...
layout_deviation=3; %in percent %[control:slider:6a95]{"position":[18,19]}
%[text] Specify an offset in the X and Y body frame directions, in \[meters\]
x_offset = x_baseline * layout_deviation*0.01;
y_offset = y_baseline * layout_deviation*0.01;
%[text] Make the layout used for controller design the true layout shifted by the offsets specified
nrotor_vehicle.layout_for_controller = nrotor_vehicle.layout_true + repmat( [x_offset;y_offset;0.000] , 1 , size(nrotor_vehicle.layout_true,2) );

%Simulate and visualize the model
sim(modelname);
sim_out = get_sim_data(logsout);
plot_sim_data(sim_out_ref,sim_out)
%[text]  Is the offset linear in the mis-match?
%[text] ```
%[text] Write your answer here...
%[text] ```
%[text] 

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[control:slider:983a]
%   data: {"defaultValue":-4,"label":"mass_deviation","max":5,"min":-5,"run":"Section","runOn":"ValueChanging","step":1}
%---
%[control:slider:6a95]
%   data: {"defaultValue":-4,"label":"mass_deviation","max":5,"min":-5,"run":"Section","runOn":"ValueChanging","step":1}
%---
