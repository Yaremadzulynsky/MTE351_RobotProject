function [t_full, V_L_full, V_R_full] = generateVoltageCommands(segments, params)
  % Unpack your params for clarity
  dt    = 0.01;
  ke    = params.motor.k_e;
  r     = params.r;

  % 1) INIT — everything empty
  t_full    = [];
  V_L_full  = [];
  V_R_full  = [];
  t_offset  = 0;

  % 2) LOOP over segments
  for i = 1:numel(segments)
    seg = segments{i};

    switch seg.type
      case 'drive'
        [t_seg, v_prof] = trapezoidProfile(seg.distance, ...
                                          params.v_cruise, params.a_lin, dt);
        vL = v_prof;
        vR = v_prof;

      case 'spin'
        [t_seg, omega_prof] = trapezoidProfile(seg.angle, ...
                                               params.omega_cruise, params.a_ang, dt);
        vL = -omega_prof * r;
        vR =  +omega_prof * r;
    end

    % 3) MOTOR VOLTAGES (neglecting dynamic torque for simplicity)
    wL = vL / r;
    wR = vR / r;
    V_L = ke * wL;
    V_R = ke * wR;

    % 4) STITCH into the big vectors
    t_full    = [t_full;    t_offset + t_seg];
    V_L_full  = [V_L_full;  V_L(:)];
    V_R_full  = [V_R_full;  V_R(:)];
    t_offset  = t_full(end);
  end
end

function [t, x_prof] = trapezoidProfile(D, Xc, a, dt)
% Build a (triangular or trapezoidal) profile over magnitude |D|, then
% re-apply the original sign so that negative D still gives a negative ramp.

  % 1) capture the sign, work with positive distance
  sgn  = sign(D);
  Dabs = abs(D);

  % 2) compute accel distance & time
  t_acc = Xc / a;
  d_acc = 0.5 * a * t_acc^2;

  if Dabs > 2*d_acc
    % trapezoid: accel → cruise → decel
    t_cruise = (Dabs - 2*d_acc) / Xc;
    T        = 2*t_acc + t_cruise;
    t        = (0:dt:T)';         % guaranteed real scalar endpoints

    x_prof = zeros(size(t));
    for k = 1:length(t)
      tk = t(k);
      if     tk < t_acc
        x_prof(k) = 0.5 * a * tk;
      elseif tk < t_acc + t_cruise
        x_prof(k) = Xc;
      else
        td         = tk - (t_acc + t_cruise);
        x_prof(k) = Xc - 0.5 * a * td;
      end
    end

  else
    % triangular: accel to a peak, then decel
    Xp      = sqrt(a * Dabs);
    t_acc   = Xp / a;
    T       = 2 * t_acc;
    t       = (0:dt:T)';

    x_prof = zeros(size(t));
    for k = 1:length(t)
      tk = t(k);
      if tk < t_acc
        x_prof(k) = a * tk;
      else
        td         = tk - t_acc;
        x_prof(k) = Xp - a * td;
      end
    end
  end

  % 3) now re-apply the original sign
  x_prof = sgn * x_prof;
end
