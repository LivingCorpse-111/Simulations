# Physics Simulations

[![Made with Julia](https://img.shields.io/badge/Made%20with-Julia-9558B2?style=flat-square&logo=julia&logoColor=white)](https://julialang.org/)

Welcome to my physics simulation repository! This space showcases numerical solutions and visual animations for various dynamical systems.

---

## 1. Pendulum Simulation

* 💻 **Source Code:** [`pendulum.jl`](./pendulum/pendulum.jl)
* 🎞️ **Animation:**

<div align="center">
  <table>
    <tr>
      <td width="500">
        <video src="https://github.com/user-attachments/assets/560265f5-8004-4de9-8019-374f5e8665b1" controls width="100%"></video>
      </td>
    </tr>
  </table>
</div>

---

## 2. Two-Body Problem Simulation

* 💻 **Source Code:** [`Two Body Problem.jl`](./two_body_problem/Two%20Body%20Problem.jl)
* 🎞️ **Animations:**

> **Note on Frame Tracking:** The zoomed camera dynamically tracks the Center of Mass (COM). Given a tracking radius $R_{\text{zoom}}$, the viewport limits are updated at each integration timestep according to:
> $$x_{\text{lims}} = (x_{\text{com}} - R_{\text{zoom}}\, x_{\text{com}} + R_{\text{zoom}})$$, 
> $$y_{\text{lims}} = (y_{\text{com}} - R_{\text{zoom}}\, y_{\text{com}} + R_{\text{zoom}})$$, 
> $$z_{\text{lims}} = (z_{\text{com}} - R_{\text{zoom}}\, z_{\text{com}} + R_{\text{zoom}})$$, 
 

<div align="center">
  <table>
    <tr>
      <th width="45%">🔍 Zoomed View</th>
      <th width="45%">🌌 Full View (Not Zoomed)</th>
    </tr>
    <tr>
      <td>
        <video src="https://github.com/user-attachments/assets/ce4b6655-f2ef-46c0-b597-92f5134a67cd" controls width="100%"></video>
      </td>
      <td>
        <video src="https://github.com/user-attachments/assets/d07da626-d2be-456e-8944-c11670f0e0bc" controls width="100%"></video>
      </td>
    </tr>
  </table>
</div>

---
