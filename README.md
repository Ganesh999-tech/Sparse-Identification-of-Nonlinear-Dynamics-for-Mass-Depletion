# Sparse-Identification-of-Nonlinear-Dynamics-for-Mass-Depletion


S-SINDy: Aero-Inertial Mass Identification

Sparse Identification of Nonlinear Dynamics for Real-Time Mass Depletion Tracking
🚀 Overview

This project implements a Sensitivity-Enhanced SINDy (S-SINDy) algorithm to estimate the mass of a vehicle in motion. By analyzing the relationship between thrust, velocity, and acceleration, the model "learns" the mass of the system without a scale.
🛠️ Phase 1: Current Implementation

The current MATLAB script uses a sliding-window regression to track fuel burn on a simulated aircraft.

    Core Logic: a+gsin(γ)=m1​T−mk​v2

    Optimization: Uses Gaussian smoothing and linear trend-line fitting to separate subtle mass loss from sensor noise.

📈 Future Scaling (The Roadmap)
Phase 2: Aerospace (MSFS 2020 Integration)

In this phase, we move from synthetic data to Microsoft Flight Simulator 2020.

    Data Source: SimConnect API.

    Goal: Track real-time mass depletion of a Boeing 747-8 during a long-haul flight.

    Challenge: Handling dynamic "Ground Effect" and variable air density (ρ) which affects the drag coefficient (k).

Phase 3: Automotive (2-Wheel Drive Robot)

Applying S-SINDy to a ground vehicle using physical IMU and Encoder data.

    Hardware: Raspberry Pi Pico / Jetson Orin Nano, YDLIDAR, and a 2WD Chassis.

    Goal: Estimate the payload mass (e.g., adding a weight to the robot) by analyzing the "Tractive Force" vs. Acceleration.


Imagine you are trying to guess how heavy a backpack is without picking it up. Instead, you push it and see how fast it moves.
Phase 2: The Magic Disappearing Fuel (Aerospace)

Imagine a giant airplane is like a big juice box. As the plane flies, it "drinks" its fuel.

    The Secret: Because the fuel is being used up, the plane gets lighter and lighter every minute.

    How we find it: We look at how hard the engines are pushing (Thrust) and how fast the plane is speeding up (Acceleration).

    The Formula:
    Mass=Speeding UpPushing Force​

    If the engine pushes with the same "oomph" but the plane starts speeding up faster, we know the "juice box" is getting empty!

Phase 3: The Robot Tug-of-War (Automotive)

Think of your 2-wheel drive robot. When the wheels turn, they push against the floor. This is called Tractive Force.

    The Secret: If we put a heavy brick on the robot, the wheels have to push much harder to get it to move.

    The Formula:
    Ftractive​=(m⋅a)+Fdrag​

    (Force = Weight × Acceleration + Air/Floor Friction)

    How we find it: We use a tiny sensor called an IMU (like the one that knows when you tilt your phone). It tells us exactly how much the robot "shivered" or moved. By matching the "shiver" to how much electricity the motors used, we can guess exactly how heavy the brick is!
