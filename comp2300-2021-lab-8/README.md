# comp2300-2021-lab-8

<https://cs.anu.edu.au/courses/comp2300/labs/08-data-structures/>

## Q&A

1. Review the use of `.ascii`, `.set`, `.word`, `.data`, .`asciz`, `.align`, `ascii` directives.
2. Beware that `ldr` operation is loading 4 bytes (or a `word`) every time. So for `asciz` directive for example, it'll load 4 letters at a time.
3. Difference between `ascii` and `asciz`.
4. Do you have to put a `0` in the end to check if you loop through the whole string? Is there an alternative? (try add a label and use that address to calculate the length)
5.
