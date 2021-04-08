# comp2300-2021-lab-2

<https://cs.anu.edu.au/courses/comp2300/labs/02-first-machine-code/>

## Q&A

1. What is `[]` in the assembly syntax, e.g., `ldr<c><q> <Rd>, [<Rb>], #+/-<offset>`?
   1. Square brackets indcate that the instruction should use the membory address in the register, e.g., `[r1]` tells the discoboard to use the membory address in `r1` for that instruction.
2. Why does the program counter `pc` start at address `0x8000188`?
3. What does `.hword` directive do?
   1. The `.hword` (short for half-word, since our discoboard's CPU uses 32-bit "words") puts a 16-bit nmber into your program.
4.
