Visualisation
The following script plots a visualisation of the N-rotor vehicle design:
N-rotor vehicle visualisation script
The following script plots a visualisation of trajectory simulated by the Simulink model:
Trajectory visualisation script
To use the trajectory visualisation script, first compile and run the Simulink model, then enter either of the following commands in the Matlab Command Window:

>> traj_handles = visualise_nrotor_trajectory( simout_full_state )
>> traj_handles = visualise_nrotor_trajectory( simout_full_state , [] , nrotor_vehicle_layout_true )

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright"}
%---
