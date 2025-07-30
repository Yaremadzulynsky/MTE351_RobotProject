function z_vals = evaluateSuspension(params)

    susp = evalin('base', 'susp');
    susp.k = params(1);
    susp.c = params(2);

    v = params(3);
    t = linspace(0, 33/v, 1000); % s (timescale of 0 to 33/v s with 1000 even-spaced divisions
    x = interp1([0 15 25 33]/v, [0 -15 -15 -7], t); % m (linearly interpolated x coordinates of the robot's full path)
    y = interp1([0 15 25 33]/v, [0 0 10 10], t); % m (linearly interpolated y coordinates of the robot's full path)
    
    %Signals for x- and y-coordinates over time, to be fed into floorHeightFcn
    %to obtain z-coordinates for every point on the robot's path
    x_sig = timeseries(x, t);
    y_sig = timeseries(y, t);

    % Update suspension and velocity parameters in the base workspace
    assignin('base', 'susp', susp);
    assignin('base', 'v', v);
    assignin('base', 'x_sig', x_sig);
    assignin('base', 'y_sig', y_sig);

    payloads = [0.15, 10];
    z_vals = zeros(size(payloads));
    for i = 1:length(payloads)
        robot = evalin('base', 'robot');
        robot.mass_payload = payloads(i);
        assignin('base', 'robot', robot);

        % Run simulation
        simOut = sim('SimulinkModels\wheelSuspension.slx', 'SimulationMode', 'normal', 'ReturnWorkspaceOutputs', 'on');
    
        % Extract z displacement from logs
        X2 = simOut.logsout.get('X2').Values.Data;
        z_vals(i) = max(abs(X2));  % Worst-case scenario
    end
end

function [c, ceq] = zConstraint(params)
    z_vals = evaluateSuspension(params);

    c = z_vals - 0.005;  % z must be less than or equal to 0.005
    ceq = [];
end

run('init.m');

% Initial guess [k, c]
x0 = [susp.k, susp.c, v];

% Lower and upper bounds
lb = [100, 1, 0.5];
ub = [75000, 1000, 50];

% Optimization options
opts = optimoptions('fmincon','Display','iter','Algorithm','sqp');

% Run optimization
% [x_opt, fval] = fmincon(@(x) evaluateSuspension(x), x0, [], [], [], [], lb, ub, @zConstraint, opts);
problem = createOptimProblem('fmincon', ...
    'x0', x0, 'objective', @(x) max(evaluateSuspension(x)), ...
    'lb', lb, 'ub', ub, 'nonlcon', @zConstraint, ...
    'options', opts);

ms = MultiStart('Display', 'iter', 'UseParallel', true);
[x_best, fval_best, exitflag, output, solutions] = run(ms, problem, 5);  % 20 starting points for high accuracy

numSols = numel(solutions);
results = table('Size', [numSols 4], ...
                'VariableTypes', {'double', 'double', 'double', 'double'}, ...
                'VariableNames', {'k', 'c', 'v', 'MaxZ'});

for i = 1:numSols
    results.k(i)    = solutions(i).X(1);
    results.c(i)    = solutions(i).X(2);
    results.v(i)    = solutions(i).X(3);
    results.MaxZ(i) = solutions(i).Fval;
end

results.MaxZ = round(results.MaxZ, 6);
results = sortrows(results, 'MaxZ');
disp(results)

% k_values = linspace(100, 10000, 20);
% c_values = linspace(1, 500, 20);
% feasible_points = [];
% 
% for k = k_values
%     for c = c_values
%         z = evaluateSuspension([k,c]);
%         if all(z <= 0.005)
%             feasible_points = [feasible_points; k, c, max(z)];
%         end
%     end
% end
% 
% disp(feasible_points);