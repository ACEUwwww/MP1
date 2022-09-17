
# mp1.S - missile-command version
# Good luck, and have fun!

.data
	
    # Constants for accessing the fields of a struct missile, 
    # struct missile is defined in rtc.h and mp1.h

	NEXT 	  = 0
	X	  = 4
	Y	  = 8
	VX	  = 12
	VY	  = 16
	DEST_X	  = 20
	DEST_Y	  = 24
	EXPLODED  = 28
	C	  = 32

    # Character to draw for an explosion - '@'
	# Character to draw for an empty space - ' '
	# Character to draw for a missile - '*'
	EXPLOSION = 64
	EMPTY = 32
	MISSILE_DRAW = 42
	CROSSHAIR_VALUE=43
	


# Data shared between this file and rtc.c helper functions

# This '.globl' directive makes these symbols visible externally
.globl mp1_missile_list, base_alive, mp1_score

mp1_missile_list:	.long 0x0	# Head of list pointer
base_alive:		.long 0x0	# Array of 3 bytes, plus a padding byte
mp1_score:		.long 0x0	# Player's current score


# Data private to this  file

base_pic:     	    .string "/^^^\\"	# Picture of a live base
dead_base_pic: 	    .string "xxxxx"	# Picture of a dead base
crosshairs_x:		.long 0x0	# X-position of the crosshairs
crosshairs_y:		.long 0x0	# Y-position of the crosshairs

.text

# void mp1_poke(void);
# You can use this function to write to video memory.
#
# Interface: Register-based arguments (not C-style)
#    Inputs: %cl  - The byte you wish to write
#            %eax - Offset from the start of video memory that you wish
#                   to write to
#   Outputs: Text-mode video screen is written to at location %eax with
#            the byte in %cl
# Registers: Clobbers EDX

mp1_poke:
		movl    vmem_base_addr(,1),%edx
		movb    %cl,(%edx,%eax,1)
		ret

#   ----------------- Exported functions ---------------------

# void mp1_rtc_tasklet(unsigned long garbage);
# Performs three tasks:
#	(1) updates the list of missiles (implement this in update_missiles,
#           below, and call it from here).
#	(2) Redraw the bases - they may have been overwritten with missiles
#	(3) Redraw the crosshairs - it may have been overwritten with missiles
# Inputs   : none
# Outputs  : none
# Registers: Standard C calling convention

