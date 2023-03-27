#1. Create 3 Arrays
	#1 array to hold total rain for all years
	#2 array to hold rain averages in inches
	#3 array to hold rain averages in centimeters
#2. Create counters and limits, in order to move through the first array
#3. Every 12 floats in the total rain array is 1 year, so we take the average for every 12 values
#4. We branch after 12 iterations, divide total by 12 and place value into new array
#5. Convert to centimeters using new array after.
#6. Print table of both arrays with year calculated by array index
#7. Print highest and lowest rainfall years calculated by array index and array comparison functions
#8. Compare array amounts (inches) to 49.5 (average rainfall amount) to and increment to see how many greater  or less than



###Predetermined values###
#$t0	Base address
#$t1	Rain in feet array
#$t2	Avg rain in inches array
#$t3	Avg rain in centimeters array
#$t4	Value for amount of months in a year
#$t5	Count of amount of months
#$f1	Float value for # of months (12.0)
#$t6	Total amount of values in rain array
#$s1	Used to limit array printing to 10
#$s2	Used as a general prupose counter which starts at 0
#$f17	Holds conversion rate from inches to centimeters
#$t9	Holds the starting year 2013
#$f23	Annual rain average of 49.5
#$f5	Holds the total rain for a year 
################################



###Changing Values###
#$f4	Holds index value for the rain array conversions
#$f7	Holds the average for the rain (inches) in a year
#$f16	Holds the inches array values for conversion
#$f18	Holds converted rain amount in centimeters
#$f20	Holds initial index for comparing values
#$f21	Holds next index for comparing values
#s5	Holds the iteration # for highest/lowest element found
#s3	Holds the highest/lowest rainfall year
#f24	Holds the average rain for each year in array to compare
#$t8	Holds # of years with rain average above 49.5
#$s0	Holds # of years with rain average below 49.5
################################

	.data

#Rain array (in feet)
rain:	.float 		2.76, 3.08, 2.72, 2.35, 4.36, 10.04, 4.92, 4.53, 2.22, 0.6, 3.06, 4.87,
			2.86, 5.19, 4.51, 3.19, 6.9, 3.93, 7.15, 1.89, 1.23, 4.13, 4.59, 5.34,
			5.02, 2.57, 4.65, 2.24, 1.44, 6.13, 2.7, 1.21, 3, 4.3, 1.59, 4.67,
			4.93, 4.32, 1.6, 1.31, 4.56, 2.35, 7.15, 0.85, 1.7, 3.07, 2.8, 4.17,
			4.61, 1.51, 3.54, 6.29, 7.32, 5.36, 4.08, 7.63, 1.78, 5.2, 2.1, 1.94,
			2.17, 6.67, 5.54, 5.04, 5.85, 4.96, 4.3, 4.18, 8.82, 3.2, 8.72, 5.81,
			5.1, 3.47, 4.38, 3.96, 7.15, 5.45, 6.31, 4.58, 1.52, 5.18, 2.13, 7.2,
			2.02, 3.08, 4.54, 4.21, 2.33, 2.91, 11.39, 5.71, 4.61, 5.66, 3.47, 5.21,
			2.21, 5.64, 2.87, 2.5, 4.17, 3.38, 5.02, 6.28, 10.02, 7.37, 1, 1.45,
			4.56, 3.67, 3.41, 5.37, 7.43, 3.52, 1, 4.58, 2.69, 6.63, 2.43, 4.43

#Arrays for holding inches and centimeters		
inch: .space	40
cent:   .space 	40

#Prompts for formatting output
änDerror:	.asciiz		"	             	"	#Strange error when printing which places än½D in whatever prompt is after arrays
								#Definitely due to space after arrays but not sure how to approach it.
highest:.asciiz		": Highest annual rainfall of "
lowest: .asciiz		": Lowest annual rainfall of "
inches:	.asciiz		" inches."
below:	.asciiz		"Number of years with below average rainfall: "
above:	.asciiz		"Number of years with above average rainfall: "
space:	.asciiz		"		"
table:	.asciiz		"year		rain (inches)	     rain (cm)\n"


