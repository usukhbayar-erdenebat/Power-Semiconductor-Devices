% Semiconductor Physics and Power Device Equations in MATLAB

clc; clear;

%% Constants
q = 1.6e-19;       % Elementary charge [C]
eps_si = 1.0e-12;  % Permittivity of silicon [F/cm]
kT = 0.026;        % Thermal energy at 300K [eV]
ni = 1.5e10;       % Intrinsic carrier concentration [cm^-3]
mu_n = 1500;       % Electron mobility [cm^2/V-s]
mu_p = 500;        % Hole mobility [cm^2/V-s]
VB = 700;          % Breakdown voltage [V]
E_crit = 2e5;      % Critical electric field [V/cm]
V_dc = 300;        % DC bus voltage [V]
I0 = 10;           % Initial current [A]
A = 1;             % Area [cm^2]

%% 1. N-drift region doping concentration (corrected)
Nd = (eps_si * E_crit^2) / (2 * q * VB);  % [cm^-3]
fprintf('1. N-drift doping concentration: %.2e cm^-3\n', Nd);

%% 2. On-resistance using direct analytical formula
R_on = (4 * VB^2) / (mu_n * eps_si * E_crit^3);  % [Ohm-cm^2]
fprintf('2. On-resistance R_on (specific): %.4f Ohm-cm^2\n', R_on);
R_on_total = R_on / A;  % Area-specific to absolute value
fprintf('   Total R_on for 1 cm^2: %.4f Ohms\n', R_on_total);


%% 3. Coss (Cgd + Cds) as a function of Vds
L = 2 * VB / E_crit;
Vds = linspace(0.1, VB, 1000);  % Avoid divide-by-zero
C0 = eps_si * A / L;            % Capacitance at V=0
Coss = C0 ./ sqrt(1 + Vds / VB);

figure;
plot(Vds, Coss * 1e12);
xlabel('V_{DS} (V)');
ylabel('C_{oss} (pF)');
title('3. Voltage-dependent Output Capacitance C_{oss}(V)');
grid on;


%% 4. Turn-off waveform Vds(t) under inductive load

% Voltage range from 0 to V_dc
Vds = linspace(0.1, V_dc, 1000);  % Avoid V=0 to prevent singularity
C0 = eps_si * A / L;              % Capacitance at V=0
Coss = C0 ./ sqrt(1 + Vds / VB);  % Voltage-dependent output capacitance

% Time increment dt = C(V) * dV / I0
dV = Vds(2) - Vds(1);
dt = (Coss .* dV) / I0;
t = cumsum(dt);  % Cumulative time = integral of dt

% Plot Vds vs time
figure;
plot(t * 1e9, Vds);
xlabel('Time (ns)');
ylabel('V_{DS} (V)');
title('4. Turn-off waveform V_{DS}(t) under inductive load');
grid on;

% Print total rise time
t_rise = t(end);
fprintf('4. Total Vds rise time: %.2f ns\n', t_rise * 1e9);


%% 5. Turn-off loss (energy)
% E_off = 0.5 * Vdc * I0 * t_off
E_off = 0.5 * V_dc * I0 * t_off;  % [J]
fprintf('5. Turn-off energy loss: %.2e J\n', E_off);