.globl mp1_rtc_tasklet
mp1_rtc_tasklet:
		pushl %ebp 				   # initialize for function
		movl %esp, %ebp 
		pushl %ebx
		pushl %esi
		pushl %edi

		movl mp1_missile_list,%esi # That gives the esi the first pointer to the struct missile.
		call update_missiles	   # My update function does everything to update a missile list,and it uses the global varible mp1_missile_list
								   # It receives no parameters and return no value
		


		# The second process is to deal with the cities
		Deal_city_tasklet:
		movl $base_alive,%ebx # ebx to the pointer of the array of base_alive
		# First deal with city1
		cmpb $0,0(%ebx)		# Compare M[ebx] with 0, to judge whether it is destroyed
		je city1_destroyed	# f it equals to 0,go to city1_destroyed
		jmp city1_alive		# f it is still alive, go to city1_alive

		city1_destroyed: # Here we draw the destroyed city to the screen
		movl $dead_base_pic,%esi
		pushl 0(%esi)
		pushl $24
		pushl $18
		call draw_character
		add $12,%esp
		pushl 1(%esi)
		pushl $24
		pushl $19
		call draw_character
		add $12,%esp
		pushl 2(%esi)
		pushl $24
		pushl $20
		call draw_character
		add $12,%esp
		pushl 3(%esi)
		pushl $24
		pushl $21
		call draw_character
		add $12,%esp
		pushl 4(%esi)
		pushl $24
		pushl $22
		call draw_character
		add $12,%esp
		jmp done_city1


		city1_alive:
		movl $base_pic,%esi
		pushl 0(%esi)
		pushl $24
		pushl $18
		call draw_character
		add $12,%esp
		pushl 1(%esi)
		pushl $24
		pushl $19
		call draw_character
		add $12,%esp
		pushl 2(%esi)
		pushl $24
		pushl $20
		call draw_character
		add $12,%esp
		pushl 3(%esi)
		pushl $24
		pushl $21
		call draw_character
		add $12,%esp
		pushl 4(%esi)
		pushl $24
		pushl $22
		call draw_character
		add $12,%esp
		jmp done_city1



		done_city1:
		# Here we deal with city2
		movl $base_alive,%ebx
		cmpb $0,1(%ebx)		# Compare M[ebx+1] with 0, to judge whether it is destroyed
		je city2_destroyed	# f it equals to 0,go to city1_destroyed
		jmp city2_alive		# f it is still alive, go to city1_alive
		
		city2_destroyed: # Here we draw the destroyed city to the screen
		movl $dead_base_pic,%esi
		pushl 0(%esi)
		pushl $24
		pushl $38
		call draw_character
		add $12,%esp
		pushl 1(%esi)
		pushl $24
		pushl $39
		call draw_character
		add $12,%esp
		pushl 2(%esi)
		pushl $24
		pushl $40
		call draw_character
		add $12,%esp
		pushl 3(%esi)
		pushl $24
		pushl $41
		call draw_character
		add $12,%esp
		pushl 4(%esi)
		pushl $24
		pushl $42
		call draw_character
		add $12,%esp
		jmp done_city2

		city2_alive:
		movl $base_pic,%esi
		pushl 0(%esi)
		pushl $24
		pushl $38
		call draw_character
		add $12,%esp
		pushl 1(%esi)
		pushl $24
		pushl $39
		call draw_character
		add $12,%esp
		pushl 2(%esi)
		pushl $24
		pushl $40
		call draw_character
		add $12,%esp
		pushl 3(%esi)
		pushl $24
		pushl $41
		call draw_character
		add $12,%esp
		pushl 4(%esi)
		pushl $24
		pushl $42
		call draw_character
		add $12,%esp
		jmp done_city2



		done_city2:
		 # Here we deal with city3
		movl $base_alive,%ebx
		cmpb $0,2(%ebx)		# Compare M[ebx+2] with 0, to judge whether it is destroyed
		je city3_destroyed	# f it equals to 0,go to city3_destroyed
		jmp city3_alive		# f it is still alive, go to city3_alive
		
		city3_destroyed: # Here we draw the destroyed city to the screen
		movl $dead_base_pic,%esi
		pushl 0(%esi)
		pushl $24
		pushl $58
		call draw_character
		add $12,%esp
		pushl 1(%esi)
		pushl $24
		pushl $59
		call draw_character
		add $12,%esp
		pushl 2(%esi)
		pushl $24
		pushl $60
		call draw_character
		add $12,%esp
		pushl 3(%esi)
		pushl $24
		pushl $61
		call draw_character
		add $12,%esp
		pushl 4(%esi)
		pushl $24
		pushl $62
		call draw_character
		add $12,%esp
		jmp done_city_draw

		city3_alive:
		movl $base_pic,%esi
		pushl 0(%esi)
		pushl $24
		pushl $58
		call draw_character
		add $12,%esp
		pushl 1(%esi)
		pushl $24
		pushl $59
		call draw_character
		add $12,%esp
		pushl 2(%esi)
		pushl $24
		pushl $60
		call draw_character
		add $12,%esp
		pushl 3(%esi)
		pushl $24
		pushl $61
		call draw_character
		add $12,%esp
		pushl 4(%esi)
		pushl $24
		pushl $62
		call draw_character
		add $12,%esp
		jmp done_city_draw



		done_city_draw:
		# Here we have dealt with all the cities.
		# We then move on to deal with our crosshair
		movl $43,%ecx
		pushl %ecx # draw CROSSHAIR_VALUE at (crosshairs_x,crosshairs_y)
		pushl crosshairs_y   
		pushl crosshairs_x 
		call draw_character		 
		addl $12,%esp
		jmp Done_tasklet



		Done_tasklet:
		popl %edi
		popl %esi
		popl %ebx
		leave
		ret

# void mp1_missile_remove(missile* p)
# delete a missile from linked list	
# Inputs   : a pointer to the missile to be deleted
# Outputs  : return a pointer to headpointer or the next pointer to the deleted one
# Registers: Standard C calling convention

