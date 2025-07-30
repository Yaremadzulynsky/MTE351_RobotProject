function z = floorHeightFcn(x, y)
%#codegen
% FLOORHEIGHTFCN  Return floor height [m] at position (x,y).
% Suitable for MATLAB Function blocks (no dynamic sizing / cat / zeros).

%% ---- CONSTANTS --------------------------------------------------------
tile_pitch          = 0.3048;  % 1 ft in m
grout_width         = 0.010;   % 1 cm in m 
grout_depth         = 0.005;   % 5 mm in m
tile_surface_height = 0.0;     % set tile height to be our datum

threshold_start_x   = -1.0;    % x coordinate of door bump
threshold_length_x  = 0.05;    % bump length 5 cm in m
threshold_height    = 0.03;    % bump height 3 cm in m
threshold_y_min     = -0.5;    % doorway span in y
threshold_y_max     =  0.5;
%% -----------------------------------------------------------------------

%% ---- TILE + GROUT -----------------------------------------------------
% local coordinates inside a tile
x_mod = mod(x + tile_pitch/2, tile_pitch);
y_mod = mod(y + tile_pitch/2, tile_pitch);

% distance to nearest grout line in each axis
x_dist = min(x_mod, tile_pitch - x_mod);
y_dist = min(y_mod, tile_pitch - y_mod);

% haversine–shaped grout dips
tolerance = 5e-4;
gDipX = 0.0;
if x_dist < (grout_width/2 + tolerance)
    gDipX = grout_depth/2 * (1 + cos(2*pi*x_dist/grout_width));
end

gDipY = 0.0;
if y_dist < (grout_width/2 + tolerance)
    gDipY = grout_depth/2 * (1 + cos(2*pi*y_dist/grout_width));
end

grout_valley = max(gDipX, gDipY);          % cross‑shaped groove
z_tiles      = tile_surface_height - grout_valley;   % dips negative

%% ---- DOOR THRESHOLD bump ----------------------------------------------
if  threshold_height > 0    && ...
    x >= threshold_start_x  && x <= threshold_start_x + threshold_length_x && ...
    y >= threshold_y_min    && y <= threshold_y_max

    s_local = x - threshold_start_x;       % 0 → L
    z_bump  = threshold_height/2 * ...
              (1 - cos(2*pi*s_local/threshold_length_x));   % full‑cycle haversine
    z = tile_surface_height + z_bump;      % bump sits on flat tile
else
    z = z_tiles;                           % normal tile + grout
end
end

