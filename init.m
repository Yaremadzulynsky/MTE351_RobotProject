%% init.m
% Project-wide Parameters

% Robot Geometry
roCbot.mass_robot = 20;       % kg
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
% NOTE THAT THIS K AND C FOR EACH WHEEL. IF WE ASSUME THE WHEELS
% ARE IN THE SAME LOCATION ON THE ROBOT THEN WE TREAT THE 1 WHEEL
% MODEL AS A 2 WHEEL MODEL BY ASSINGING K AND C THE PARALLEL
% EQUIVILANT K AND C FROM 2 WHEELS.
susp.k = 1500;   % N/m
susp.c = 1500;    % Ns/m

world.gravity = 9.8; %m/s^2

% Load into workspace
assignin('base', 'robot', robot);
assignin('base', 'motor', motor);
assignin('base', 'susp', susp);
