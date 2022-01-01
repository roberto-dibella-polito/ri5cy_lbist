	.section .text
	.global _sbst_boot
	.type _sbst_boot, @function

_sbst_boot:
	//add sp, sp, 16		// this creates space in the stack

	lui	x31, %hi(__TEST_DATA_START)
	addi	x31, x31, %lo(__TEST_DATA_START)
	
	// TODO: preserve all non-volatile registers (use section .TEST_DATA)
	
	// Store everything starting from __TEST_DATA_START+4 (the first one will be used to store the result)
	// -> already loaded into a0
	
	sw x1, 1*4(x31)
	sw x2, 2*4(x31)
	sw x3, 3*4(x31)
	sw x4, 4*4(x31)
	sw x5, 5*4(x31)
	sw x6, 6*4(x31)
	sw x7, 7*4(x31)
	sw x8, 8*4(x31)
	sw x9, 9*4(x31)
	sw x10, 10*4(x31)
	sw x11, 11*4(x31)
	sw x12, 12*4(x31)
	sw x13, 13*4(x31)
	sw x14, 14*4(x31)
	sw x15, 15*4(x31)
	sw x16, 16*4(x31)
	sw x17, 17*4(x31)
	sw x18, 18*4(x31)
	sw x19, 19*4(x31)
	sw x20, 20*4(x31)
	sw x21, 21*4(x31)
	sw x22, 22*4(x31)
	sw x23, 23*4(x31)
	sw x24, 24*4(x31)
	sw x25, 25*4(x31)
	sw x26, 26*4(x31)
	sw x27, 27*4(x31)
	sw x28, 28*4(x31)
	sw x29, 29*4(x31)
	sw x30, 30*4(x31)
	sw x31, 31*4(x31)

	// TODO: disable interrupts (if they were enabled)
	
	// Read the CSR register
	
	// t0 - Contains the value of MEI ( Machine Interrupt Register, bit 3 of MSTATUS )
	// t1 - Index of the loop	

	csrr 	t0, 0x300		// read the MSTATUS CSR
	andi 	t0, t0, 0x008		// mask to select only the MEI bit
	beqz 	t0, proc		// if the result is 0, no clear is needed -> jump
	csrci 	0x300, 0x008		// clear bit	
	
proc:		
	// here are some random instructions...
	// la		t0, RF_PATTERNS
	// lw		t1,	0*4(t0)  	
	// lw		t2,	1*4(t0)

	// here I used tX registers, you should do it for all x1-x31

	// Save the content of t0 into TEST_DATA
	// We will not use the information of the previous state	
	sw	t0, 32*4(x31)
	
	// Retrieve the RF patterns
	la	x31,RF_PATTERNS
	lw	x1, 0*4(x31)
	lw	x2, 1*4(x31)
	lw	x3, 2*4(x31)
	lw	x4, 0*4(x31)
	lw	x5, 1*4(x31)
	lw	x6, 2*4(x31)
	lw	x7, 0*4(x31)
	lw	x8, 1*4(x31)
	lw	x9, 2*4(x31)
	lw	x10, 0*4(x31)
	lw	x11, 1*4(x31)
	lw	x12, 2*4(x31)
	lw	x13, 0*4(x31)
	lw	x14, 1*4(x31)
	lw	x15, 2*4(x31)
	lw	x16, 0*4(x31)
	lw	x17, 1*4(x31)
	lw	x18, 2*4(x31)
	lw	x19, 0*4(x31)
	lw	x20, 1*4(x31)
	lw	x21, 2*4(x31)
	lw	x22, 0*4(x31)
	lw	x23, 1*4(x31)
	lw	x24, 2*4(x31)
	lw	x25, 0*4(x31)
	lw	x26, 1*4(x31)
	lw	x27, 2*4(x31)
	lw	x28, 0*4(x31)
	lw	x29, 1*4(x31)
	lw	x30, 2*4(x31)
	lw	x31, 0*4(x31)

	// Test of the register
	// Usage of x1 as the accumulation register
	add 	x1, x1, x2
	add	x1, x1, x3
	add	x1, x1, x4
	add 	x1, x1, x5
	add	x1, x1, x6
	add	x1, x1, x7
	add 	x1, x1, x8
	add	x1, x1, x9
	add	x1, x1, x10
	add 	x1, x1, x11
	add	x1, x1, x12
	add	x1, x1, x13
	add 	x1, x1, x14
	add	x1, x1, x15
	add	x1, x1, x16
	add 	x1, x1, x17
	add	x1, x1, x18
	add	x1, x1, x19
	add 	x1, x1, x20
	add	x1, x1, x21
	add	x1, x1, x22
	add 	x1, x1, x23
	add	x1, x1, x24
	add	x1, x1, x25
	add 	x1, x1, x26
	add	x1, x1, x27
	add	x1, x1, x28
	add 	x1, x1, x29
	add	x1, x1, x30
	add	x1, x1, x31
		
	// write the result (check label 'test_result') 
		
	// Result is now stored into x1
	// Retrieve index for test_result
	la	x2, test_result
	sw	x1, 0(x2)

	// TODO: restore non-volatile registers
	
	// Load again the __TEST_DATA_START
	la	x31, __TEST_DATA_START
	
	// Retrieve data from memory
	
	
	lw x1, 1*4(x31)
	lw x2, 2*4(x31)
	lw x3, 3*4(x31)
	lw x4, 4*4(x31)
	lw x5, 5*4(x31)
	lw x6, 6*4(x31)
	lw x7, 7*4(x31)
	lw x8, 8*4(x31)
	lw x9, 9*4(x31)
	lw x10, 10*4(x31)
	lw x11, 11*4(x31)
	lw x12, 12*4(x31)
	lw x13, 13*4(x31)
	lw x14, 14*4(x31)
	lw x15, 15*4(x31)
	lw x16, 16*4(x31)
	lw x17, 17*4(x31)
	lw x18, 18*4(x31)
	lw x19, 19*4(x31)
	lw x20, 20*4(x31)
	lw x21, 21*4(x31)
	lw x22, 22*4(x31)
	lw x23, 23*4(x31)
	lw x24, 24*4(x31)
	lw x25, 25*4(x31)
	lw x26, 26*4(x31)
	lw x27, 27*4(x31)
	lw x28, 28*4(x31)
	lw x29, 29*4(x31)
	//lw x30, 30*4(x31)

	// TODO: restore interrupts (if they were active before!)
	
	// !! Before loading the last register from memory, restore the MSTAT!
	lw 	x30, 32*4(x31)
	beqz	x30, end
	csrsi	0x300, 0x008	

end:
	lw	x30, 30*4(x31)
	lw 	x31, 31*4(x31)
	ret


// -------------------------------------
	.section ".TEST_DATA", "aw"
	.global test_result

test_result:
	.space 4
// Examples:
//variable1:	(4 * 4bytes)
//	.space 0x10
//variable2:
//	.space 4

// -------------------------------------
	.section ".TEST_RODATA", "a"

RF_PATTERNS:
	.long 0x12345678
	.long 0xcafecafe
	.long 0xdeadbeef

OTHER_PATTERNS:
	.long 0x0
	.long 0x0
