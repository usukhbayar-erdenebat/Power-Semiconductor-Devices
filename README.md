# Power-Semiconductor-Devices
Power Semiconductor Devices final report questions

> [!IMPORTANT]
> Key parameters are given for this report. Ravi san

    q = 1.6e-19 [C]
    Ɛ = 1.0e-12 [F/cm]
    kT = 0.026 [eV] at 300K
    ni = 1.5e10 [/cm3] at 300K
    Mobility
     hole 500 [cm2/V-sec]
     Electron 1500 [cm2/V-sec]
    1[J] = 1[C] x 1[V]
    1[W] = 1[A] x 1[V]
    1[A] = 1[C] / 1[sec]
    C=dQ/dV
    
    E(critical) = 2e5 [V/cm]
    I_o = 10 [A]
    V_dc = 300 [V]

# **❗ Question 1 (DMOSFET)❗**

_:round_pushpin: 1.  Design doping concentration of N drift region of MOSFET (Fig 1) for VB=700V :question:_

![](/figures/figure1-1.png)
*Figure 1*


<details>
<summary>:white_check_mark: Answer is HERE</summary>

### Equation
$N_D = \frac{E_{\text{crit}}^2 \cdot \varepsilon}{2 \cdot q \cdot V_B}$

### Answer
$N_D = 1.78 \times 10^{14} \ \text{[cm}^{-3}\text{]}$ :large_blue_circle:
</details>


_:round_pushpin: 2.  Calculate on resistance of the MOSFET for area of 1 cm<sup>2</sup> :question:_

<details>
<summary>:white_check_mark: Answer is HERE</summary>

### Equations
$R_{\text{drift}} = \frac{4 V_B^2}{\mu_n \varepsilon_{\text{Si}} E_{\text{crit}}^3} \ [\Omega]$

or

$L_{\text{drift}} = \frac{2 V_B}{E_{\text{crit}}} \ [\mathrm{cm}]$

$R_{\text{on, drift}} = \frac{L_{\text{drift}}}{q \mu_n N_D A} \ [\Omega]$

### Answer

$R_{\text{drift}} = 163.333 \ \mathrm{m}\Omega \cdot \mathrm{cm}^2$ :large_blue_circle:

$R_{\text{on, drift}} = 163.333 \ \mathrm{m}\Omega \cdot \mathrm{cm}^2$ :large_blue_circle:

results are SAME.

</details>




_:round_pushpin: 3.  Calculate Coss (CGD+CDS) as a function of applied voltage (Fig 2) :question:_

![](/figures/figure1-2.png)
*Figure 2*

<details>
<summary>:white_check_mark: Answer is HERE</summary>

### NA = ND:

Assuming symmetric doping concentration for the P and N sides of the diode/junction, so acceptor doping $N_A$ equals donor doping $N_D$.

### Built-in voltage $V_{bi}$:

$V_{bi} = \frac{k T}{q} \ln \left(\frac{N_D N_A}{n_i^2}\right)$

- $k$: Boltzmann constant  
- $T$: Temperature (Kelvin)  
- $q$: Electron charge  
- $n_i$: Intrinsic carrier concentration  

This voltage represents the built-in potential across the depletion region.

### Depletion width $W$:

$W = \sqrt{\frac{2 \varepsilon_{Si} (V_{bi} + V_{DS})}{q N_D}}$

- $\varepsilon_{Si}$: Permittivity of silicon  
- $V_{DS}$: Applied drain-to-source voltage  
- $N_D$: Doping concentration  

This formula calculates how the depletion region width changes with applied voltage.

### Depletion capacitance $C_{DS}$:

$C_{DS} = \frac{\varepsilon_{Si} A}{W}$

- $A$: Area of the junction  

Represents the capacitance due to the depletion region, inversely proportional to the depletion width.

### Output capacitance $C_{oss}$:

$C_{oss} = C_{GD} + C_{DS}$

Here $C_{GD}$ is gate-drain capacitance we assume without the miller period, which in your simplified model equals $C_{DS}$, so

$C_{oss} = C_{DS}$

![Figure Coss VS Vds](/figures/planar-Coss.jpg)
*Figure: Waveform of Coss VS Vds*


### Coss values at specific Vds: :large_blue_circle:

|Vds|Coss|
|:---|:---|
|At Vds = 100 V|Coss = 0.3769 nF|
|At Vds = 200 V|Coss = 0.2669 nF|
|At Vds = 300 V|Coss = 0.2180 nF|
</details>



_:round_pushpin: 4.  Calculate turn off (Vds) waveform of the MOSFET under inductive load (Fig. 3). Gate is assumed to be turned off without Miller period (i.e. gate resistance =0) :question:_

![figure 3](/figures/figure1-3.png)
*Figure 3*

<details>
<summary>:white_check_mark: Answer is HERE</summary>

### Equations