#Values to be loaded and used for calculations
conversion:	.float	2.54
average:	.float	49.5


	.globl main
	.text
	
main:


	#Base Addr
	lui	$t0, 0x1001	#Base address of data section
	
	#Addr of rain array
	addi	$t1, $t0, 0	#Move rain (in feet) array into $t1
	
	#Addr of inches array
	addi	$t2, $t0, 480	#Move rain avg (in inches) array into $t2 (120*4)
	
	#Addr of CM array
	addi	$t3, $t0, 524	#Move rain avg (in centimeters) array into $t3 (480+44)
	
	
	#Create Limit for each year
	li	$t4, 12		#Number of months in each year into $t4
	li	$t5, 0		#Counter of months placed into $t5
	
	#For division with floats
	mtc1	$t4,$f1		#Move 12 to coprocessor 1 for float calculations
	cvt.s.w	$f1,$f1		#Convert to float
	
	#Create limit for looping the whole size of array (120 floats)
	li	$t6, 120	#Total rain array values
	
	#PRINTING ARRAY Counters
	li	$s1,10		#Used to print 10 values from an array
	li	$s2,0		#Counter (up to 10) for printing an array 
	
	#Conversion rate
	l.s	$f17,conversion #Holds conversion rate (from inches to centimeters)
	
	#Year Number	
	li	$t9,2013	#Initial year placed into $t9
	
	#Average of 49.5
	l.s	$f23, average	#Load the annual rain average into $f23
	
	
	
#Begin loop to cycle through rain array to convert to inches and then find an store after every 12 iterations.
Years:
	bge	$s2, $t6, Reset	#Run through 120 iterations, one for each value in the array
	
	
	
	#Loading array[i] into f4
	l.s	$f4,0($t1)	#Store the array elements into $f4

	mul.s	$f4, $f4, $f1	#Convert foot value into inches for each element
	
	#array[i++]
	addi	$t1,$t1,4	#Increment the rain array
	
	#Increment year counter and loop counter
	addi	$t5,$t5,1	#Increment month count
	addi	$s2,$s2,1	#Increment element counter
	
	#Master register for each years total
	add.s	$f5,$f5,$f4	#Add converted rain amount to total (for the year)
	
	
	#If 12 collected, move to next year
	bge	$t5,$t4	Inches	#Every 12 elements, move to store
	
	#Else, continue
	b	Years		#Else, continue adding to the total


#Calculates averages and places them into inches array
Inches:
	
	s.s	$f5, 0($t2)	#Store the total amount of rainfall for the year in inches array
	
	mtc1 $zero, $f5
	
	mtc1 $zero, $f4
	
	addi	$t2,$t2,4	#Increment the inches arrray
	
	li	$t5,0		#Reset the month counter
	b	Years		#Branch back to continue with next year rainfall
	
#Starting at beginning index of inches array
#Converts each value to centimeters and places into centimeters array
Reset:
	#Reset index of inches array
	li	$t2,0		#Emptying $t2 of array
	addi	$t2, $t0, 480	#Inch [0]
	li	$s2,0		#Reset iteration counter
	
Convert:
	beq	$s2,$s1, Reset2	#After 10 iterations branch forward
	
	
	l.s	$f16,0($t2)	#Load Inch[i] into $f16
	
	mul.s	$f18,$f16,$f17	#Multiply Inch[i] * 2.54 into $f18
	
	s.s	$f18,0($t3)	#Move converted element into Cent[i]
	
	addi	$t3,$t3,4	#Increment Cent[i++]
	addi	$t2,$t2,4	#Increment Inch[i++]
	addi	$s2,$s2,1	#Increement loop counter
	
	b	Convert		#Branch to  beginning to complete next conversion
	
Reset2:
	
	li	$t2,0		#Sets $t2 to 0
	addi	$t2, $t0, 480	#Inches [0]
	
	
	li	$t3,0		#Sets $t3 to 0
	addi	$t3,$t0,524	#Cent [0]


	li	$s2,0		#Reset loop counter to 0
	
	#Print Table Header
	li	$v0, 4		#System call to print string
	la	$a0, table	#Print the heading for the table
	syscall			#Syscall to complete


