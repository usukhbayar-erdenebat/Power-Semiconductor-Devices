# Power-Semiconductor-Devices
Power Semiconductor Devices final report questions

Given parameters:

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

**Question 1**


> [!NOTE]
> Some assumption taken within this report

> [!TIP]
> Helpful advice for doing things better or more easily.

> [!IMPORTANT]
> Key information users need to know to achieve their goal.

> [!WARNING]
> Urgent info that needs immediate user attention to avoid problems.

> [!CAUTION]
> Advises about risks or negative outcomes of certain actions.

<code style="color : red">_1.  Design doping concentration of N drift region of MOSFET (Fig 1) for VB=700V_</code>

![](/figures/figure1-1.png)
*Figure 1*


<details>
<summary>:triangular_flag_on_post: Answer is HERE</summary>

### Equation
$N_D = \frac{E_{\text{crit}}^2 \cdot \varepsilon}{2 \cdot q \cdot V_B}$

### Answer
$N_D = 1.78 \times 10^{14} \ \text{[cm}^{-3}\text{]}$
</details>


_2.  Calculate on resistance of the MOSFET for area of 1 cm<sup>2</sup>_

<details>
<summary>:triangular_flag_on_post: Answer is HERE</summary>

### Equations
$R_{\text{drift}} = \frac{4 V_B^2}{\mu_n \varepsilon_{\text{Si}} E_{\text{crit}}^3} \ [\Omega]$

or

$L_{\text{drift}} = \frac{2 V_B}{E_{\text{crit}}} \ [\mathrm{cm}]$

$R_{\text{on, drift}} = \frac{L_{\text{drift}}}{q \mu_n N_D A} \ [\Omega]$

### Answer

$R_{\text{drift}} = 163.333 \ \mathrm{m}\Omega \cdot \mathrm{cm}^2$

$R_{\text{on, drift}} = 163.333 \ \mathrm{m}\Omega \cdot \mathrm{cm}^2$

result is SAME.

</details>




_3.  Calculate Coss (CGD+CDS) as a function of applied voltage (Fig 2)_

![](/figures/figure1-2.png)
*Figure 2*

<details>
<summary>🚩 Answer is HERE</summary>

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

Here $C_{GD}$ is gate-drain capacitance, which in your simplified model equals $C_{DS}$, so

$C_{oss} = C_{DS}$

</details>



_4.  Calculate turn off (Vds) waveform of the MOSFET under inductive load (Fig. 3). Gate is assumed to be turned off without Miller period (i.e. gate resistance =0)_

![figure 3](/figures/figure1-3.png)
*Figure 3*

_5.  Calculate turn-off loss (energy)_




**Question 2**

_1.  Design SJ structure MOSFET (Fig 1) for VB=700V. SJ stripe depletes at 50 V._

![](/figures/figure2-1.png)
*Figure 1*

_2.  Calculate on resistance of the MOSFET for area of 1 cm2_
_3.  Calculate Coss (CGD+CDS) as a function of applied voltage (Fig 2)_

![](/figures/figure2-2.png)
*Figure 2*

_4.  Calculate turn-off (Vds) waveform of the MOSFET under inductive load (Fig. 3). Gate is assumed to be turned off without Miller period (i.e. gate resistance =0)_

![](/figures/figure2-3.png)
*Figure 3*

_5.  Calculate turn-off loss (energy)_

