.syntax unified
.global main
.include "src/libcomp2300/macros.S"
@ A1
.global EXTI1_IRQHandler
@ A2
.global EXTI2_IRQHandler
@ B7 corresponds to NVIC 9_5 handler
.global EXTI9_5_IRQHandler
@ E14
.global EXTI15_10_IRQHandler

.type main, %function
main:
  nop
  @ workflow as below for ex4:
  @ PA1(in-exti1) --> PD0(out) --> PE14(in-exti15_10)
  @ PA2(in-exti2) --> PE13(out) --> PB7(in-exti9_5)

  @ to use GPIO pins, turn them on by makeing sure the corresponding GPIO prot receives a clock signal
  @ red LED port B
  GPIOx_clock_enable B
  @ green LED port E
  GPIOx_clock_enable E
  @ port D
  GPIOx_clock_enable D
  @ joystick port A
  GPIOx_clock_enable A

  @ enable SYSCFG clock
  RCC_APB2ENR_set 0 

  @ to send data out on GPIO pin, write a 0 or 1 to GPIO port's Output Data Register (ODR)
  @ red 
  GPIO_configure_output_pin B, 2
  @ green
  GPIO_configure_output_pin E, 8
  @ sender PD0 & PE13
  GPIO_configure_output_pin D, 0
  GPIO_configure_output_pin E, 13

  @ enable input config with interrupt set up
  @ for joystick left
  GPIO_configure_input_pin_it A, 1
  @ 0 - 1 triggers (push-down)
  EXTI_set_rising_edge_trigger 1
  @ 1 - 0 triggers (release)
  EXTI_set_falling_edge_trigger 1
  @ for joystick right
  GPIO_configure_input_pin_it A, 2
  EXTI_set_rising_edge_trigger 2
  EXTI_set_falling_edge_trigger 2

  @ configure input pin as an interrupt-enabled GPIO input
  GPIO_configure_input_pin_it B, 7
  @ only one edge is enabled 
  EXTI_set_rising_edge_trigger 7
  @ for PE14
  GPIO_configure_input_pin_it E, 14
  EXTI_set_rising_edge_trigger 14

  @ enable NVIC interrupt (for "in" signals)
  @ exti1 for A1 at position 7
  NVIC_set ISER 7
  @ exti2 for A2 at position 8
  NVIC_set ISER 8
  @ exti9_5 for B7 at position 23
  NVIC_set ISER 23
  @ exti15_10 for E14 at position 40
  NVIC_set ISER 40

@ infinite loop to keep the discord running  
loop:
  nop
  b loop
  b main
.size main, .-main

@ exti1 triggers when left joystick A1 is pressed
.type EXTI1_IRQHandler, %function
EXTI1_IRQHandler:
  push {lr}
  GPIOx_ODR_toggle D, 0
  EXTI_PR_clear_pending 1
  pop {lr}
  bx lr
.size EXTI1_IRQHandler, .-EXTI1_IRQHandler

@ exti2 triggers when right joystick A2 is press
.type EXTI2_IRQHandler, %function
EXTI2_IRQHandler:
  push {lr}
  GPIOx_ODR_toggle E, 13
  EXTI_PR_clear_pending 2
  pop {lr}
  bx lr
.size EXTI2_IRQHandler, .-EXTI2_IRQHandler

@ PB7 receiver triggers when it received a signal from PE13 via jumper wire
.type EXTI9_5_IRQHandler, %function
EXTI9_5_IRQHandler:
  push {lr}
  @ toggle red and green led (b2 and e8 ports)
  GPIOx_ODR_toggle B, 2
  GPIOx_ODR_toggle E, 8
  @ clear pending. tell controller it's finished handler B7 interrupt
  EXTI_PR_clear_pending 7
  pop {lr}
  bx lr
.size EXTI9_5_IRQHandler, .-EXTI9_5_IRQHandler

@ PE14 receiver triggers when it received a signal from PD0 via jumper wire
.type EXTI15_10_IRQHandler, %function
EXTI15_10_IRQHandler:
  push {lr}
  GPIOx_ODR_toggle B, 2
  GPIOx_ODR_toggle E, 8
  EXTI_PR_clear_pending 14
  pop {lr}
  bx lr
