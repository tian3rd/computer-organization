# Attempted answers (included code snippets)

> As well as some questions that may need special attention.

1. conditional codes

   1. A, B, C, D
   2. Hint: look it up in the [cheatsheet](../arm-assembly-cheat-sheet.pdf) `conditional codes` section

2. digital logic circuit question

   1. B, C, D

3. interrupts

   1. A, B, C, D, F, G
   2. Hints:
      1. The previous value of `r0` has been saved on the stack by the NVIC: correct.
      2. The previous value of `r6` has been saved on the stack by the NVIC: if there's a `r6` in the first place
      3. After returning from an interrupt handler, your program will have to restore `r0-r3`: scratch registers are popped out from the stack. (refer to p290)
      4.

4.
