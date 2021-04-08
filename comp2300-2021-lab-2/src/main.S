.syntax unified
.global main

.type main, %function
main:
  @ TODO 
  @ ex1. 2+2 task
  @ mov r0, 2
  @ add r1, r0, #2

  @ TODO
  @ ex2. reverse engineering
  .hword 0xdead
  .hword 0xbeef
  
  nop
  b main
.size main, .-main