.syntax unified
.global main
.include "src/libcomp2300/macros.S"
.global EXTI0_IRQHandler
.global EXTI1_IRQHandler

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

  @ @ input device as opposed to LED output
  @ GPIO_configure_input_pin A, 0

@ commented out for ex2
@ poll_gpio:
@   @ read PA0, set flags based on result
@   GPIOx_IDR_read A, 0
@   @ do sth based on flags here
@   beq green_led_on
@   bne red_led_on
@ green_led_on:
@   GPIOx_ODR_set E, 8
@   b end_poll
@ red_led_on:
@   GPIOx_ODR_set B, 2
@   b end_poll
@ end_poll:
@   b poll_gpio

  @ ex2. let's do it again, this time using interrupts
  @ ex2 starts here
  @ before enabling and configuring interrupts, enable System Configuration Controller SYSCFG to modify the sys config
  @ enable SYSCFG clock
  RCC_APB2ENR_set 0
  @ _it enable interrupt - center
  GPIO_configure_input_pin_it A, 0
  EXTI_set_rising_edge_trigger 0
  EXTI_set_falling_edge_trigger 0
  @ - left
  GPIO_configure_input_pin_it A, 1
  EXTI_set_rising_edge_trigger 1
  EXTI_set_falling_edge_trigger 1

  @ enable NVIC interrupt position 6 - EXTI0
  NVIC_set ISER 6
  @ position - EXTI1
  NVIC_set ISER 7
loop:
  nop
  b loop
  b main
.size main, .-main

@ for central joystick
.type EXTI0_IRQHandler, %function
EXTI0_IRQHandler:
  push {r4, lr}
  mov r4, 1
blink_red:
  cmp r4, 1
  beq turn_red_on
  bne turn_red_off
turn_red_on:
  GPIOx_ODR_set B, 2
  b delay_next
turn_red_off:
  GPIOx_ODR_clear B, 2
  b delay_next
delay_next:
  rsb r4, r4, 1
  ldr r0, =1000000 
  bl delay
  b blink_red
  @ clear EXTI_PR1
  EXTI_PR_clear_pending 1
  pop {r4, lr}
  bx lr
.size EXTI0_IRQHandler, .-EXTI0_IRQHandler

@ for left joystick
.type EXTI1_IRQHandler, %function
EXTI1_IRQHandler:
  push {r4, lr}
  mov r4, 1
blink_green:
  cmp r4, 1
  beq turn_green_on
  bne turn_green_off
turn_green_on:
  GPIOx_ODR_set E, 8
  b delay_next_short
turn_green_off:
  GPIOx_ODR_clear E, 8
  b delay_next_short
delay_next_short:
  rsb r4, r4, 1
  ldr r0, =500000 
  bl delay
  b blink_green
  @ clear EXTI_PR1
  EXTI_PR_clear_pending 1
  pop {r4, lr}
  bx lr
.size EXTI1_IRQHandler, .-EXTI1_IRQHandler