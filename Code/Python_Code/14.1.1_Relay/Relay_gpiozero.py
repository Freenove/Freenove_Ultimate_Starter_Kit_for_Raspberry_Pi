from gpiozero import OutputDevice, Button
from signal import pause

def toggle():
  button = Button(18)
  val = True
  while True:
    button.wait_for_press()
    button.wait_for_release()
    print("The button was pressed!")
    yield val
    val = not val

motor = OutputDevice(17)

motor.source = toggle()

pause()
