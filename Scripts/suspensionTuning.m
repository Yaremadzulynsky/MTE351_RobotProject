function z_vals = evaluateSuspension(params)

    susp = evalin('base', 'susp');
    susp.k = params(1);
    susp.c = params(2);

    % Update suspension parameters in the base workspace
    assignin('base', 'susp', susp);

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

    c = z_vals - 0.05;  % z must be less than or equal to 0.005
    ceq = [];
end

run('init.m');

% Initial guess [k, c]
x0 = [susp.k, susp.c];

% Lower and upper bounds
lb = [100, 1];
ub = [10000, 500];

% Optimization options
opts = optimoptions('fmincon','Display','iter','Algorithm','sqp');

% Run optimization
% [x_opt, fval] = fmincon(@(x) evaluateSuspension(x), x0, [], [], [], [], lb, ub, @zConstraint, opts);
problem = createOptimProblem('fmincon', ...
    'x0', x0, 'objective', @(x) max(evaluateSuspension(x)), ...
    'lb', lb, 'ub', ub, 'nonlcon', @zConstraint, ...
    'options', opts);

ms = MultiStart('Display', 'iter', 'UseParallel', true);
[x_best, fval_best, exitflag, output, solutions] = run(ms, problem, 20);  % 20 starting points for high accuracy

numSols = numel(solutions);
results = table('Size', [numSols 3], ...
                'VariableTypes', {'double', 'double', 'double'}, ...
                'VariableNames', {'k', 'c', 'MaxZ'});

for i = 1:numSols
    results.k(i)    = solutions(i).X(1);
    results.c(i)    = solutions(i).X(2);
    results.MaxZ(i) = solutions(i).Fval;
end

results.MaxZ = round(results.MaxZ, 6);
results = sortrows(results, 'MaxZ');
disp(results)