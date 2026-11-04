.data
# Reserve 16 × 16 words for the bitmap.
framebuffer: .space 1024

.text
.globl main

main:
    # Starting coordinates: x = 2, y = 3
    li s0, 2                  # x
    li s1, 3                  # y

    la s2, framebuffer        # address of the first display unit
    li s3, 16                 # grid width in display units
    li s4, 0x00FF0000         # red: 0x00RRGGBB

    # Calculate address = base + 4 * (y * width + x)
    mul t0, s1, s3            # t0 = y * width
    add t0, t0, s0            # t0 = y * width + x
    slli t0, t0, 2            # multiply pixel index by 4 bytes
    add t1, s2, t0            # t1 = address of pixel (x, y)

    sw s4, 0(t1)              # draw the red pixel

    # Pause for one second so the starting position is visible.
    li a0, 1000
    li a7, 32                 # RARS sleep service
    ecall

    # Erase the old pixel.
    sw zero, 0(t1)            # black background

    # Move one unit to the right.
    addi s0, s0, 1            # x = x + 1

    # Recalculate the address for the new coordinates.
    mul t0, s1, s3
    add t0, t0, s0
    slli t0, t0, 2
    add t1, s2, t0

    sw s4, 0(t1)              # draw at the new position

    # End the program.
    li a7, 10
    ecall