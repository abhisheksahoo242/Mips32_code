#Computer Architecture Assignment 1
#Question - Q6. Write a program in C to merge two arrays of same size sorted in decending order
#Note: We have assumed that the two input arrays maybe unsorted, and the final output array is sorted in decending order.
#Team 12 - 
# Abhishek Sahoo, CS19B1001
# Mutyala Immaniyelu, CS19B1019


.data
    space: .asciiz " "
    prompt1: .asciiz "Enter the size of array:\n"
    prompt2: .asciiz "Enter the 1st array (After each number you input, press enter):\n"
    prompt3: .asciiz "Enter the 2nd array (After each number you input, press enter):\n"
    prompt4: .asciiz "\nAfter merging and sorting, Output array:\n"

.text
.globl main

main:

    #Taking size of array input
    la			$a0, prompt1			    # Load address of prompt1 to $a0
    jal			print_string				# jump to print_string and save position to $ra
    li			$v0, 	5			        # $v0 = 5, 5 denotes for reading int from console
    syscall
    add			$s0,  $zero, $v0		    # $s0 = $zero + $v0, Store the size of array in $s0
    ble			$s0,  $zero, Exit	        # if $s0 <= 0 then jump to Exit, Invalid input!
    
    
    #Allocate space for 1st array
    sll			$a0, $s0, 2			        # $a0 = $s0 << 2, Multiply $a0 by 4,
                                            # $a0 stores size of array in bytes
    li			$v0, 9				        # $v0 = 9, For dynamically allocating an array of size $a0
    syscall
    add			$s1, $zero, $v0		        # $s1 = $zero + $v0, Store the starting location -
                                            # - of 1st array in $s1


    #Allocate space for 2nd array
    sll			$a0, $s0, 2			        # $a0 = $s0 << 2, Multiply $a0 by 4
    li			$v0, 9				        # $v0 = 9, For dynamically allocating an array of size $a0
    syscall
    add			$s2, $zero, $v0		        # $s2 = $zero + $v0, Store the starting location -
                                            # - of 2nd array in $s2

    #Taking input for the 1st array
    la			$a0, prompt2			    # Load address of prompt2 to $a0
    jal			print_string				# jump to print_string and save position to $ra
    add			$a0, $zero, $s1		        # $a0 = $zero + $s1, $a0 stores start address of 1st array
    add			$a1, $zero, $s0		        # $a1 = $zero + $s0, $a1 stores "n"
    jal			Array_input				    # jump to Array_input and save position to $ra
   
    #Taking input for the 2nd array
    la			$a0, prompt3			    # Load address of prompt3 to $a0
    jal			print_string				# jump to print_string and save position to $ra
    add			$a0, $zero, $s2		        # $a0 = $zero + $s2, $a0 stores start address of 1st array
    add			$a1, $zero, $s0		        # $a1 = $zero + $s0, $a1 stores "n"
    jal			Array_input				    # jump to Array_input and save position to $ra

    #Allocate space for resultant array
    sll			$a0, $s0, 3			        # $a0 = $s0 << 3, Multiplying by 8 (2*n*4bytes)
    li			$v0, 9				        # $v0 = 9
    syscall
    add			$s3, $zero, $v0		        # $s3 = $zero + $v0, Store the starting location -
                                            # - of 3rd array in $s3

    #Simply Copying both 1st and 2nd array into 3rd
    addi		$a0, $s1, 0			        # $a0 = $s1 + 0, $a0 now stores start address of 1st array
    addi		$a1, $s2, 0			        # $a1 = $s2 + 0, $a1 now stores start address of 2nd array
    addi		$a2, $s3, 0			        # $a2 = $s3 + 0, $a2 now stores start address of 3rd array
    addi		$a3, $s0, 0			        # $a3 = $s0 + 0, $a3 now stores length of array
    jal			Copy_Arrays				    # jump to Copy_Arrays and save position to $ra

    #Sort the Array
    addi		$a0, $s3, 0			        # $a0 = $s3 + 0, $a0 now stores start address of 3rd array
    sll			$a1, $s0, 1			        # $a1 = $s0 << 1, $a3 now stores length of 3rd array
    jal			SortArray				    # jump to SortArray and save position to $ra
    

    #Print The 3rd array
    la			$a0, prompt4			    # Load address of prompt4 into $a0
    jal			print_string				# jump to print_string and save position to $ra
    add			$a0, $zero, $s3		        # $a0 = $zero + $s3, $a0 now stores start address of 3rd array
    sll			$a1, $s0, 1			        # $a1 = $s0 << 1
    jal			Print_Array				    # jump to Print_Array and save position to $ra

    j		Exit				            # jump to Exit
    
#----------------------------------------------------------------------------------------------------#

print_int: #Function to print an integer to console
    li			$v0, 	1			        # $v0 = 1, 1 denotes Syscall to print an integer to console
    syscall
    jr			$ra					        # jump to $ra,  return

