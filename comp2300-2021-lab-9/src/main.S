.syntax unified
.global main

.type main, %function
main:
  nop
  @ SYST_CSR: system tick control and status register, 0xe000e010
  @ SYST_RVR: system tick reload value register, 0xe000e014
  @ SYST_CVR: system tick current value register, 0xe000e018

  @ set SYST_CSR clksource(2nd), tickint(1st), enable(0th) to 1
  ldr r0, =0xe000e010
  ldr r1, [r0]
  orr r1, 0x5
  str r1, [r0], #4
  @ set SYST_RVR to a reload value, e.g., 0x3d0900 (4000000)
  @ ldr r0, =0xe000e014
  ldr r1, [r0]
  ldr r1, =0x3d0900
  str r1, [r0], #4
loop:
  @ read SYST_CVR
  ldr r2, [r0]
  cmp r2, #0
  bgt loop
  ble finished
finished:
  nop
  b main

.size main, .-main