.size EXTI15_10_IRQHandler, .-EXTI15_10_IRQHandler

@@@@@@@@@@@@@@@@@@@@@@@@@@
@ @ this line till the eof are codes for ex1-ex3
@ .syntax unified
@ .global main
@ .include "src/libcomp2300/macros.S"
@ .global EXTI0_IRQHandler
@ .global EXTI1_IRQHandler
@ @ B7 corresponds to NVIC 9_5 handler
@ .global EXTI9_5_IRQHandler

@ .type main, %function
@ main:
@   nop
@   @ ex1 starts here
@   @ to use GPIO pins, turn them on by makeing sure the corresponding GPIO prot receives a clock signal
@   @ red LED port B
@   GPIOx_clock_enable B
@   @ green LED port E
@   GPIOx_clock_enable E
@   @ joystick port A
@   GPIOx_clock_enable A

@   @ to send data out on GPIO pin, write a 0 or 1 to GPIO port's Output Data Register (ODR)
@   @ red 
@   GPIO_configure_output_pin B, 2
@   @ green
@   GPIO_configure_output_pin E, 8
@   @@ write a 1 to ODR of red & green ODRs using set
@   @ GPIOx_ODR_set B, 2
@   @ GPIOx_ODR_set E, 8

@   @ @ input device as opposed to LED output
@   @ GPIO_configure_input_pin A, 0

@ @ commented out for ex2
@ @ poll_gpio:
@ @   @ read PA0, set flags based on result
@ @   GPIOx_IDR_read A, 0
@ @   @ do sth based on flags here
@ @   beq green_led_on
@ @   bne red_led_on
@ @ green_led_on:
@ @   GPIOx_ODR_set E, 8
@ @   b end_poll
@ @ red_led_on:
@ @   GPIOx_ODR_set B, 2
@ @   b end_poll
@ @ end_poll:
@ @   b poll_gpio

@   @ @ commented out for ex3
@   @ @ ex2. let's do it again, this time using interrupts
@   @ @ ex2 starts here
@   @ @ before enabling and configuring interrupts, enable System Configuration Controller SYSCFG to modify the sys config
@   @ @ enable SYSCFG clock
@   @ RCC_APB2ENR_set 0
@   @ @ _it enable interrupt - center
@   @ GPIO_configure_input_pin_it A, 0
@   @ EXTI_set_rising_edge_trigger 0
@   @ EXTI_set_falling_edge_trigger 0
@   @ @ - left
@   @ GPIO_configure_input_pin_it A, 1
@   @ EXTI_set_rising_edge_trigger 1
@   @ EXTI_set_falling_edge_trigger 1

@   @ @ enable NVIC interrupt position 6 - EXTI0
@   @ NVIC_set ISER 6
@   @ @ position - EXTI1
@   @ NVIC_set ISER 7

@   @ ex3. click-over-the-wire
@   @ ex3 starts here. jumper cable to connect pin PB7 to PE13
@   @ enable SYSCFG clock
@   RCC_APB2ENR_set 0 
@   @ for joystick as well to get input signal
@   GPIO_configure_input_pin_it A, 0
@   @ 0 - 1 triggers (push-down)
@   EXTI_set_rising_edge_trigger 0
@   @ 1 - 0 triggers (release)
@   EXTI_set_falling_edge_trigger 0
@   @ configure output pin as a GPIO output, say E13 for this example
@   GPIO_configure_output_pin E, 13
@   @ configure input pin as an interrupt-enabled GPIO input
@   GPIO_configure_input_pin_it B, 7
@   @ only one edge is enabled because joystick pushdown and release will send the trigger twice (rising and falling edge), so if we set both for B7 as well, then as soon as we release the joystick, it triggers again, causing the led to turn off
@   EXTI_set_rising_edge_trigger 7
@   @ EXTI_set_falling_edge_trigger 7

@   @ enable NVIC interrupt 
@   @ exti0 for joystick at position 6. refer to p321 section 11.3 of the discoboard manual
@   NVIC_set ISER 6
@   @ exti9_5 for b7 at position 23.
@   NVIC_set ISER 23

