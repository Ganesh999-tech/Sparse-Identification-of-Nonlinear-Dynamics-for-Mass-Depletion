from SimConnect import SimConnect, AircraftRequests
import time

# Create the link to the simulator
sm = SimConnect()
aq = AircraftRequests(sm)

print("Connected! Reading flight data...")

try:
    while True:
        # Fetch variables for your physics validation
        speed = aq.get("AIRSPEED_INDICATED")
        pitch = aq.get("PLANE_PITCH_DEGREES")
        alt = aq.get("PLANE_ALTITUDE")
        
        print(f"Alt: {alt:.2f} ft | Speed: {speed:.2f} kt | Pitch: {pitch:.2f}°")
        time.sleep(0.1) # 10Hz sampling for your SINDy model
except KeyboardInterrupt:
    sm.exit()
    print("Stopped.")
