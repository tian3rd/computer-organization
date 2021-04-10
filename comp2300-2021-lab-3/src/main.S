.syntax unified
.global main

.type main, %function
main:

  @ ex1. creating your pokenmon
@   @ ex1 starts here
@   mov r0, #100
@   @ ex1 ends here

  @ ex2. healing your pokenmon
@   @ ex2 starts here
@   mov r0, #100
@   b healing_pokenmon
@ healing_pokenmon:
@   add r0, #50
@   b healing_pokenmon
@   @ ex2 ends here

  @ ex3. status flags and condition codes
@   @ ex3 starts here
@   b exercise_3
@   @ ex3 ends here

  @ ex4. enriching our game world
@   @ ex4 starts here
@   mov r0, #100
@   mov r1, #123
@ healing_pokenmon:
@   add r0, #50
@ pokemon_attack:
@   subs r1, #40
@   bgt pokemon_attack
@   ble pokemon_wins
@ pokemon_wins:
@   nop
@   b pokemon_wins
@   @ ex4 ends here  

  @ ex5. the empire fights back
@   @ ex5 starts here
@   mov r0, #100
@   mov r1, #123
@ healing_pokenmon:
@   add r0, #50
@ new_round:
@ pokemon_attack:
@   subs r1, #40
@   bgt enemy_attack
@   ble pokemon_wins
@ enemy_attack:
@   subs r0, #60
@   bgt new_round
@   ble enemy_wins
@ pokemon_wins:
@   nop
@   b pokemon_wins 
@ enemy_wins:
@   nop
@   b enemy_wins
@   @ ex5 ends here

  @ ex6. conditionals and branching
  @ ex6 starts here
  
  @ ex6 ends here

@ a simple infinite loop
end_loop:
  nop
  b end_loop
.size main, .-main

@ a place for your to complete exercise 3. uncomment line 6 when you're ready to start working on it!
exercise_3:
  @ set the negative flag
  @... your instruction(s) go here ...

  @ set the zero flag
  @... your instruction(s) go here ...
  movs r0, #-1
  adds r0, #1

  @ set the carry flag
  @... your instruction(s) go here ...
  movs r0, #0x2
  adds r0, #0x3
  adds r0, #0xffffffff

  @ set the overflow flag
  @... your instruction(s) go here ...
  movs r0, #0x7fffffff
  adds r0, #0x1
  nop

  b exercise_3 @ loop back to the beginning of this section--we don't want to fall off the end of the world!
