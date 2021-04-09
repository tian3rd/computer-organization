# comp2300-2021-lab-2

<https://cs.anu.edu.au/courses/comp2300/labs/02-first-machine-code/>

## Q&A

1. What is `[]` in the assembly syntax, e.g., `ldr<c><q> <Rd>, [<Rb>], #+/-<offset>`?
   1. Square brackets indcate that the instruction should use the membory address in the register, e.g., `[r1]` tells the discoboard to use the membory address in `r1` for that instruction.
2. Why does the program counter `pc` start at address `0x8000188`?
3. What does `.hword` directive do?
   1. The `.hword` (short for half-word, since our discoboard's CPU uses 32-bit "words") puts a 16-bit nmber into your program.
4. The following code can set the memory value as expected, but once executed and debugged (instead of "hanging" without further operation), it fails, why?

   ```assembly
   main:
   .hword 0xdead
   .hword 0xbeef

   nop
   b main
   .size main, .-main
   ```

   1. In the disassembly view of `main` function, we get the following:

   ```main.cdasm
   0x08000188: ad de           	udf	#173	; 0xad
   0x0800018a: ef be           	bkpt	0x00ef
   ```

   This means the 'DEAD' tranlates to `udf`(undefined) directive (refer to manual A7.7.191), and 'BEEF' tranlates to `bkpt`(breakpoint) directive (refer to manual A7.7.17) which is the exactly reason why 'it fails', because the breakpoint "causes a DebugMonitor exception or a debug halt to occur..."

5. How might you figure out on the discoboard's Cortex-M4 CPU whether a 32-bit instruction is read as one 32-bit word or as two 16-bit half-words? (hint: refer to manual A5.1 or the cheat sheet)
   1. By specifying <q> tag which sets the Opcode size. `.N` means narrow code of 16-bit, while .W means wide code of 32-bit. If it is omitted, then you let the assembler choose.
6. Suppose we have the following code snippet, once executed and checked with the memory viewer in VSCode, what is the value between the first half word (shown as AD DE) and the second half word (shown as EF BE)?

   ```assembly
   main:
   @ first half word set to be AD DE using little endian
   .hword 0xdead

   @ instruction movs, what's the set value here in our memory? (refer to manual A7.7.75)
   movs r3, #9

   @ second half word
   .hword 0xbeef

   nop
   b main
   .size main, .-main
   ```

   - What if I change the instruction movs above to `mov r3, 9` instead?

7. How can you tell the specific encoding to the assembler when setting the constant?
   1. `#0b`: binary; `#0x`: hex; `#`: decimal
8. What's the difference between `.hword` and `.ascii` directives?
   1. `.ascii` directive stores the text into the progeam using ASCII encoding instead of hex number in `.hword` directive;
   2. Another difference is that `.hword` stores the normally using the little endian, e.g. `.hword 0xbe4a` will store `4a` first in lower address, then `be` in higher address. But `.ascii` stores text in another way, i.e. `.ascii "COPE"` stores hex value of `C` (`43`) first in lower address, then `O` (`4f`), then `P` (`50`), then `E` (`45`) at last. So when you load it to a register, the register will read as `45504f43`, while in contrast, the register will read as `be4a` for `.hword`.

## Great reading materials for ARM immediate value encoding

https://alisdair.mcdiarmid.org/arm-immediate-value-encoding/