**Current through capacitor:**  
$I = C \cdot \frac{dV}{dt} \quad \Rightarrow \quad \frac{dV}{dt} = \frac{I}{C}$

**Voltage increment for time step $dt$:**  
$\Delta V = \frac{I_0}{C(V)} \cdot dt$

**Output capacitance $C_{oss}$ as a function of voltage:**  
$C_{oss}(V) = \frac{\varepsilon_{Si} \cdot A}{W(V)}$

**Depletion width $W(V)$:**  
$W(V) = \sqrt{\frac{2 \varepsilon_{Si} (V_{bi} + V)}{q N_D}}$

**Update voltage at each timestep:**  
$V_{DS}(t + dt) = V_{DS}(t) + \Delta V$


![Figure Coss VS Vds](/figures/planar-toff-Vds.jpg)
*Figure: Turn-off waveform of Vds*
</details>


_:round_pushpin: 5.  Calculate turn-off loss (energy) :question:_

![](/figures/5.png)
*it takes some time to put equations in here just upload the screenshot here!*


# **❗ Question 2 (SJ MOSFET)❗**

_:round_pushpin: 1.  Design SJ structure MOSFET (Fig 1) for VB=700V. SJ stripe depletes at 50 V :question:_

![](/figures/figure2-1.png)
*Figure 1*

<details>
<summary>:white_check_mark: Answer is HERE</summary>

### Equation
Peak Electric Field:
$E_{\text{peak}} = \frac{E_{\text{crit}}}{\sqrt{2}}$

where 
$E_{\text{crit}} = 2 \times 10^5 , \text{V/cm}$

### Answer
$E_{\text{peak}} = 1.4142 \times 10^5 , \text{V/cm}$ :large_blue_circle:

### Equation
Depletion Voltage (Area of the Triangle):



![](/figures/triangle.jpg)
*Figure SJ pillar width illustration*


$V_{\text{dep}} = \frac{1}{2} \cdot W \cdot E_{\text{peak}}$

Solving for the pillar width 
$W$:

$W = \frac{2 \cdot V_{\text{dep}}}{E_{\text{peak}}}$

where 
$V_{\text{dep}} = 50 , \text{V}$

### Answer
Pillar Width ($W$): $7.07 , \mu\text{m}$ :large_blue_circle:

### Equation
Slope of the Electric Field:
$\text{Slope} = \frac{q N_D}{\epsilon_{\text{si}}}$

For the isosceles triangle, the slope is also:
$\text{Slope} = \frac{E_{\text{peak}}}{W/2} = \frac{2 \cdot E_{\text{peak}}}{W}$

Equating the two:
$\frac{q N_D}{\epsilon} = \frac{2 \cdot E_{\text{peak}}}{W}$

Solving for the doping concentration 
$N_D$:

$N_D = \frac{{\sqrt{2}} \cdot E_{\text{peak}} \cdot \epsilon_{\text{si}}}{q \cdot W}$

where 
$q = 1.6 \times 10^{-19} , \text{C}$, $\epsilon_{\text{si}} = 1.0 \times 10^{-12} , \text{F/cm}$

### Answer
Doping Concentration ($N_D$): $1.77 \times 10^{15} , \text{cm}^{-3}$ :large_blue_circle:

### Equation Breakdown Voltage:
$V_B \approx E_{\text{crit}} \cdot L$

Solving for 
$L$:

$L = \frac{{\sqrt{2}} \cdot V_B}{E_{\text{crit}}}$

where 
$V_B = 700 , \text{V}$

### Answer
Pillar Length ($L$): $49.50 , \mu\text{m}$ :large_blue_circle:
</details>

_:round_pushpin: 2.  Calculate on resistance of the MOSFET for area of 1 cm2 :question:_

<details>
<summary>:white_check_mark: Answer is HERE</summary>

### Equations

$R_{\text{drift}} = \frac{2 V_B W}{\mu_n \varepsilon_{\text{Si}} E_{\text{crit}}^2} \ [\Omega]$

### Answer

$R_{\text{drift}} = 16.499 \ \mathrm{m}\Omega \cdot \mathrm{cm}^2$ :large_blue_circle:

</details>

_:round_pushpin: 3.  Calculate Coss (CGD+CDS) as a function of applied voltage (Fig 2) :question:_

![](/figures/figure2-2.png)
*Figure 2*

<details>
<summary>:white_check_mark: Answer is HERE</summary>

![](/figures/3.png)
*it takes some time to put equations in here just upload the screenshot here!*

![](/figures/3-1.png)
*it takes some time to put equations in here just upload the screenshot here!*

</details>


_:round_pushpin: 4.  Calculate turn-off (Vds) waveform of the MOSFET under inductive load (Fig. 3). Gate is assumed to be turned off without Miller period (i.e. gate resistance =0) :question:_

![](/figures/figure2-3.png)
*Figure 3*

_:round_pushpin: 5.  Calculate turn-off loss (energy) :question:_

