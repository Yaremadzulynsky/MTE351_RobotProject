%% init.m
% Project-wide Parameters

% Robot Geometry
robot.mass_robot = 20;       % kg
robot.mass_payload = 10;     % kg
robot.height = 5;            % m
robot.diameter = 0.5;        % m
robot.wheel_radius = 0.05;   % m
robot.gear_ratio = 10;

% Motor Parameters (initial guesses or from datasheet)
motor.R = 1.2;       % Ohm
motor.L = 0.5e-3;    % H
motor.Kt = 0.1;      % Nm/A
motor.Ke = 0.1;      % V/(rad/s)

% Suspension parameters (tunable in Task 5)
susp.k = 9.8*30;   % N/m
susp.c = 1;    % Ns/m

world.gravity = 9.8; %m/s^2

% Load into workspace
assignin('base', 'robot', robot);
assignin('base', 'motor', motor);
assignin('base', 'susp', susp);

https://ethz.ch/content/dam/ethz/special-interest/mavt/dynamic-systems-n-control/idsc-dam/Lectures/amod/AMOD_2020/20201019-02%20-%20ETHZ%20-%20Modeling.pdf