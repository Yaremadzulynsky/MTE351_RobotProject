# Food-Serving Differential-Drive Robot – Project Breakdown

_Course: MTE 351 – Spring 2025_

## 1. Project Goal

Design, model, and simulate an indoor **food-serving robot** that can:

- Navigate a prescribed restaurant path quickly **without spilling** food/drinks.
- Absorb floor irregularities with a tuned suspension.
- Deliver a concise ≤ 10-page report (plus appendices) summarizing assumptions, models, results, and design insights.

---

## 2. Work Packages (WP)

| WP        | Focus                                | Core Tasks                                                                                                                                      | Key Deliverables                                                           |
| --------- | ------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| **WP-1**  | **Coupled Navigation + Motor Model** | Implement planar kinematic + kinetic model of differential drive with DC motors in Simulink/Simscape.                                           | Block/physical diagrams; simulation file.                                  |
| **WP-2**  | **Suspension Sub-Model**             | Model spring-damper on each wheel (linear, 1 DOF each). Decide whether to couple to navigation model.                                           | Suspension schematic; Simscape or Simulink implementation.                 |
| **WP-3**  | **Floor Excitation Signals**         | Generate 5 m tiled-floor profile (1 ft tiles, 1 cm grout, 0.5 cm deep haversine).                                                               | MATLAB script/function; signal plot.                                       |
| **WP-4**  | **Door-Threshold Signal**            | Create 5 cm-long, 3 cm-high haversine bump signal.                                                                                              | MATLAB script; signal plot.                                                |
| **WP-5**  | **Suspension Parameter Tuning**      | Iterate wheel-spring stiffness & damping vs. planar velocity (≈ 3 m/s start). Ensure ≤ 0.5 cm drink displacement. Analyze full & minimum loads. | Trade-off graphs; chosen \(k\), \(c\), and allowable bump specs.           |
| **WP-6**  | **Isolation Verification**           | Simulate final design on all floor signals. Plot vertical force & acceleration at wheels.                                                       | Force & acceleration plots.                                                |
| **WP-7**  | **Path Definition**                  | Program straight-line + on-spot spin path from kitchen to table (see two spin points).                                                          | Path script/figure.                                                        |
| **WP-8**  | **Motor Voltage Profiles**           | Craft trapezoidal velocity-based voltage inputs for each wheel.                                                                                 | Voltage-time profiles; rationale.                                          |
| **WP-9**  | **Drive-Train Sizing**               | Choose/justify DC motor & gear ratio. Compute rms torque, accel/decel times, jerk.                                                              | Datasheet excerpt or assumed specs; sizing calculations; accel/jerk plots. |
| **WP-10** | **Full-System Simulation**           | Integrate all subsystems, run path trial, and record actual trajectory vs. desired.                                                             | Simulation file; XY-path plot; summary of performance.                     |

_(Tasks & deliverables paraphrased from project brief)_ :contentReference[oaicite:1]{index=1}

---

## 3. Suggested Team Roles (5 members)

| Role                              | Primary WPs                                       | Secondary Support |
| --------------------------------- | ------------------------------------------------- | ----------------- |
| **Navigation & Motors Lead**      | 1, 8, 9                                           | 10                |
| **Suspension & Vibration Lead**   | 2, 5, 6                                           | 3, 4              |
| **Signal & Path Planning Lead**   | 3, 4, 7                                           | 8                 |
| **Integration & Simulation Lead** | 10                                                | 1, 2              |
| **Documentation & QA Lead**       | Report compilation, diagrams, assumption tracking | All (peer review) |

_Rotate review duties so every member cross-checks at least one other WP._

---

## 4. Internal Milestones (example)


---

## 5. Shared Assets Repository Structure

/model
/navigation_motor
/suspension
/signals
/report
main.pdf
/figures
/scripts
generate_floor_signal.m
generate_threshold_signal.m

Use Git branching (`wp-1/nav-model`, `wp-2/suspension`, etc.) and pull requests for peer review.

---

## 6. Risk & Dependency Notes

- **Coupling**: Navigation ↔ Suspension coupling is optional but raises complexity; decide early.
- **Motor specs** impact voltage profiles and suspension tuning—keep WP-5 and WP-9 in sync.
- **Signal realism**: Floor/threshold profiles drive suspension design—verify amplitude units.
- **Tool paths**: Simulink models must use relative paths for portability in final submission. :contentReference[oaicite:2]{index=2}

---

## 7. Interdependencies

```mermaid
flowchart LR
  %% ──────────────── PHASE 0 ────────────────
  KICKOFF((Project Kick-off))

  %% ──────────────── PHASE 1 – Foundations ────────────────
  subgraph "Phase 1 – Foundations"
    WP1[WP-1<br/>Nav + Motor Model]
    WP2[WP-2<br/>Suspension Model]
    WP3[WP-3<br/>Floor Signals]
    WP4[WP-4<br/>Door-Bump Signal]
    WP7[WP-7<br/>Path Definition]
  end

  %% ──────────────── PHASE 2 – Detailed Design ────────────────
  subgraph "Phase 2 – Detailed Design"
    WP9[WP-9<br/>Drive-Train Sizing]
    WP5[WP-5<br/>Suspension Tuning]
    WP8[WP-8<br/>Motor Voltage Profiles]
  end

  %% ──────────────── PHASE 3 – Verification ────────────────
  subgraph "Phase 3 – Verification"
    WP6[WP-6<br/>Isolation Verification]
  end

  %% ──────────────── PHASE 4 – Integration ────────────────
  subgraph "Phase 4 – Integration & Report"
    WP10[WP-10<br/>Full-System Simulation & Report]
  end

  %% ──────────────── FLOWS ────────────────
  %% Kick-off feeds every foundation task
  KICKOFF --> WP1
  KICKOFF --> WP2
  KICKOFF --> WP3
  KICKOFF --> WP4
  KICKOFF --> WP7

  %% Links into Phase 2
  WP1 --> WP9
  WP2 --> WP5
  WP3 --> WP5
  WP4 --> WP5
  WP1 --> WP8
  WP7 --> WP8
  WP9 --> WP8

  %% Verification links
  WP5 --> WP6
  WP3 --> WP6
  WP4 --> WP6

  %% Everything rolls into final integration
  WP1 --> WP10
  WP2 --> WP10
  WP3 --> WP10
  WP4 --> WP10
  WP5 --> WP10
  WP6 --> WP10
  WP7 --> WP10
  WP8 --> WP10
  WP9 --> WP10
```




### Quick Next Steps for the Group

1. **Assign roles and WPs** (Section 3).
2. **Set up shared repo** with skeleton folders (Section 5).
3. **Lock initial assumptions** (robot geometry, wheel size, loads) in a shared `assumptions.md`.
4. **Kick-off WP-1/WP-2 modeling** so downstream tasks have early prototypes.

Good luck, and remember to keep the coffee _inside_ the cup!