#----------------------------------------------------------------------------------------------------#    

print_string: #Function to print a string to console
    li			$v0,    4				    # $v0 = 4, 4 denotes Syscall to print a string to console
    syscall
    jr			$ra					        # jump to $ra, return
    
#----------------------------------------------------------------------------------------------------#

Array_input: #Taking input an array of integers, Argument are start address of array and size of array 
    
    #$a0 has start address of the array
    #$a1 has the size of array ("n")

    add			$t0, $zero, $a0		        # $t0 = $zero + $a0, $to stores the start address of array 
    sll			$t1, $a1, 2			        # $t1 = $a1 << 2, Multiply by 4 to get size in bytes
    add			$t1, $t1, $t0		        # $t1 = $t1 + $t0, End of array address
    
    loop1: #For each iteration reads input from console
        beq	        $t0, $t1, loop1_end	    # if $t0 == $t1 then jump to loop1_end. 
        li			$v0, 5				    # $v0 =5
        syscall
        sw			$v0, 0($t0)		        # Store the number read in array
        addi		$t0, $t0, 4			    # $t0 = $t0 + 4, incrementing $t0
        j		    loop1				    # jump to loop1
        

    loop1_end:
        jr			$ra					    # jump to $ra

#-----------------------------------------------------------------------------------------------------#

Print_Array: #Function to print an array of integers, Argument are start address of array and size of array 
   
    #$a0 has start address of the array
    #$a1 has the size of array ("n")

    add			$t0, $zero, $a0		        # $t0 = $zero + $a0, $to stores the start address of array   
    sll			$t1, $a1, 2			        # $t1 = $a1 << 2, Multiply by 4 to get size in bytes
    add			$t1, $t1, $t0		        # $t1 = $t1 + $t0,  End of array address
    add			$t7, $zero, $ra		        # $t7 = $zero + $ra, Storing content of $ra in $t7 temporarily        
    

    loop2: #For each iteration prints a number in array
        bge	        $t0, $t1, loop2_end	    # if $t0 >= $t1 then go to loop2_end
        lw			$a0, 0($t0)			    # Store the number from location $t0 in $a0 register
        jal			print_int				# jump to print_int and save position to $ra
        la			$a0, space			    # Load address of space in $a0
        jal			print_string			# jump to print_string and save position to $ra
        addi		$t0, $t0, 4			    # $t0 = $t0 + 4, Incrementing $t0
        j			loop2				    # jump to loop2
        

    loop2_end:
        add			$ra, $zero, $t7		    # $ra = $zero + $t7, Restoring the contents of $ra
        jr			$ra					    # jump to $ra

#-------------------------------------------------------------------------------------------------------#

Copy_Arrays: #Simpy copying the contents of both array into the 3rd array

    #$a0 contains start address of 1st array
    #$a1 contains start address of 2nd array 
    #$a2 contains start address of 3rd array
    #$a3 contains size of 1st array ("n")

    add			$t0, $zero, $a0		        # $t0 = $zero + $a0, $t0 has start address of 1st array
    add			$t1, $zero, $a1		        # $t1 = $zero + $a1, $t1 has start address of 2nd array
    add			$t2, $zero, $a2		        # $t2 = $zero + $a2, $t2 has start address of 3rd array
    add			$t3, $zero, $a3		        # $t3 = $zero + $a3, $t3 stores the size of the array
    
    #Copying first array into 3rd array 
    sll			$t4, $t3, 2			        # $t4 = $t3 << 2, multiply by 4 to get size in bytes
    add			$t4, $t4, $t0		        # $t4 = $t4 + $t0, $t4 stores End of array address
    
    loop3: #For each iteration, an integer is copied from first array to 3rd
        bge			$t0, $t4, loop3_end	    # if $t0 >= $t4 then jump to loop3_end
        lw			$t5, 0($t0)			    # Loading a number from 1st array to $t5
        sw			$t5, 0($t2)			    # Storing a number in $t5 to 3rd array
        addi		$t0, $t0, 4			    # $t0 = $t0 + 4, Incrementing $t0
        addi		$t2, $t2, 4			    # $t2 = $t2 + 4, Incrementing $t2
        j			loop3				    # jump to loop3
         

    loop3_end: #Intializing loop variables for loop4
        sll			$t4, $t3, 2			    # $t4 = $t3 << 2
        add			$t4, $t4, $t1		    # $t4 = $t4 + $t1
    
    #Copying Second array into 3rd array 
    loop4: #For each iteration, an integer is copied from second array to 3rd
        bge			$t1, $t4, loop4_end	    # if $t1 >= $t4 then jump to loop4_end
        lw			$t5, 0($t1)			    # Loading a number from 2nd array to $t5
        sw			$t5, 0($t2)			    # Storing a number in $t5 to 3rd array
        addi		$t1, $t1, 4			    # $t1 = $t1 + 4, Incrementing $t1
        addi		$t2, $t2, 4			    # $t2 = $t2 + 4, Incrementing $t2
        j			loop4				    # jump to loop3 

    loop4_end:
        jr			$ra					    # jump to $ra, Return
         
