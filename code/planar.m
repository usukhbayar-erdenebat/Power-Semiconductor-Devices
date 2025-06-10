% Semiconductor Physics and Power Device Equations in MATLAB
% Constants
clc;
clear;


q = 1.6e-19;       % Elementary charge [C]
eps_si = 1.0e-12;  % Permittivity of silicon [F/cm]
kT = 0.026;        % Thermal energy at 300K [eV]
ni = 1.5e10;       % Intrinsic carrier concentration [cm^-3]
mu_n = 1500;       % Electron mobility [cm^2/V-s]
mu_p = 500;        % Hole mobility [cm^2/V-s]
VB = 700;          % Breakdown voltage [V]
E_crit = 2e5;      % Critical electric field [V/cm] (assumed typical value)
V_dc = 300;        % DC bus voltage [V]
I0 = 10;           % Initial current [A]
A = 1;             % [cm^2], device area
A_junc = 1;
%% 1. Design doping concentration of N drift region (for VB = 700V)
% Doping concentration from breakdown voltage
ND = E_crit^2 * eps_si / (2 * q * VB); % [cm^-3]

%% 2. Calculate on-resistance for 1 cm^2 area
            
Rdrift = (4* VB^2)/(mu_n * eps_si * E_crit^3); %[Ohm]

Ldrift = 2 * VB / E_crit; % Drift region length [cm]
Ron_drift = Ldrift / (q * mu_n * ND * A); % [Ohm]

%% 3. Calculate CGD and CDS from physical parameters and plot Coss = CGD + CDS
NA = ND; % assuming symmetric doping for this model
Vbi = kT * log((ND*NA) / ni^2); % Built-in voltage [V]
%assume that Nd and Na are same.
% Vds sweep
Vds_vals = linspace(1, V_dc, 1000); % Avoid V=0

% Compute depletion width and capacitance
W_vals = sqrt((2 * eps_si * (Vbi + Vds_vals)) / (q * ND));

Cds_vals = eps_si * A ./ W_vals;
Coss_vals = Cds_vals;

% Plot
figure;
plot(Vds_vals, Coss_vals * 1e9);  % Convert to nF
title('C_{oss} vs V_{DS}');
xlabel('V_{DS} [V]');
ylabel('C_{oss} [nF]');
grid on;

%% 4. Calculate Vds(t) waveform during turn-off
% Time domain setup
dt = 1e-9;                        % Time step [s]
t_max = 100e-9;                   % Simulation time [s]
time = 0:dt:t_max;              

% Initialize
Vds_t = zeros(size(time));       % Vds over time [V]
Vds_t(1) = 1;                     % Start from Vds = 1V
Vds_max = V_dc;                  % Final Vds

% Precompute Coss(Vds) as a function
Vds_lookup = linspace(1, V_dc, 1000);
W_lookup = sqrt((2 * eps_si * (Vbi + Vds_lookup)) / (q * ND));
Coss_lookup = eps_si * A ./ W_lookup;

% Interpolant function for Coss(Vds)
Coss_func = @(v) interp1(Vds_lookup, Coss_lookup, v, 'linear', 'extrap');

% Time integration
for i = 2:length(time)
    C_now = Coss_func(Vds_t(i-1));              % Capacitance at current Vds
    dV = (I0 / C_now) * dt;                     % ΔV from I = C dV/dt
    Vds_t(i) = Vds_t(i-1) + dV;                 % Integrate
    if Vds_t(i) >= Vds_max                      % Stop if exceeds max
        Vds_t(i:end) = Vds_max;
        break;
    end
end

% Plot
figure;
plot(time * 1e9, Vds_t, 'LineWidth', 2);
title('V_{DS}(t) During Turn-Off');
xlabel('Time [ns]');
ylabel('V_{DS} [V]');
grid on;


%% 5. Calculate turn-off energy loss
% Energy during current fall (E_fall = 0.5·Voff·I0·tf)

V_start = 1;
V_end = V_dc;

% Find indices
idx_start = find(Vds_t >= V_start, 1, 'first');
idx_end = find(Vds_t >= V_end, 1, 'first');

% Calculate tf
tf = (idx_end - idx_start) * dt; % [s]


E_fall = 0.5 * V_dc * I0 * tf;

% Total turn-off energy loss
Eoff_total = E_fall;

%% Output Results
fprintf('Semiconductor Device Analysis Results:\n');
fprintf('------------------------------------\n');
fprintf('Built-in Potential (Vbi)     = %.3f V\n', Vbi);
fprintf('1. N-drift Doping (ND)       = %.3e cm^{-3}\n', ND);
fprintf('2. On-Resistance Ron   = %.3f mΩ·cm²\n', Ron_drift*1e3);
fprintf('2. On-Resistance Rdrift   = %.3f mΩ·cm²\n', Rdrift*1e3);
fprintf('3. Coss(100V)                = %.3f nF\n', Coss_func(100)*1e9);
%fprintf('4. Voltage Fall Time (tf)    = %.3f ns\n', tf*1e9);
fprintf('5. Turn-off Energy Loss      = %.3f μJ\n', Eoff_total*1e6);