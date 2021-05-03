.syntax unified
.global main

.global dot_length @ 0x20000
.set dot_length, 0x20000

.type main, %function
main:
  nop

  @ ex1. a led utility library
  @ ex1 starts here
  @ init red and green leds
  bl red_led_init
  bl green_led_init

sos:
  bl blink_s
  bl blink_letter
  bl blink_o
  bl blink_letter
  bl blink_space
  b sos

blink_s:
  push {r0, r1, lr}
  mov r1, #3
start_dot:
  bl blink_dot
  sub r1, #1
  cmp r1, #0
  bne start_dot
  pop {r0, r1, lr}
  bx lr

blink_o:
  push {r0, r1, lr}
  mov r1, #3
start_dash:
  bl blink_dash
  sub r1, #1
  cmp r1, #0
  bne start_dash
  pop {r0, r1, lr}
  bx lr 

blink_dot:
  @ bl green_led_toggle @ is it necessary to toggle?
  push {r0, r1, lr}
  bl green_led_on
  @ 0x20000 as a dot delay length for ~20000*(delay operations) cpu clock time
  mov r0, dot_length
  bl delay
  
  bl green_led_off
  mov r0, dot_length
  bl delay
  pop {r0, r1, lr}
  bx lr

blink_dash:
  push {r0, r1, lr}
  bl green_led_on
  @ a dash has longer time delay
  mov r1, #3
dash_3dots:
  mov r0, dot_length  
  bl delay
  sub r1, #1
  cmp r1, 0
  bne dash_3dots
pause:
  bl green_led_off
  mov r0, dot_length
  bl delay
  pop {r0, r1, lr}
  bx lr

blink_space:
  push {r0, r1, lr}
  bl green_led_off
  mov r1, #7
space_7dots:
  mov r0, dot_length
  bl delay
  sub r1, #1
  cmp r1, #0
  bne space_7dots
  pop {r0, r1, lr}
  bx lr

blink_letter:
  push {r0, r1, lr}
  bl green_led_off
  mov r1, #3
space_3dots:
  mov r0, dot_length
  bl delay
  sub r1, #1
  cmp r1, #0
  bne space_3dots
  pop {r0, r1, lr}
  bx lr

  @ ex1 ends here



loop: 
  nop
  b loop

  b main
.size main, .-main