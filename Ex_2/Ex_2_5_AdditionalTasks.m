%[text] ## 2.5 Additional Task: Measurement noise
%[text] Measurements of the vehicle's state are always corrupted by some level of noise. Add zeromean Gaussian (white) noise to each of the states separately.
%[text] - This is implemented most easily by using the "Random Number" block (found in the "Sources" category) in Simulink to inject a vector with independent samples.
%[text] - The measurement noise should be added in a manner that allows you to quickly select between simulating the vehicle with and without noise. \
%[text] ```
%[text] Provide your solution in the Simulink Model. Feel free to run the model via the app to visualize the results.
%[text] ```
%[text] How is the step change tracking performance affected by the amplitude of the added noise? Is the vehicle's performance more sensitive to noise on particular measurements?
%[text] Is zero-mean white noise a realistic assumption? What other types of noise might exist for particular measurements.
%[text] ```
%[text] Write your answer here...
%[text] ```
%[text] 
%%
%[text] ## 2.6 Additional Task: thrust-to-command conversion
%[text] Thus far the controller has requested a particular thrust from the propellers of our N-rotor vehicle. However, in reality on the Crazyflie 2.0 hardware we will use for the experiments, the micro-controller sends an integer command in the range \[0 - 65535\], where 0 is zero-thrust, and 65535 is full-thrust. Add to the controller a conversion from force requested to this integer command, and add to the N-rotor vehicle model the conversion from this integer command to thrust produced by the respective propeller.
%[text] - For the propellers used on the Crazyflie 2.0, this static \\integer command -to- thrust" conversion was identified as: thrust $\\mathrm{thrust \[N\] = thrust\_{max} ( 1.3385\\cdot 10^{-10} \\ cmd^2 + 6.4879\\cdot 10^{-6} \\ cmd)}$ where cmd is the integer command in the range \[0 - 65535\], and thrust\_{max} is the maximum thrust in Newtons produced by the propeller at cmd = 65535.
%[text] - The purpose of including this conversion in the simulation is so that the simulated controller architecture and tuning matches that of the real-world system. \
%[text] ```
%[text] to be implemented in Simulink...
%[text] ```
%[text] 

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
