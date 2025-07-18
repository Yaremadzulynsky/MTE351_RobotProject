% runTask7_8.m
clear; clc;

%% 1) Define the key poses [x, y, θ]
%   Start at (0,0), face π (West), then
poses = [
   0,   0, pi;     % P0: kitchen start
 -15,   0, pi/2;  % P1: spin  90° to face North
 -15,  10,  0;    % P2: spin −90° to face East
  -7,  10,  0     % P3: table, facing East
];

%% 2) Task 7: build segments automatically
segments = definePlanarPath(poses);

%% 3) Task 8: generate voltages
params.v_cruise     = 0.5;    % m/s
params.a_lin        = 0.2;    % m/s²
params.omega_cruise = pi/4;   % rad/s
params.a_ang        = pi/8;   % rad/s²
params.r            = 0.05;   % wheel radius (m)
params.motor.R      = 2;      % Ω
params.motor.k_e    = 0.02;   % V/(rad/s)
params.motor.k_t    = 0.02;   % N·m/A

[t_full, V_L, V_R] = generateVoltageCommands(segments, params);
disp('length(t_full):'), disp(length(t_full))
disp('length(V_L):'),    disp(length(V_L))
disp('length(V_R):'),    disp(length(V_R))


%% 4) Plot results
figure;
subplot(2,1,1), plot(t_full, V_L), ylabel('V_L (V)'), grid on
subplot(2,1,2), plot(t_full, V_R), ylabel('V_R (V)'), xlabel('Time (s)'), grid on
sgtitle('Task 8 Voltages from Task 7 Path')