.globl mp1_missile_remove 
mp1_missile_remove:		# This is space for remove function, the parameter should be a pointer to the struct of missiles
		pushl %ebp 		# Registers can be used, ebx,esi,edi,ecx,edx eax for return value
		movl %esp, %ebp # The return value will be the new head pointer or the next pointer to the deleted one.
		pushl %ebx
		pushl %esi
		pushl %edi      
						
		
		movl 8(%ebp),%ebx   # We choose ebx as the pointer to the missile to be deleted and esi to be the pointer to the head.
		movl mp1_missile_list,%esi
		cmpl %esi,%ebx
		je Head_pointer_remove
		jmp Loop_remove_1

		Head_pointer_remove:
		# Before remove it from the linked list, we first need to remove it from the screen by redraw it.
		movl $32,%ecx
		pushl %ecx
		movl Y(%esi),%ecx
		roll $16,%ecx
		andl $0x0000ffff,%ecx
		pushl %ecx
		movl X(%esi),%ecx
		roll $16,%ecx
		andl $0x0000ffff,%ecx
		pushl %ecx
		call draw_character # call the draw_character function and draw an empty at the location(x,y)
		addl $12,%esp

		movl %esi,%edi  	# Too free it ,we need another register to free address
		movl NEXT(%esi),%esi  # f it is a head pointer, just let the head pointer point to the next
		movl %esi,mp1_missile_list # We have to change the head pointer in the global too.
		pushl %edi
		call mp1_free        # Free the head pointer
		addl $4,%esp
		jmp Done_remove

		Loop_remove_1:
		movl NEXT(%esi),%ecx
		cmpl %ecx,%ebx # compare esi->next with the current pointer.
		je Euqal_remove
		movl NEXT(%esi),%esi # next[esi]->esi, go to the next pointer
		jmp Loop_remove_1   
		
		Euqal_remove:
		# Before remove it from the linked list, we frist need to remove it from the screen by redraw it.
		movl $32,%ecx
		pushl %ecx
		movl Y(%ebx),%ecx
		roll $16,%ecx
		andl $0x0000ffff,%ecx
		pushl %ecx
		movl X(%ebx),%ecx
		roll $16,%ecx
		andl $0x0000ffff,%ecx
		pushl %ecx
		call draw_character # call the draw_character function and draw an empty at the location(x,y)
		addl $12,%esp

		movl NEXT(%ebx),%ecx
		movl %ecx,NEXT(%esi) # f they are euqal,which means esi->next==ebx,then let esi->next=ebx->next and eliminate the struct ebx
		movl NEXT(%esi),%esi  # esi go to next pointer
		pushl %ebx
		call mp1_free # free struct ebx
		addl $4,%esp	

		Done_remove:
		movl %esi,%eax   # let the new headpointer or the pointer to the former struct as the return value.
		popl %edi
		popl %esi
		popl %ebx
		leave
		ret

# void draw_character(int x,int y,int char)
# delete a character to the screen	
# Inputs   : x,y,character to be drawn
# Outputs  : return nothing
# Registers: Standard C calling convention
.globl draw_character
draw_character:						# this function is for drawing operation. It recieves three parameter,x value, y value and the ascii code of the character you want to draw
		pushl %ebp 					# it returns nothing
		movl %esp, %ebp 			
		pushl %ebx
		pushl %esi
		pushl %edi

		movl 8(%ebp),%edi			# x->edi as column
		movl 12(%ebp),%edx			# y->edx as row
		imull $160,%edx,%edx 		# row*80characters*2bytes->edx (y*80*2->edx)
		imull $2,%edi,%edi 			# column*2bytes->edi			(x*2->edi)
		addl %edx,%edi 				# now edi stores the offset     (edi=160*y+2*x)
		movl %edi,%eax 				# pass it to %eax
		movb 16(%ebp),%cl 			# move the character to write to this 
		pushl %edx
		call mp1_poke 				# call mp1_poke to write an empty at (x,y)
		popl %edx

		popl %edi
		popl %esi
		popl %ebx
		leave
		ret


