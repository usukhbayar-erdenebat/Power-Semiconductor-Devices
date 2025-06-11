% Super Junction MOSFET Analysis with Corrected Pillar Design
% Constants
q = 1.6e-19;       % Elementary charge [C]
eps_si = 1.0e-12;  % Permittivity of silicon [F/cm]
kT = 0.026;        % Thermal energy at 300K [eV]
ni = 1.5e10;       % Intrinsic carrier concentration [cm^-3]
mu_n = 1500;       % Electron mobility [cm^2/V-s]

%% 1. Design SJ Structure for VB=700V with depletion at 50V
VB = 700;          % Breakdown voltage [V]
V_dep = 50;        % Depletion voltage [V]
E_crit = 2e5;      % Critical electric field [V/cm]

% Calculate pillar width from triangle equations
W = sqrt((4 * sqrt(2) * V_dep) / E_crit);  % [cm]
fprintf('Calculated pillar width: %.2f μm\n', W*1e4);

% Calculate doping concentration
E_peak = (W * E_crit) / (2 * sqrt(2));
ND = (4 * eps_si * E_peak) / (q * W);  % [cm^-3]

% Drift region length (conventional MOSFET relation)
Ldrift = sqrt(2) * VB / E_crit;  % [cm]

%% 2. Calculate on-resistance for 1 cm² area
A = 1;             % Device area [cm^2]
A_cond = A * 0.5;  % Conduction area (only n-pillars)
Ron_drift = Ldrift / (q * mu_n * ND * A_cond); % [Ohm]

%% 3. Calculate Coss (CGD+CDS) for SJ MOSFET
A_junc = 1;        % Junction area [cm^2]
NA = ND;           % Balanced doping for SJ pillars
Vbi = kT * log((ND * NA) / ni^2); % Built-in potential [V]

% SJ capacitance function
Coss_func = @(v) (v <= V_dep) .* (A_junc * sqrt(q * eps_si * ND) ./ (2 * sqrt(Vbi + v))) + ...
                 (v > V_dep) .* (A_junc * eps_si / W);

% Generate Coss vs Vds plot
Vds_vals = linspace(0.1, 300, 300);
Coss_vals = Coss_func(Vds_vals);

figure;
plot(Vds_vals, Coss_vals * 1e9, 'LineWidth', 2);
title('SJ MOSFET: C_{oss} vs V_{ds}');
xlabel('V_{ds} [V]');
ylabel('C_{oss} [nF]');
grid on;
hold on;
xline(V_dep, '--r', 'Depletion Voltage (50V)', 'LabelVerticalAlignment', 'middle');
text(100, Coss_vals(100)*1e9*0.9, sprintf('C_{oss} @100V = %.3f nF', Coss_func(100)*1e9));
text(300, Coss_vals(end)*1e9*1.1, sprintf('Min C_{oss} = %.3f nF', min(Coss_vals)*1e9));
hold off;

%% 4. Calculate Vds(t) waveform during turn-off
Voff = 300;        % DC bus voltage [V]
I0 = 10;           % Initial current [A]
tf = 100e-9;       % Current fall time [s]

% Time parameters
t_step = 1e-11;    % Smaller time step for accuracy (100 ps)
t_sim = 200e-9;    % Simulation duration [s]
t_vals = 0:t_step:t_sim;

% Initialize arrays
Vds = zeros(size(t_vals));
Vds(1) = 0.1;      % Initial voltage

% Numerical integration for voltage rise
for i = 1:length(t_vals)-1
    if Vds(i) < Voff
        dvdt = I0 / Coss_func(Vds(i));
        Vds(i+1) = min(Vds(i) + dvdt * t_step, Voff);
    else
        Vds(i+1) = Voff;  % Diode clamping
    end
end

% Find voltage rise time
tr_idx = find(Vds >= Voff, 1);
tr = t_vals(tr_idx);

% Plot Vds(t)
figure;
plot(t_vals * 1e9, Vds, 'LineWidth', 1.5);
title('SJ MOSFET Turn-off Waveform');
xlabel('Time [ns]');
ylabel('V_{ds} [V]');
grid on;
hold on;
plot(tr * 1e9, Voff, 'ro', 'MarkerSize', 8);
line([tr*1e9, tr*1e9], [0, Voff], 'Color', 'r', 'LineStyle', '--');
text(tr*1e9 + 2, 50, sprintf('t_r = %.2f ns', tr*1e9), 'Color', 'r');
xlim([0 max(t_vals)*1e9]/30);
ylim([0 1.1*Voff]);
hold off;

%% 5. Calculate turn-off energy loss



%% Output Results
fprintf('\nSuper Junction MOSFET Analysis\n');
fprintf('==============================\n');
fprintf('Pillar Width (calculated):   %.2f μm\n', W*1e4);
fprintf('Drift Region Length:         %.1f μm\n', Ldrift*1e4);
fprintf('N-Drift Doping (ND):         %.3e cm^{-3}\n', ND);
fprintf('Specific On-Resistance:      %.3f mΩ·cm²\n', Ron_drift*1e3);
fprintf('Voltage Rise Time (t_r):     %.2f ns\n', tr*1e9);
fprintf('Peak dV/dt:                 %.0f V/ns\n', I0/Coss_func(0.1)/1e9);
fprintf('Turn-off Energy Loss:        %.3f μJ\n', Eoff_total*1e6);
fprintf('  - Capacitive Charging:     %.3f μJ\n', E_rise*1e6);
fprintf('  - Current Fall:            %.3f μJ\n', E_fall*1e6);