#Printing the table of array values
PrintTabel:
	beq	$s2,$s1, Reset3	#If the loop counter is equal to 10, move to next step
	
	#Setting up to print year first
	li	$v0, 1		#System call to print integer
	move	$a0, $t9	#Print the year (starting in 2013)
	syscall			#System call to complete
	

	addi	$t9,$t9,1	#Increment year by 1

	
	
	li	$v0, 4		#Syscall to print string
	la	$a0, space	#Prints blank tabs to format table
	syscall			#System call to complete
	
	
	#Pulling and Printing Inches Array
	l.s	$f12,0($t2)	#Takes inch[i] element into $f12
	li	$v0, 2		#System call to print float in $f12
	syscall			#System call to complete
	
	
	#Random float lengths had me stuck on how to format the second column
	li	$v0, 4		#Syscall to print string
	la	$a0, space	#Prints blank tabs to format table
	syscall			#System call to complete
	
	#Printing From CM array
	l.s	$f12,0($t3)	#Take cent[i] element into $f12
	li	$v0, 2		#System call to print float in $f12
	syscall			#System call to complete
	
	
	addi	$s2,$s2,1	#Increments loop counter
	
	#printing newline
	li	$v0,11		#System call to print character
	li	$a0,10		#Newline character to print
	syscall			#System call to complete
	
	#Move Forward in arrays
	addi	$t2,$t2,4	#Increment Inch[i++]
	addi	$t3,$t3,4	#Increment Cent[i++]
	
	b	PrintTabel	#Branch to beginning to print next row
	
	
Reset3:
	li	$t2,0		#Set $t2 to 0 for reset
	addi	$t2, $t0, 480	#Reset array to Inch[0]
	
	
	li	$s2,1		#Reset array element counter
	
	li	$t9, 2012	#Set the year back to 2012 to account for $s2 being 1
	
	l.s	$f20, 0($t2)	#Load the first index of inches array into f20 for comparing
	

Highest:
	beq	$s2, $s1, PrintHighest	#Cycles through 10 iterations for each value in inches array, branch to print when finished
	
	l.s	$f21, 4($t2)		#Loads the Inch[i++] index into f21
	
	addi	$s2,$s2,1		#Incrememnt element counter
	
	addi	$t2,$t2,4		#Move forward Inch[i++]
	
	c.lt.s	$f20,$f21		#If Inch[i] is less than Inch[i+1] set flag to true
	bc1t	SwitchHigh		#If flag true than branch
	
	b	Highest			#Branch to repeat loop keeping higher value (f20) for comparisons
	
	
	
SwitchHigh:
	
	#Switch Process
	mov.s	$f20,$f21		#Moves higher value (f21) into f20 for comparisons
	
	mov.s	$f12, $f20		#Prepares value to print (if this iteration is the highest value)
	
	move	$s5, $s2		#Moves iteration # into s5 to calculate year (if this is the highest value)
	
	b	Highest			#Branch back to loop for more comparisons

PrintHighest:

	#printing newline
	li	$v0,11			#System call to print character
	li	$a0,10			#Value for newline character
	syscall				#System call to complete
	
	
	add	$t3, $t9, $s5		#base year + Iteration # at highest found = highest year(t3)	
	
	#Printing out the year
	li	$v0, 1			#System call to print integer
	move	$a0, $t3		#Puts highest year into a0 to print
	syscall				#System call to complete
	
	#Highest Prompt
	li	$v0, 4			#System call to print string
	la	$a0, highest		#Loads address of highest prompt into a0
	syscall				#System call to complete print of a0
	
	#Printing rainfall
	li	$v0, 2			#System call to print float
	syscall				#Completes print of f12 (highest value)
	
	#Print inches prompt
	li	$v0, 4			#System call to print string
	la	$a0, inches		#Loads address of inches prompt into a0
	syscall				#System call to complete
	
	#printing newline
	li	$v0,11			#System call to print character
	li	$a0,10			#Move newline value into $a0
	syscall				#System call to complete
	