# int mp1_ioctl(unsigned long arg, unsigned int cmd)
# The dispatch function for the MP1 ioctls - should use the cmd argument
# and a jumptable to execute one of the specific ioctls implemented below.
# Inputs   : unsigned long arg - parameter to the mp1_ioctl_....
#          : unsigned int cmd  - specifies which mp1_ioctl_... function 
#          :                     to execute
# Outputs  : Returns an integer - depends on which ioctl() function is called
# Registers: Standard C calling convention


jumptable: .long mp1_ioctl_startgame, mp1_ioctl_addmissile, mp1_ioctl_movexhairs, mp1_ioctl_getstatus, mp1_ioctl_endgame # jump table of core function

.globl mp1_ioctl
mp1_ioctl:
		movl 8(%esp),%ecx

		cmpl $4,%ecx # if cmd is >4 or <0,return -1
		jg invalid_input 
		cmpl $0,%ecx
		jl invalid_input
		jmp	*jumptable(,%ecx,4)

		invalid_input:
		movl $-1,%eax
		ret


# ----------------- Functions private to this file -------------------
# void mp1_missile_remove(void)
# update the linked list of missile	
# Inputs   : no input
# Outputs  : no output
# Registers: Standard C calling convention

update_missiles:  # This function deals with the single linked list of missiles. It receives no parameters and update the current states of missiles.
		pushl %ebp 
		movl %esp, %ebp 
		pushl %ebx
		pushl %esi
		pushl %edi
		
		
		movl mp1_missile_list,%esi # esi as the pointer to the missile,esi is always the pointer to the missile in this function!
		Loop_update_1: # This loop go through the whole linked list.
		cmpl $0,%esi # judge whether iteration is completed
		je Done_update

		OOS_judge_update: # We firstly judge whether the missile is out of screen
		cmpl $79,X(%esi) # x>79?
		jl OOS_update
		cmpl $24,Y(%esi) # y>24?
		jl OOS_update
		cmpl $0,X(%esi) # x<0?
		jl OOS_update
		cmpl $0,Y(%esi) # y<0? 
		jl OOS_update

		jmp Explode_judge_update

		OOS_update:
		pushl %esi
		call mp1_missile_remove # after this call, esi is set to be the former struct of this deleted struct, and should iterate immediately!
		addl $4,%esp 
		movl %eax,%esi   # esi as the new head pointer or the former pointer to the deleted struct
		jmp Loop_update_1
		

		Explode_judge_update: # We secondly judge whether this missile is exploded
		cmpl $0,EXPLODED(%esi)
		jne Exploding_update       # Judge whether it is exploding
		movl X(%esi),%ecx
		roll $16,%ecx
		andl $0x0000ffff,%ecx
		cmpl %ecx,DEST_X(%esi)          # Compare the missile's location with his destination
		jne Position_update 		   # f it reaches its destination, go to Exploding_update
		movl Y(%esi),%ecx
		roll $16,%ecx
		andl $0x0000ffff,%ecx
		cmpl %ecx,DEST_Y(%esi) 
		jne Position_update         # f it is not reaching its destination, Continue to the next step
		jmp Exploding_update


		Exploding_update:          # f it is exploding,call missile_explode function to check whether it explodes other missiles and decrement its exploded field.
		pushl %esi
		call missile_explode       # After this call, a value should be set to the missle->exploded. 
		popl %esi
		cmpl $0,%eax
		je continue_moving_update	# notify user if it causes any missile exploded
		pushl %esi
		call mp1_notify_user		
		popl %esi

		continue_moving_update:		  
		subl $1,EXPLODED(%esi)     # substract the Exploded value by 1 (*******maybe not 1! to be update********)
		cmpl $0,EXPLODED(%esi)     # judge whether the Exploded value is 0?
		je Exploded_update		   # If so, go to Exploded_update

		# Drawing part is written here!
		# Here we drawthe EXPLOSION character here if the value of exploded is not zero.
		movl $EXPLOSION,%ecx
		pushl %ecx   
		movl Y(%esi),%ecx
		roll $16,%ecx
		andl $0x0000ffff,%ecx
		pushl %ecx
		movl X(%esi),%ecx
		roll $16,%ecx
		andl $0x0000ffff,%ecx
		pushl %ecx
		call draw_character # call the draw_character function and draw an explosion at the location(x,y)
		addl $12,%esp

		movl NEXT(%esi),%esi
		jmp Loop_update_1          # Go back to big loop after processing the exploding

		Exploded_update:           # If the exploded value is 0, we remove it from the list
		pushl %esi
		call mp1_missile_remove # after this call, esi is set to be the former struct of this deleted struct, and should iterate immediately!
		addl $4,%esp 
		movl %eax,%esi   # esi as the new head pointer or the former pointer to the deleted struct

		jmp Loop_update_1   	# Go back to the main loop

		Position_update:  
		# This is the last step of update function. You should update the position of your missiles and draw it on screen
		# f the missile is simply moving toward its destination, is not exploding, and is still on the screen
		movl $32,%ecx
		pushl %ecx
		movl Y(%esi),%ecx
		roll $16,%ecx
		andl $0x0000ffff,%ecx
		pushl %ecx
		movl X(%esi),%ecx
		roll $16,%ecx
		andl $0x0000ffff,%ecx
		pushl %ecx
		call draw_character # Call the function to remove the missile's current location on the screen
		addl $12,%esp

		# Then I'm going to update its location
		xorl %ecx,%ecx
		addl VX(%esi),%ecx  # X=X+VX
		addl %ecx,X(%esi)
		xorl %ecx,%ecx
		addl VY(%esi),%ecx
		addl %ecx,Y(%esi)  # Y=Y+VY

		# Then I'm going to redraw it on the screen
		movl C(%esi),%ecx
		pushl %ecx
		movl Y(%esi),%ecx
		roll $16,%ecx
		andl $0x0000ffff,%ecx
		pushl %ecx
		movl X(%esi),%ecx
		roll $16,%ecx
		andl $0x0000ffff,%ecx
		pushl %ecx
		call draw_character # Call the function to remove the missile's current location on the screen
		addl $12,%esp

		movl NEXT(%esi),%esi  
		jmp Loop_update_1 # This is the last step, no matter what happens, you should go back to the beginning.

		Done_update: # When the iteration is completed

		popl %edi
		popl %esi
		popl %ebx
		leave
		ret



