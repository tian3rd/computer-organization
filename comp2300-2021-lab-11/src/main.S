.syntax unified
.global main

.include "src/libcomp2300/macros.S"

.type main, %function
main:
  @ enable SYSCFG clock so that our changes to the SysTick control registers
  @ take effect
  RCC_APB2ENR_set 0

  @ enable SysTick, set interrupt trigger, and set processor as clock source
  @ by setting the three least-significant bits in the SysTick Control and Status
  @ Register (SYST_CSR), Section B3.3.3 on p677 of the ARMv7-M reference manual

  @ <your code goes here>

@ and here's an infinite loop
loop:
  nop
  b loop
.size main, .-main

.global SysTick_Handler
.type SysTick_Handler, %function
SysTick_Handler:
  nop
  @ <your code goes here>
  bx lr
.size SysTick_Handler, .-SysTick_Handler
