.syntax unified
.global main
.global SysTick_Handler
.global EXTI0_IRQHandler

.type main, %function
main:
  @ nop
  @ SYST_CSR: system tick control and status register, 0xe000e010
  @ SYST_RVR: system tick reload value register, 0xe000e014
  @ SYST_CVR: system tick current value register, 0xe000e018

  @ set SYST_CSR clksource(2nd), tickint(1st), enable(0th) to 1
  ldr r0, =0xe000e010
  ldr r1, [r0]
  orr r1, 0x7
  str r1, [r0], #4
  @ set SYST_RVR to a reload value, e.g., 0x3d0900 (4000000) 0x1e8489 (200000)
  @ ldr r0, =0xe000e014
  ldr r1, [r0]
  @ ldr r1, =0x1e8480
  ldr r1, =0xb71b00
  str r1, [r0], #4
  @ read SYST_CVR
  ldr r2, [r0]
  @ init leds
  bl red_led_init
  bl green_led_init

  @ bl joystick_init

  @ @ ex4 set priorities
  @ @ set SysTick priority to 8 (31st)
  @ ldr r0, =0xe000ed00
  @ ldr r1, =0x20
  @ mov r2, 31
  @ bl set_bit

  @ @ set EXTI0 priority to 1 (ensure that it's higher than Systick) (20th)
  @ ldr r0, =0xe000e100
  @ ldr r1, =0x304
  @ mov r2, 20
  @ bl set_bit

  @ ex5

loop:
  b loop
.size main, .-main

@ @ ex1-3 customized SysTick_Handler
@ .type SysTick_Handler, %function
@ SysTick_Handler:
@   push {lr}
@   bl red_led_toggle
@   pop {lr}
@   bx lr
@ .size SysTick_Handler, .-SysTick_Handler

@ @ ex4 infinite loop in SysTick_Handler
@ .type SysTick_Handler, %function
@ SysTick_Handler:
@   push {lr}
@   bl red_led_on
@ SysTick_Handler_infloop:
@   nop
@   b SysTick_Handler_infloop
@ .size SysTick_Handler, .-SysTick_Handler

.type SysTick_Handler, %function
SysTick_Handler:
  push {lr}
  @ clear EXTI and NVIC interrupt pending bits before enabling EXTI interrupt
  @ @ clear EXTI_PR1
  @ ldr r0, =0x40010400
  @ ldr r1, =0x14
  @ mov r2, 0
  @ bl set_bit 
  @ clear NVIC interrupt

  @ enable the joystick interrupt
  ldr r0, =0xe000e100
  ldr r1, =0x0
  mov r2, 6
  bl set_bit

blink_red_delay:
  bl red_led_on
  @ blink for ~1s
  ldr r0, =0xd0900
  bl delay
  bl red_led_off

  @ disable joystick interrupt NVIC_ICER0
  @ ldr r0, =0xe000e100
  @ ldr r1, =0x0
  @ ldr r2, =6
  @ bl clear_bit
  ldr r0, =0xe000e100
  ldr r1, =0x80
  mov r2, 6
  bl set_bit

  pop {lr}
  bx lr

.size SysTick_Handler, .-SysTick_Handler

.type EXTI0_IRQHandler, %function
EXTI0_IRQHandler:
  push {lr}
  bl green_led_toggle
  @ clear EXTI_PR1
  ldr r0, =0x40010400
  ldr r1, =0x14
  mov r2, 0
  bl set_bit
  pop {lr}
  bx lr
.size EXTI0_IRQHandler, .-EXTI0_IRQHandler