% Super Junction MOSFET Coss Model
clc; clear;

% Constants
eps_si = 1.0e-12;  % Permittivity [F/cm]
q = 1.6e-19;       % Elementary charge [C]

% Device Parameters (Corrected Physics)
V_dep = 50;         % Full depletion voltage [V]
E_crit = 2e5;       % Critical field [V/cm]
A_junc = 1;         % Junction area [cm²]

% Pillar design (corrected equations)
W = (2*sqrt(2)*V_dep)/E_crit;       % Pillar width [cm]
W_um = W * 1e4;                     % Convert to μm
ND = (2*eps_si*V_dep)/(q*W^2);     % Doping [cm⁻³]

fprintf('Pillar width = %.2f μm\n', W_um);
fprintf('Doping concentration = %.2e cm⁻³\n', ND);

% Coss Calculation
Vdc = linspace(0.1, 500, 1000);    % Voltage range [V]
Coss = zeros(size(Vdc));             % Initialize capacitance

for i = 1:length(Vdc)
    if Vdc(i) <= V_dep
        % Partial depletion regime
        x_d = W * sqrt(Vdc(i)/V_dep);
    else
        % Full depletion regime
        x_d = W;
    end
    Coss(i) = eps_si * A_junc / x_d;  % Capacitance [F]
end

% Convert to nanofarads
Coss_nF = Coss * 1e9;

% Find capacitance at key voltages
Coss_10V = interp1(Vdc, Coss_nF, 10);
Coss_50V = interp1(Vdc, Coss_nF, 50);
Coss_300V = interp1(Vdc, Coss_nF, 300);

% Plot results
figure;
subplot(2,1,1);
semilogy(Vdc, Coss_nF, 'b', 'LineWidth', 2);
grid on;
title('SJ MOSFET: C_{oss} vs V_{dc}');
ylabel('C_{oss} [nF]');
xline(V_dep, '--r', 'V_{dep} = 50V');
text(100, Coss_50V*1.5, sprintf('C_{oss}@50V = %.2f nF', Coss_50V));
text(300, Coss_300V*1.1, sprintf('Min C_{oss} = %.2f nF', Coss_300V));

subplot(2,1,2);
plot(Vdc, Coss_nF, 'b', 'LineWidth', 2);
grid on;
xlabel('V_{dc} [V]');
ylabel('C_{oss} [nF]');
xline(V_dep, '--r', 'V_{dep} = 50V');
ylim([0 1.2*max(Coss_nF)]);

% Display key metrics
fprintf('\nCoss Characteristics:\n');
fprintf('----------------------\n');
fprintf('Coss @ 10V: %.2f nF\n', Coss_10V);
fprintf('Coss @ 50V: %.2f nF\n', Coss_50V);
fprintf('Coss @ 300V: %.2f nF\n', Coss_300V);
fprintf('Coss reduction (10V→50V): %.1f%%\n', (1 - Coss_50V/Coss_10V)*100);

% Calculate Qoss and Eoss
Qoss = cumtrapz(Vdc, Coss);          % Charge [C]
Eoss = 0.5 * Coss .* Vdc.^2;         % Energy [J]

figure;
yyaxis left;
plot(Vdc, Qoss*1e9, 'b-', 'LineWidth', 2);
ylabel('Q_{oss} [nC]');

yyaxis right;
plot(Vdc, Eoss*1e6, 'r-', 'LineWidth', 2);
ylabel('E_{oss} [μJ]');

title('Output Charge & Energy vs Voltage');
xlabel('V_{dc} [V]');
grid on;
legend('Q_{oss}', 'E_{oss}', 'Location', 'northwest');