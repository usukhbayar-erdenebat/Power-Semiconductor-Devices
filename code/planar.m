% Semiconductor Physics and Power Device Equations in MATLAB
% Constants
q = 1.6e-19;       % Elementary charge [C]
eps_si = 1.0e-12;  % Permittivity of silicon [F/cm]
kT = 0.026;        % Thermal energy at 300K [eV]
ni = 1.5e10;       % Intrinsic carrier concentration [cm^-3]
mu_n = 1500;       % Electron mobility [cm^2/V-s]
mu_p = 500;        % Hole mobility [cm^2/V-s]
VB = 700;          % Breakdown voltage [V]
E_crit = 2e5;      % Critical electric field [V/cm] (assumed typical value)

%% 1. Design doping concentration of N drift region (for VB = 700V)
% Doping concentration from breakdown voltage
ND = E_crit^2 * eps_si / (2 * q * VB); % [cm^-3]

%% 2. Calculate on-resistance for 1 cm^2 area
A = 1;             % [cm^2], device area
Ldrift = 2 * VB / E_crit; % Drift region length [cm]
Ron_drift = Ldrift / (q * mu_n * ND * A); % [Ohm]

%% 3. Calculate CGD and CDS from physical parameters and plot Coss = CGD + CDS
A_junc = 1;     % [cm^2], assumed gate/drain overlap area
NA = 1e17;         % [cm^-3], assumed P-well doping
Vbi = kT * log((ND * NA) / ni^2); % Built-in potential [V]

Vds_vals = linspace(0.1, 1000, 1000); % Avoid division by zero
Cgd_vals = eps_si * A_junc ./ sqrt(2 * q * ND * (Vbi + Vds_vals));
Cds_vals = eps_si * A_junc ./ sqrt(2 * q * ND * (Vbi + Vds_vals));
Coss_vals = Cgd_vals + Cds_vals;

% Plot Coss vs Vds
% Plot Coss vs Vds in nF
figure;
plot(Vds_vals, Coss_vals * 1e9);  % Convert to nF
title('Coss = CGD + CDS vs Vds');
xlabel('Vds [V]');
ylabel('Coss [nF]');  % Updated y-axis label
grid on;


%% 4. Calculate Vds(t) waveform during turn-off
Voff = 300;        % DC bus voltage [V]
I0 = 10;           % Initial current [A]
tf = 100e-9;       % Current fall time [s]
L = 100e-6;        % Load inductance [H]

% Define Coss function (using analytical expression)
Coss_func = @(v) 2 * eps_si * A_junc ./ sqrt(2 * q * ND * (Vbi + v));

% Time calculation for voltage rise (0 → Voff)
V_rise = linspace(0, Voff, 500); % Voltage points
t_rise = zeros(size(V_rise));     % Time vector initialization
for i = 2:length(V_rise)
    v_prev = V_rise(i-1);
    v_curr = V_rise(i);
    C_avg = (Coss_func(v_prev) + Coss_func(v_curr))/2;
    dt = (C_avg / I0) * (v_curr - v_prev);
    t_rise(i) = t_rise(i-1) + dt;
end
tr = t_rise(end);  % Total voltage rise time

% Construct full waveform
t1 = linspace(0, tr, 500);        % Voltage rise period
t2 = linspace(tr, tr + tf, 500);  % Current fall period
t_full = [t1, t2(2:end)];         % Combined time vector

% Voltage waveform components
Vds_rise = interp1(t_rise, V_rise, t1); % Rising voltage
Vds_full = [Vds_rise, Voff*ones(1,length(t2)-1)]; % Clamped voltage

% Plot Vds(t)
figure;
plot(t_full * 1e9, Vds_full, 'LineWidth', 1.5);
title('Vds during Turn-Off with Ideal Diode');
xlabel('Time [ns]');
ylabel('Vds [V]');
grid on;
xlim([0, max(t_full)*1e9]/30);
ylim([0, 1.1*Voff]);

%% 5. Calculate turn-off energy loss
% Energy during voltage rise (E_rise = ∫Vds·I0·dt)
E_rise = I0 * trapz(t1, Vds_rise);

% Energy during current fall (E_fall = 0.5·Voff·I0·tf)
E_fall = 0.5 * Voff * I0 * tf;

% Total turn-off energy loss
Eoff_total = E_rise + E_fall;

%% Output Results
fprintf('Semiconductor Device Analysis Results:\n');
fprintf('------------------------------------\n');
fprintf('Built-in Potential (Vbi)     = %.3f V\n', Vbi);
fprintf('1. N-drift Doping (ND)       = %.3e cm^{-3}\n', ND);
fprintf('2. Specific On-Resistance    = %.3f mΩ·cm²\n', Ron_drift*1e3);
fprintf('3. Coss(100V)                = %.3f nF\n', Coss_func(10)*1e9);
fprintf('4. Voltage Rise Time (tr)    = %.3f ns\n', tr*1e9);
fprintf('5. Turn-off Energy Loss      = %.3f μJ\n', Eoff_total*1e6);