@   @ @ the following setting priority is not necessary for ex3
@   @ @ set EXTI0 priority to 8
@   @ ldr r0, =0xe000e100
@   @ ldr r1, =0x304
@   @ mov r2, 23
@   @ bl set_bit

@   @ @ set EXTI7 priority to 1 (ensure that it's higher than Systick) (20th)
@   @ @ ldr r0, =0xe000e100
@   @ @ ldr r1, =0x314
@   @ @ mov r2, 28
@   @ @ bl set_bit
@   @ @ use the function in util.S
@   @ mov r0, 23
@   @ mov r1, 0x3
@   @ bl NVIC_IPR_set_priority

@ @ infinite loop to keep the discord running  
@ loop:
@   nop
@   b loop
@   b main
@ .size main, .-main

@ @ exti0 triggers when joystick is pressed and released. 
@ @ when this handler executes, it toggles the E13 value to send out a signal.
@ @ because E13 is connected to b7 via jumper wire, then for rising edge, it triggers b7 handler (which is 9_5_handler)
@ .type EXTI0_IRQHandler, %function
@ EXTI0_IRQHandler:
@   push {lr}
@   GPIOx_ODR_toggle E, 13
@   @ clear pending for EXTIn, e.g. EXTI0 should clear 0, EXTI3 should clear 3 after handling the interrupt. This ensures that EXTI controller knows when it's finished handling the interrupt from nth handler.
@   EXTI_PR_clear_pending 0
@   pop {lr}
@   bx lr
@ .size EXTI0_IRQHandler, .-EXTI0_IRQHandler

@ .type EXTI9_5_IRQHandler, %function
@ EXTI9_5_IRQHandler:
@   push {lr}
@   @ toggle red and green led (b2 and e8 ports)
@   GPIOx_ODR_toggle B, 2
@   GPIOx_ODR_toggle E, 8
@   @ clear pending. tell controller it's finished handler B7 interrupt
@   EXTI_PR_clear_pending 7
@   pop {lr}
@   bx lr
@ .size EXTI9_5_IRQHandler, .-EXTI9_5_IRQHandler
@ @ ex3 ---

@ @ @ ex2 ---
@ @ @ for central joystick
@ @ .type EXTI0_IRQHandler, %function
@ @ EXTI0_IRQHandler:
@ @   push {r4, lr}
@ @   mov r4, 1
@ @ blink_red:
@ @   cmp r4, 1
@ @   beq turn_red_on
@ @   bne turn_red_off
@ @ turn_red_on:
@ @   GPIOx_ODR_set B, 2
@ @   b delay_next
@ @ turn_red_off:
@ @   GPIOx_ODR_clear B, 2
@ @   b delay_next
@ @ delay_next:
@ @   rsb r4, r4, 1
@ @   ldr r0, =1000000 
@ @   bl delay
@ @   b blink_red
@ @   @ clear EXTI_PR1
@ @   EXTI_PR_clear_pending 1
@ @   pop {r4, lr}
@ @   bx lr
@ @ .size EXTI0_IRQHandler, .-EXTI0_IRQHandler

@ @ @ for left joystick
@ @ .type EXTI1_IRQHandler, %function
@ @ EXTI1_IRQHandler:
@ @   push {r4, lr}
@ @   mov r4, 1
@ @ blink_green:
@ @   cmp r4, 1
@ @   beq turn_green_on
@ @   bne turn_green_off
@ @ turn_green_on:
@ @   GPIOx_ODR_set E, 8
@ @   b delay_next_short
@ @ turn_green_off:
@ @   GPIOx_ODR_clear E, 8
@ @   b delay_next_short
@ @ delay_next_short:
@ @   rsb r4, r4, 1
@ @   ldr r0, =500000 
@ @   bl delay
@ @   b blink_green
@ @   @ clear EXTI_PR1
@ @   EXTI_PR_clear_pending 1
@ @   pop {r4, lr}
@ @   bx lr
@ @ .size EXTI1_IRQHandler, .-EXTI1_IRQHandler
@ @ @ ex2 ---