Reset4:
	
	li	$t2,0			#Set t2 to 0
	addi	$t2, $t0, 480		#Setting Inch index to Inch[0]
	
	
	li	$s2,1			#Set s2 to 1
	
	li	$t9, 2012		#Set year to 2012 to account for s2 being at 1
	
	
	l.s	$f20, 0($t2)		#Load first value of Inch[0] into f20 to compare
	
	
Lowest:
	beq	$s2, $s1, PrintLow	#If loop counter =10 iterations, branch to print
	
	l.s	$f21, 4($t2)		#Places Inch[i++] into f21 to compare
	
	addi	$s2,$s2,1		#Increment interation counter
	
	addi	$t2,$t2,4		#Increment Inch index
	
	c.lt.s	$f21,$f20		#If Inch[i+1] is less than Inch[i] set flag to true
	bc1t	SwitchLow		#If true branch to switch values
	
	
	b	Lowest			#Otherwise continue loop with f20 as lowest value

	
	
	
SwitchLow:
	
	#Switch Process
	mov.s	$f20, $f21		#Move lower value (f21) into f20
	mov.s	$f12, $f20		#Move f20 itno f12 to print later
	move	$s5, $s2		#Save increment # of lowest value to calculate year
	
	
	b	Lowest			#Branch back to loop to do comparison

PrintLow:
	
	add	$s3, $t9, $s5		#base year + Adding iteration # = lowest rain year	
	
	#Printing out the year
	li	$v0, 1			#System call to print integer
	move	$a0, $s3		#Move year into a0 to print
	syscall				#System call to complete
	
	#Highest Prompt
	li	$v0, 4			#System call to print string
	la	$a0, lowest		#Load address of lowest prompt into a0
	syscall				#System call to print the lowest prompt
	
	#Printing rainfall
	li	$v0, 2			#System call to print float
	syscall				#Prints value in f12 (lowest rain value)
	
	#Print inches prompt
	li	$v0, 4			#System call to print string
	la	$a0, inches		#Load address of inches prompt into a0
	syscall				#System call to print the  prompt
	
	
	
Reset5:
	
	li	$t2,0			#Set t2 to 0
	addi	$t2, $t0, 480		#Move t2 back to Inch[0] index
	
	
	li	$s2,0			#Reset counter from 10 to 0
	
ComparetoAvg:
	beq	$s2, $s1, Endprint	#If counter = 10 then move to ending print
	
	l.s	$f24, 0($t2)		#Load Inch[i] into f24
	
	div.s	$f24, $f24, $f1		#Divides the total inches of rain /12 for the average
	
	addi	$s2,$s2,1		#Increments element counter
	
	addi	$t2,$t2,4		#Increment Inch[i++]
	
	c.lt.s	$f23, $f24		#If average for year (f24) > 49.5 (f23) set flag to true
	bc1t	AddGr			#If true branch to increment greater than counter
	
	c.lt.s	$f24, $f23		#If average for year (f24) < 49.5 (f23) set flag to true
	bc1t	AddLw			#If true branch to increment less than counter
	
	
	
AddGr:

	addi	$t8, $t8, 1		#Increment greater than by 1
	
	b	ComparetoAvg		#Go back to loop to continue with next element
	
AddLw:
	
	addi	$s0, $s0, 1		#Increment less than by 1
	
	b	ComparetoAvg		#Go back to loop to continue with next element
	
	
Endprint:


	
	li	$v0,11			#System call to print character
	li	$a0,10			#Newline character moved into a0
	syscall				#System call to complete
	
	li	$v0, 4			#System call to print string
	la	$a0, above		#Moves above prompt into a0
	syscall				#System call to complete print
	
	li	$v0, 1			#System call to print integer
	move	$a0, $t8		#Moves year of highest (t8) into a0
	syscall				#System call to complete print
	
	
	li	$v0,11			#System call to print character
	li	$a0,10			#Newline character moved into a0
	syscall				#System call to complete
	
	li	$v0, 4			#System call to print string	
	la	$a0, below		#Moves below prompt into a0
	syscall				#System call to complete print
	
	li	$v0, 1			#System call to print integer
	move	$a0, $s0		#Moves year of highest (t8) into a0
	syscall				#System call to complete print
	