mp1_ioctl_startgame:
		pushl %ebp 
		movl %esp, %ebp 
		pushl %ebx
		pushl %esi
		pushl %edi

		movl $0,mp1_missile_list # initialize the head pointer

		movl $0x00010101,base_alive	# initialize the base_alive parameter

		movl $40,crosshairs_x
		movl $12,crosshairs_y # initialize two parameters of crosshair

		movl $0,mp1_score # reset the score

		popl %edi
		popl %esi
		popl %ebx
		leave
		ret

mp1_ioctl_addmissile: # The argument is a pointer to a struct missile
		pushl %ebp 
		movl %esp, %ebp 
		pushl %ebx
		pushl %esi
		pushl %edi

		movl 8(%ebp),%ebx
		movl mp1_missile_list,%esi

		pushl $33
		call mp1_malloc
		add $4,%esp     # We have the address of allocated space for the missile in %eax
		movl %eax,%ecx  # store it in ecx

		pushl $33
		pushl %ebx
		pushl %ecx
		call mp1_copy_from_user # copy M[ebx] to M[eax],space we allocated
		cmpl $0,%eax		
		jne fail_addmissile
		popl %ecx
		add $8,%esp
		movl %esi,NEXT(%ecx) # let the head pointer to be the new allocated pointer's next
		movl %ecx,mp1_missile_list # let the new allocated pointer to be the head poibnter
		movl $0,%eax
		jmp Done_addmissile


		fail_addmissile:
		pushl %ecx
		call mp1_free # Free the space we allocate
		addl $4,%esp
		movl $-1,%eax
		jmp Done_addmissile


		Done_addmissile:
		popl %edi
		popl %esi
		popl %ebx
		leave
		ret

