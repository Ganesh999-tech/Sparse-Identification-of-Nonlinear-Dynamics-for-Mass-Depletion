%% HIGH-ACCURACY AIRCRAFT MASS IDENTIFICATION
clear; clc; close all;

%% 1. DATA GENERATION (Increased duration for better slope detection)
t = (0:0.1:3600)';           % 1 hour flight for better depletion visibility
m_initial = 60000;
g = 9.81;
fuel_flow = 1.2;             % Slightly higher fuel flow (1.2 kg/s)
m_true = m_initial - (fuel_flow * t);

Thrust = 130000 + 30000*sin(0.01*t); 
gamma = deg2rad(3 + 1*cos(0.005*t)); 
v = 180 + 0.02*t; 
k_drag = 0.12; 

% Acceleration with subtle mass depletion
a_pure = (Thrust - (k_drag * v.^2) - (m_true .* g .* sin(gamma))) ./ m_true;
% Standard IMU noise
a_measured = a_pure + 0.005*randn(size(t)); 

%% 2. SENSITIVITY-ENHANCED SINDy
% Larger window is CRITICAL for seeing mass change vs noise
window_size = 4000; 
step = 50; 
idx_range = 1:step:(length(t) - window_size);
identified_mass = zeros(length(idx_range), 1);
time_axis = zeros(length(idx_range), 1);

for i = 1:length(idx_range)
    curr_idx = idx_range(i);
    w_idx = curr_idx : (curr_idx + window_size);
    
    % Target: Accelerometer + Gravity Compensation
    % We apply a local smoothing filter inside the window
    Y = smoothdata(a_measured(w_idx), 'gaussian', 100) + g*sin(gamma(w_idx));
    
    % Library
    Theta = [Thrust(w_idx), -v(w_idx).^2];
    
    % Solver
    Xi = Theta \ Y;
    identified_mass(i) = 1 / Xi(1);
    time_axis(i) = t(w_idx(end));
end

%% 3. RESULTS & METRICS
% Use a linear fit on the identified mass to find the "Rate of Burn"
p = polyfit(time_axis, identified_mass, 1);
final_mass_estimate = p(1)*time_axis(end) + p(2);
estimated_burn = identified_mass(1) - final_mass_estimate;
actual_burn = m_true(1) - m_true(round(time_axis(end)*10));

accuracy = 100 * (1 - abs(actual_burn - estimated_burn)/actual_burn);

fprintf('Initial Identified Mass: %.2f kg\n', identified_mass(1));
fprintf('Actual Fuel Burned: %.2f kg\n', actual_burn);
fprintf('SINDy Estimated Burn (Trend-based): %.2f kg\n', estimated_burn);
fprintf('Model Accuracy: %.2f%%\n', accuracy);

%% 4. PLOT
plot(t, m_true, 'k', 'LineWidth', 2); hold on;
plot(time_axis, identified_mass, 'r.', 'MarkerSize', 2);
plot(time_axis, polyval(p, time_axis), 'b', 'LineWidth', 2);
grid on; ylabel('Mass (kg)'); xlabel('Time (s)');
legend('True Mass', 'Raw SINDy Points', 'SINDy Trend-line');
title('High-Sensitivity Mass Depletion Tracking');