#--------------------------------------------------------------------------------------------------------#

SortArray: #Function to sort an array of numbers in decending order

    # $a0 stores start of the array
    # $a1 stores length of the array ("n")

    # This function finds the largest number in the array at put it in the top then repeats until complete array is sorted
    #Equivalent C code is for this function 

    # for(int i = 0 ; i < 2*n-1 ; i ++)
    # {
    #    int max_index = i ;
    #    for(int j = i ; j < 2*n; j++)
    #    {
    #        if(C[j] > C[max_index])
    #            max_index = j;
    #    }
    #    int temp = C[i];
    #    C[i] = C[max_index];
    #    C[max_index] = temp; 
    # }

    addi		$t0, $a0, 0			        # $t0 = $a0 + 0, $t0 stores start address of the array
    sll			$t1, $a1, 2			        # $t1 = $a1 << 2, $t1 stores size in bytes
    addi		$sp, $sp, -12		        # $sp = $sp - 12, Pushing down the stack
    sw			$s4, 0($sp)			        # Storing content of $s4
    sw			$s5, 4($sp)			        # Storing content of $s5
    sw			$s6, 8($sp)			        # Storing content of $s6
    
    
    #Initializing loop variables
    addi		$t2, $zero, 0			    # $t2 = $zero + 0, $t2 denotes "i" in C program
    addi		$t3, $t1, -4			    # $t3 = $t1 - 4, $t3 stores 4*(2*n-1), It is condtion for $t2("i")
    addi		$t5, $t1, 0			        # $t5 = $t1 + 0, $t5 stores 4*2*n, It is condition for "j" 
    
    loop5: #Outer for loop, with loop variable "i"
        bge			$t2, $t3, loop5_end	    # if $t2 >= $t3 then jump to loop5_end
        addi		$t6, $t2, 0			    # $t6 = $t2 + 0, $t6 denotes "max_index" and is initialized to "i"
        addi		$t4, $t2, 0			    # $t4 = $t2 + 0, $t4 denotes "j" and is initialized to "i"   
        j			loop6				    # jump to loop6
        
    loop5_end: #Marks end of loop5 and of function as well
        lw			$s4, 0($sp)			    # Restore contents of $s4
        lw			$s5, 4($sp)			    # Restore contents of $s5
        lw			$s6, 8($sp)			    # Restore contents of $s6
        addi		$sp, $sp, 12		    # $sp = $sp + 12, Pop the stack
        jr			$ra					    # jump to $ra, Return
        
    loop6: #Inner loop with loop variable "j"
        bge			$t4, $t5, Swap	        # if $t4 >= $t5 then jump to swap
        add			$s6, $t4, $t0		    # $s6 = $t4 + $t0      
        lw			$s4, 0($s6)			    # $s4 stores value of C[j]
        add			$s6, $t6, $t0		    # $s6 = $t6 + $t0
        lw			$s5, 0($s6)			    # $s5 stores value of C[max_index]
        sgt         $t7, $s4, $s5           # If $s4 > $s5, set $t7 to 1
        bne			$t7, $zero, ifCondition	# if $t7 != $zero then jump tp ifCondition
        addi		$t4, $t4, 4			    # $t4 = $t4 + 4, Incrementing $t4 or "j"
        j			loop6				    # jump to loop6
        
    Swap: #This label denotes the swap after inner loop
        add			$s6, $t2, $t0		    # $s6 = $t2 + $t0, $s6 stores address of C[i] 
        add			$s5, $t6, $t0           # $s5 = $t6 + $t0, $s5 stores address of C[max_index]
        lw			$t7, 0($s6)			    # Load contents of $s6 to $t7
        lw			$s4, 0($s5)			    # Load contents of $s5 to $s4
        sw			$s4, 0($s6)			    # Store contents of $s4 to $s6
        sw			$t7, 0($s5)			    # Store contents of $t7 to $s5
        addi		$t2, $t2, 4             # Incrementing $t2
        j			loop5				    # jump to loop5
        

    ifCondition: #This label denotes the body of if in C program
        addi		$t6, $t4, 0			    # $t6 = $t4 + 0, Set $t6(max_index) to $t4(j)
        addi		$t4, $t4, 4			    # $t4 = $t4 + 4, Increment $t4
        j			loop6				    # jump to loop6

#-----------------------------------------------------------------------------------------------------------#

Exit:
    li			$v0, 10 				    # $v0 = 10, 10 denotes systemcall to end the program
    syscall

#-----------------------------------------------------------------------------------------------------------#