mp1_ioctl_movexhairs: # The argument should be a 32 bit with low 16 bits as
		pushl %ebp 		# the x component and high 16 bits as the y component
		movl %esp, %ebp 
		pushl %ebx
		pushl %esi
		pushl %edi

		movl 8(%ebp),%ebx # move the parameter into ebx
		# The first thing to do is to replace the crosshair with empty
		movl $32,%ecx
		pushl %ecx
		pushl crosshairs_y
		pushl crosshairs_x
		call draw_character
		addl $12,%esp
		# replace the old crosshair
		# Then I'm going to change the location
		movl %ebx,%edi
		roll $16,%edi # Now si stores the high 16bits
					  # bx stores the low 16 bits
		addw %bx,crosshairs_x
		addw %di,crosshairs_y

		# Then check whether the crosshair is out of screen
		check_x:
		cmpw $0,crosshairs_x
		jl x_smaller_then_0
		cmpw $79,crosshairs_x
		jg x_bigger_then_79
		jmp check_y

		x_smaller_then_0:
		movl $0,crosshairs_x
		jmp check_y

		x_bigger_then_79:
		movl $79,crosshairs_y
		jmp check_y

		check_y:
		cmpw $0,crosshairs_y
		jl y_smaller_then_0
		cmpw $79,crosshairs_y
		jg y_bigger_then_79
		jmp Done_check

		y_smaller_then_0:
		movl $0,crosshairs_y
		jmp Done_check

		y_bigger_then_79:
		movl $79,crosshairs_y
		jmp Done_check

		Done_check:  # redraw the new crosshair
		movl $43,%ecx
		pushl %ecx
		pushl crosshairs_y
		pushl crosshairs_x
		call draw_character
		addl $12,%esp
		jmp Done_movexhairs
		
		Done_movexhairs:
		movl $0,%eax # return 0
		popl %edi
		popl %esi
		popl %ebx
		leave
		ret

mp1_ioctl_getstatus:
		pushl %ebp 
		movl %esp, %ebp 
		pushl %ebx
		pushl %esi
		pushl %edi

		movl 8(%ebp),%ebx # We load the pointer to ebx.
		movl $4,%ecx
		pushl %ecx
		call mp1_malloc
		movl %eax,%edi    # save the address for free
		addl $4,%esp     # eax now stores the space in kernel

		xorl %ecx,%ecx  # ecx initialized to 0
		movl $base_alive,%esi

		check_base_1:
		cmpb $0,0(%esi)
		je check_base_2
		addl $1,%esi

		check_base_2:
		cmpb $0,1(%esi)
		je check_base_3
		addl $2,%esi

		check_base_3:
		cmpb $0,2(%esi)
		je done_check_base
		addl $4,%esi

		done_check_base: # We have set the 16,17,18 bits of the value
		roll $16,%esi
		movw mp1_score,%si # move mp1_score to %esi
		movl %esi,(%eax)   # move the value to the kernel space we allocated

		movl $4,%edx
		pushl %edx
		pushl %eax
		pushl %ebx
		call mp1_copy_to_user # move value we stored in M[eax] into the user space
		addl $12,%esp

		cmpl $0,%eax   # compare whether it is failed
		jne fail_getstatus
		movl $0,%eax
		jmp Done_getstatus


		fail_getstatus:		#  it falls, return -1
		movl $-1,%eax
		jmp Done_getstatus

		Done_getstatus: # free the space we allocated
		pushl %edi
		call mp1_free
		addl $4,%esp

		popl %edi
		popl %esi
		popl %ebx
		leave
		ret

mp1_ioctl_endgame:
		pushl %ebp 
		movl %esp, %ebp 
		pushl %ebx
		pushl %esi
		pushl %edi

		movl mp1_missile_list,%esi # esi have the pointer
		cmpl $0,%esi
		je Done_endgame
		free_loop:
		movl %esi,%ebx
		movl NEXT(%esi),%esi # Free all the missiles.
		pushl %ebx
		call mp1_free
		addl $4, %esp
		cmpl $0,%esi
		je Done_endgame
		cmpl $0,NEXT(%esi)
		je last_one_delete
		jmp free_loop

		last_one_delete:
		pushl %esi
		call mp1_free
		addl $4,%esp
		movl $0,mp1_missile_list

	
		Done_endgame:
		movl  $0,%eax
		popl  %edi
		popl  %esi
		popl  %ebx
		leave
		ret