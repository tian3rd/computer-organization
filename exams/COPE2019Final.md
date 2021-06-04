# Attempted answers (including code snippets)

```assembly

.syntax unified
.global main

.type main, %function
main:
  @ mov r0, 0b10101101
  @ mov r1, 0b00011101
  @ lsl r1, 3
  @ orr r0, r0, r1

  @ mov r3, 32
  @ stmdb sp!, {r3}
  @ mov r3, 7
  @ stmdb sp!, {r3}
  @ mov r3, 84
  @ stmdb sp!, {r3}
  @ mov r3, 128
  @ stmdb sp!, {r3}

  @ ldr r3, [sp, 4]
  @ nop

  @ @ Part2: LSR(register)
  @ lsrs r1, r6
  @ nop
  @ @ flags
  @ @ mov r0, 0xfffffff0
  @ @ mov r1, 0x10
  @ @ adds r0, r0, r1

  @ Part4: recursive func
  mov r0, 3
  mov r1, 5
  bl pow
loop_here:
  nop
  b loop_here
@ args: pow(x, y) = x to the power of y
@ r0: x, positive integer
@ r1: y, positive integer
@ returns:
@ r0: as pow(r0, r1)
pow:
  push {r4, lr}
  mov r4, r0
  cmp r1, 1
  beq end_recursive
  sub r1, 1
  bl pow
  mul r0, r0, r4
end_recursive:
  pop {r4, lr}
  bx lr

  @ Part3: encryption
  ldr r0, =letter
  ldrb r4, [r0]
  bl encode_letter
inf_loop:
  ldrb r5, [r0]
  nop
  b inf_loop
@ args:
@ r0: character's memory location
@ returns:
@ nothing. side effect: changed that character in that address by shifting the letter one position backwards. e.g. 'b' -> 'a', 'a' -> 'z'
encode_letter:
  push {lr}
  ldrb r1, [r0]
  cmp r1, 97
  blt return_encoded
  cmp r1, 122
  bgt return_encoded
  sub r1, 1
  cmp r1, 96
  beq wrap_to_z
  b return_encoded
wrap_to_z:
  mov r1, 122
return_encoded:
  strb r1, [r0]
  pop {lr}
  bx lr

  nop
  b main
.size main, .-main

letter:
  .ascii "c"
  .ascii "a"

@   @ Part4: encrypt a string
@   ldr r0, =string_here
@ keep_encrypt:
@   bl encode_letter
@   ldrb r4, [r0]
@   add r0, 1
@   @ check if it reaches the end 0x00
@   cmp r4, 0
@   beq end_encrypt
@   b keep_encrypt
@ end_encrypt:
@   nop
@ test:
@   ldrb r5, [r0]
@   sub r0, 1
@   b test
@ inf_loop:
@   ldrb r6, [r0]
@   nop
@   b inf_loop
@ @ args:
@ @ r0: character's memory location
@ @ returns:
@ @ nothing. side effect: changed that character in that address by shifting the letter one position backwards. e.g. 'b' -> 'a', 'a' -> 'z'
@ encode_letter:
@   push {lr}
@   ldrb r1, [r0]
@   cmp r1, 97
@   blt return_encoded
@   cmp r1, 122
@   bgt return_encoded
@   sub r1, 1
@   cmp r1, 96
@   beq wrap_to_z
@   b return_encoded
@ wrap_to_z:
@   mov r1, 122
@ return_encoded:
@   strb r1, [r0]
@   pop {lr}
@   bx lr

@   nop
@   b main
@ .size main, .-main

@ .data
@ string_here:
@   .asciz "Hello"

@ .align 2

```
