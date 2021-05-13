.syntax unified
.global main
.include "src/libcomp2300/macros.S"

.type main, %function
main:
  nop
  @ ex1 starts here
  @ to use GPIO pins, turn them on by makeing sure the corresponding GPIO prot receives a clock signal
  @ red LED port B
  GPIOx_clock_enable B
  @ green LED port E
  GPIOx_clock_enable E
  @ joystick port A
  GPIOx_clock_enable A

  @ to send data out on GPIO pin, write a 0 or 1 to GPIO port's Output Data Register (ODR)
  @ red 
  GPIO_configure_output_pin B, 2
  @ green
  GPIO_configure_output_pin E, 8
  @@ write a 1 to ODR of red & green ODRs using set
  @ GPIOx_ODR_set B, 2
  @ GPIOx_ODR_set E, 8

  @ input device as opposed to LED output
  GPIO_configure_input_pin A, 0

poll_gpio:
  @ read PA0, set flags based on result
  GPIOx_IDR_read A, 0
  @ do sth based on flags here
  beq green_led_on
  bne red_led_on
green_led_on:
  GPIOx_ODR_set E, 8
  b end_poll
red_led_on:
  GPIOx_ODR_set B, 2
  b end_poll
end_poll:
  b poll_gpio

  b main
.size main, .-main
