% definePlanarPath.m
function segments = definePlanarPath(poses)
% DEFINEPLANARPATH  Turn a list of poses [x,y,θ] into drive/spin segments
%   poses: N×3 array, each row [x (m), y (m), θ (rad) desired after spin]
%   segments: 1×M cell array of structs with fields
%       .type     = 'drive' or 'spin'
%       .distance = (for drive) meters
%       .heading  = (for drive) radians
%       .angle    = (for spin) radians

  N = size(poses,1);
  segments = {};
  idx = 1;
  
  for i = 1:N-1
    % --- 1) DRIVE from pose i to i+1 ---
    x0 = poses(i,1);   y0 = poses(i,2);
    x1 = poses(i+1,1); y1 = poses(i+1,2);
    dx = x1 - x0;  dy = y1 - y0;
    d  = hypot(dx, dy);
    hd = atan2(dy, dx);
    
    segments{idx} = struct( ...
      'type',     'drive', ...
      'distance', d, ...
      'heading',  hd     ...
    );
    idx = idx + 1;
    
    % --- 2) SPIN to align with desired θ at pose i+1 (unless it's the last) ---
    if i+1 < N
      desiredTheta = poses(i+1,3);
      delta = desiredTheta - hd;
      % wrap to [-π, π]
      delta = mod(delta + pi, 2*pi) - pi;
      
      segments{idx} = struct( ...
        'type',  'spin', ...
        'angle', delta   ...
      );
      idx = idx + 1;
    end
  end
end
