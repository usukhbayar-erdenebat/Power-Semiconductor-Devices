% Super Junction MOSFET Analysis - Corrected Physics
clc; clear;

% Constants
q = 1.6e-19;       % Elementary charge [C]
eps_si = 1.0e-12;  % Permittivity of silicon [F/cm]
kT = 0.026;        % Thermal energy at 300K [eV]
ni = 1.5e10;       % Intrinsic carrier concentration [cm^-3]
mu_n = 1500;       % Electron mobility [cm^2/V-s]


%% 1. Corrected SJ Structure Design (VB=700V, V_dep=50V)
VB = 700;          % Breakdown voltage [V]
V_dep = 50;        % Depletion voltage [V]
E_crit = 2e5;      % Critical electric field [V/cm]

% Correct pillar width (lateral depletion condition)
W = (2 * sqrt(2) * V_dep) / E_crit;  % [cm]
fprintf('Corrected pillar width: %.2f μm\n', W*1e4);

% Correct doping concentration (charge balance)
ND = (2 * eps_si * V_dep) / (q * W^2);  % [cm^-3]

% Correct drift region length (SJ uniform field)
Ldrift = VB / E_crit;  % [cm]

%% 2. Corrected On-Resistance Calculation
A = 1;             % Device area [cm^2]
A_cond = A * 0.5;  % Conduction area (n-pillars)
Ron_drift = Ldrift / (q * mu_n * ND * A_cond); % [Ohm]

%% 3. Corrected Coss Calculation (Parallel-Plate Model)
%% 3. Corrected Coss Calculation (Parallel-Plate Model)
% Constants
q = 1.6e-19;                  % Electron charge (C)
eps0 = 8.854e-12;             % Vacuum permittivity (F/m)
eps_si = 11.7 * eps0;         % Silicon permittivity (F/m)
kT = 0.0258;                  % Thermal voltage at 300K (V)
ni = 1.5e10;                  % Intrinsic carrier density (cm⁻³)
ND_cm3 = 1e16;                % Doping concentration (cm⁻³)
NA_cm3 = ND_cm3;              % Balanced doping
Vbi = kT * log((ND_cm3 * NA_cm3) / ni^2); % Built-in potential (V)

% Device parameters
V_dep = 50;                   % Full depletion voltage (V)
W = 50e-6;                    % Drift region thickness (m)
A_junc = 1e-4;                % Junction area (m²) [1 cm²]
ND_m3 = ND_cm3 * 1e6;         % Convert ND to m⁻³

% SJ capacitance function (combines junction & geometric capacitance)
factor = A_junc * sqrt(q * eps_si * ND_m3) / 2;
Coss_func = @(v) (v <= V_dep) .* (factor ./ sqrt(Vbi + v)) + ...
                 (v > V_dep) .* (A_junc * eps_si / W);

% Generate Coss vs Vds data
Vds_vals = linspace(0.1, 300, 1000);   % Fine resolution for integration
Coss_vals = Coss_func(Vds_vals);      % Capacitance in Farads

% Compute Qoss(Vds) = integral of Coss over Vds
Qoss_vals = cumtrapz(Vds_vals, Coss_vals);  % Units: Coulombs

% Compute Eoss(Vds) = integral of Qoss over Vds
Eoss_vals = cumtrapz(Vds_vals, Qoss_vals);  % Units: Joules

%% Plot Coss vs Vds
figure;
plot(Vds_vals, Coss_vals * 1e9, 'LineWidth', 2);
title('SJ MOSFET: C_{oss} vs V_{ds}');
xlabel('V_{ds} [V]');
ylabel('C_{oss} [nF]');
grid on;
xline(V_dep, '--r', 'Depletion Voltage (50V)', 'LabelVerticalAlignment', 'middle');
text(100, Coss_func(100)*1e9*0.9, sprintf('C_{oss} @100V = %.3f nF', Coss_func(100)*1e9));
text(300, min(Coss_vals)*1e9*1.1, sprintf('Min C_{oss} = %.3f nF', min(Coss_vals)*1e9));
%During turn-on, the stored charge in the output capacitance is discharged through the MOSFET. 
% This stored energy becomes loss.
%% Plot Qoss vs Vds
figure;
plot(Vds_vals, Qoss_vals * 1e6, 'b', 'LineWidth', 2);
title('SJ MOSFET: Q_{oss} vs V_{ds}');
xlabel('V_{ds} [V]');
ylabel('Q_{oss} [µC]');
grid on;

%% Plot Eoss vs Vds
figure;
plot(Vds_vals, Eoss_vals * 1e6, 'm', 'LineWidth', 2);
title('SJ MOSFET: E_{oss} vs V_{ds}');
xlabel('V_{ds} [V]');
ylabel('E_{oss} [µJ]');
grid on;

%% Example Output at 300 V
V_target = 300;
[~, idx] = min(abs(Vds_vals - V_target));
fprintf('At Vds = %.0f V:\n', Vds_vals(idx));
fprintf('  Qoss = %.3f µC\n', Qoss_vals(idx) * 1e6);
fprintf('  Eoss = %.3f µJ\n', Eoss_vals(idx) * 1e6);


