%[text] ## 2.4 Discrete Time Controller
%[text] In reality, measurements of the vehicle's state are only available in discrete time, and new commands can only be sent to the propellers at discrete time instants. Convert your continuous time model to a hybrid model where the non-linear dynamics of the vehicle are simulated in continuous time, the full-state measurements are taken at a particular frequency, and the controller computations are performed at a different frequency.
%[text] This is implemented most easily by adding "Zero-Order Hold" blocks to the Simulink model. I.e. to convert continuous signal into a discretized one add a rate transition block to the signal line.
%[text] Open the Simulink Model and add the rate transition blocks
load_system('exercise01_simulation_model_template_R2025b')
open_system('exercise01_simulation_model_template_R2025b/Controller','tab')
%[text] - Add a rate transition block to the sensor signal line and name it "SensorSampleRate".
%[text] - Add a rate transition block in front of the controller LQR gain matrix and name it "Controller\_Pace". \
%[text] In comparison to the preceeding exercises we will not define these sample rates as parameters. Instead we are going to set the Simulink block parameters using the set\_param functionality.
%[text] `Note:` When state estimation is not performed, these frequencies are typically the same, and for the experiments we will collect measurements at 200Hz.
%%
%[text] Let's now investigate the influence of the controller frequency. How is the step change tracking performance affected by the frequency of control computations? Does the closed loop system become unstable at some frequency?
%Select the controller Frequency
controlFrequency="200 Hz"; %[control:dropdown:9310]{"position":[18,26]}

switch controlFrequency
    case "cont"
        sim_out_ref = get_sim_data(logsout);
        K_lqr_full_state=K_lqr.continous_time;
        set_param('exercise01_simulation_model_template_R2025b/Controller/ControllerPace/','Commented','through')
        set_param('exercise01_simulation_model_template_R2025b/Controller/SensorSampleRate/','Commented','through')
    case "20 Hz"
        K_lqr_full_state=K_lqr.discrete_time_20Hz;
        set_param('exercise01_simulation_model_template_R2025b/Controller/ControllerPace/','OutPortSampleTime','0.05','Commented','off');
        set_param('exercise01_simulation_model_template_R2025b/Controller/SensorSampleRate/','OutPortSampleTime','0.005','Commented','off')
    case "50 Hz"
        K_lqr_full_state=K_lqr.discrete_time_50Hz;
        set_param('exercise01_simulation_model_template_R2025b/Controller/ControllerPace/','OutPortSampleTime','0.02','Commented','off');
        set_param('exercise01_simulation_model_template_R2025b/Controller/SensorSampleRate/','OutPortSampleTime','0.005','Commented','off')
    case "100 Hz"
        K_lqr_full_state=K_lqr.discrete_time_100Hz;
        set_param('exercise01_simulation_model_template_R2025b/Controller/ControllerPace/','OutPortSampleTime','0.01','Commented','off');
        set_param('exercise01_simulation_model_template_R2025b/Controller/SensorSampleRate/','OutPortSampleTime','0.005','Commented','off')
    case "200 Hz"
        K_lqr_full_state=K_lqr.discrete_time_200Hz;
        set_param('exercise01_simulation_model_template_R2025b/Controller/ControllerPace/','OutPortSampleTime','0.005','Commented','off');
        set_param('exercise01_simulation_model_template_R2025b/Controller/SensorSampleRate/','OutPortSampleTime','0.005','Commented','off')
end

%Simulate and visualize the model
sim('exercise01_simulation_model_template_R2025b');
sim_out = get_sim_data(logsout);
plot_sim_data(sim_out_ref,sim_out)
%%
%[text] Test out the following two combination:
%[text] - set the controller computations to a frequency of 20Hz, but use the controller parameters designed for 200Hz \
% implement your solution using the approach above

%Simulate and visualize the model
sim('exercise01_simulation_model_template_R2025b');
sim_out = get_sim_data(logsout);
plot_sim_data(sim_out_ref,sim_out)
%[text] - set the controller computations to a frequency of 200Hz, but use the controller parameters designed for 20Hz.  \
% implement your solution using the approach above

%Simulate and visualize the model
sim('exercise01_simulation_model_template_R2025b');
sim_out = get_sim_data(logsout);
plot_sim_data(sim_out_ref,sim_out)
%[text] Explain the results using intuitive arguments.
%[text] ```
%[text] Student explanation
%[text] ```

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[control:dropdown:9310]
%   data: {"defaultValue":"\"cont\"","itemLabels":["Continuous","20 Hz","50 Hz","100 Hz","200 Hz"],"items":["\"cont\"","\"20 Hz\"","\"50 Hz\"","\"100 Hz\"","\"200 Hz\""],"label":"Controller Gains","run":"Section"}
%---