%% Plot Coss vs Vds
figure;
plot(Vds_vals, Coss_vals * 1e9, 'LineWidth', 2);
title('SJ MOSFET: C_{oss} vs V_{ds}');
xlabel('V_{ds} [V]');
ylabel('C_{oss} [nF]');
grid on;
xline(V_dep, '--r', 'Depletion Voltage (50V)', 'LabelVerticalAlignment', 'middle');
text(100, Coss_func(100)*1e9*0.9, sprintf('C_{oss} @100V = %.3f nF', Coss_func(100)*1e9));
text(300, min(Coss_vals)*1e9*1.1, sprintf('Min C_{oss} = %.3f nF', min(Coss_vals)*1e9));

%% Plot Qoss vs Vds
figure;
plot(Vds_vals, Qoss_vals * 1e6, 'b', 'LineWidth', 2);
title('SJ MOSFET: Q_{oss} vs V_{ds}');
xlabel('V_{ds} [V]');
ylabel('Q_{oss} [µC]');
grid on;

%% Plot Eoss vs Vds
figure;
plot(Vds_vals, Eoss_vals * 1e6, 'm', 'LineWidth', 2);
title('SJ MOSFET: E_{oss} vs V_{ds}');
xlabel('V_{ds} [V]');
ylabel('E_{oss} [µJ]');
grid on;

%% Example Output at 300 V
V_target = 300;
[~, idx] = min(abs(Vds_vals - V_target));
fprintf('At Vds = %.0f V:\n', Vds_vals(idx));
fprintf('  Qoss = %.3f µC\n', Qoss_vals(idx) * 1e6);
fprintf('  Eoss = %.3f µJ\n', Eoss_vals(idx) * 1e6);




%% 4. Vds(t) Waveform During Turn-off (Corrected Coss)
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
%line([tr*1e9, tr*1e9], [0, Voff], 'Color', 'r', 'LineStyle', '--');
%text(tr*1e9 + 2, 50, sprintf('t_r = %.2f ns', tr*1e9), 'Color', 'r');
xlim([0 max(t_vals)*1e9]/30);
ylim([0 1.1*Voff]);
hold off;

%% 5. Turn-off Energy Loss (Corrected)

% Parameters (from original code)
Voff = 300;        % DC bus voltage [V]
I0 = 10;           % Initial current [A]
tf = 100e-9;       % Current fall time [s]
t_step = 1e-11;    % Time step [s]
t_sim = 200e-9;    % Simulation duration [s]
t_vals = 0:t_step:t_sim;

% Initialize arrays
Vds = zeros(size(t_vals));
Id = zeros(size(t_vals));
P = zeros(size(t_vals));
Vds(1) = 0.1;      % Initial voltage
Id(1) = I0;        % Initial current

% Numerical integration for Vds and Id
for i = 1:length(t_vals)-1
    % Current waveform (linear fall)
    Id(i) = I0 * max(0, 1 - t_vals(i)/tf);
    
    % Voltage rise
    if Vds(i) < Voff
        dvdt = Id(i) / Coss_func(Vds(i)); % dV/dt = I(t)/Coss(Vds)
        Vds(i+1) = min(Vds(i) + dvdt * t_step, Voff);
    else
        Vds(i+1) = Voff; % Diode clamping
        Id(i+1) = 0;     % Current is zero after clamping
    end
    
    % Power at i
    P(i) = Vds(i) * Id(i);
end
% Last current point
Id(end) = I0 * max(0, 1 - t_vals(end)/tf);
P(end) = Vds(end) * Id(end);

% Calculate switching energy
E_off = sum(P) * t_step; % Energy in Joules)

% Find voltage rise time
tr_idx = find(Vds >= Voff, 1);
tr = t_vals(tr_idx);

% Plot Vds(t) and Id(t)
figure;
subplot(2,1,1);
plot(t_vals*1e9, Vds, 'b-', 'LineWidth', 1.5);
hold on;
plot(t_vals*1e9, Id, 'r-', 'LineWidth', 1.5);
xlabel('Time [ns]');
ylabel('V_{ds} [V], I_d [A]');
title('SJ MOSFET Turn-off Waveforms');
grid on;
plot(tr*1e9, Voff, 'ro', 'MarkerSize', 8);
text(tr*1e9 + 2, Voff/2, sprintf('t_r = %.1f ns', tr*1e9), 'Color', 'r');
xlim([0 150]); % Plot power
subplot(2,1,2);
plot(t_vals*1e9, P*1e6, 'k-', 'LineWidth', 1.5);
xlabel('Time [ns]');
ylabel('Power [W]');
title(sprintf('Turn-off Switching Loss: E_{off} = %.2f µJ', E_off*1e6));
grid on;
xlim([0 150]);
hold off;

% Display result
fprintf('Turn-off switching energy: %.2f µJ\n', E_off*1e6);



%% Output Corrected Results
fprintf('\nCorrected Super Junction MOSFET Analysis\n');
fprintf('=======================================\n');
fprintf('Pillar Width:                %.2f μm\n', W*1e4);
fprintf('Drift Region Length:         %.1f μm\n', Ldrift*1e4);
fprintf('N-Drift Doping (ND):         %.3e cm^{-3}\n', ND);
fprintf('Specific On-Resistance:      %.3f mΩ·cm²\n', Ron_drift*1e3);
fprintf('Voltage Rise Time (t_r):     %.2f ns\n', tr*1e9);
fprintf('Peak dV/dt:                 %.0f V/ns\n', I0/Coss_func(0.1)/1e9);
%fprintf('Turn-off Energy Loss:        %.3f μJ\n', Eoff_total*1e6);
%fprintf('  - Capacitive Charging:     %.3f μJ\n', E_rise*1e6);
%fprintf('  - Current Fall:            %.3f μJ\n', E_fall*1e6);