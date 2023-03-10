.data
struct_list_size: .int 12
struct_element_size: .int 12
print_format: .string "%d\n\0"
.text
.globl main


main : 
push %ebp
movl %esp, %ebp
push %ebx

# allocate memory for the struct list
subl struct_list_size, %esp
movl %esp, %ebx
movl $0, (%ebx)  # size of the list
movl $0, 4(%ebx) # pointer to the first element
movl $0, 8(%ebx) # pointer to the last element

# add 10 elements to the list
movl $20, %ecx

boucle1:
subl struct_element_size, %esp # allocate space for the element
movl %esp, %eax
pushl %ecx

pushl %eax
pushl %ecx
pushl %ebx
call add_struct
addl $12, %esp
popl %ecx
loop boucle1

pushl $0
pushl %ebx
call remove_liste
addl $8, %esp

pushl $56474
pushl $0
pushl %ebx
call set_value_list
addl $12, %esp

pushl %ebx
call print_list
addl $4, %esp

end:
movl $0, %eax
popl %ebx
leave
ret



.globl add_struct
add_struct : # struc_list, value, pointer to the new struct element
push %ebp
movl %esp, %ebp
pushl %ebx

movl 8(%ebp), %ebx   # ebx = struct_list
movl 12(%ebp), %eax  # eax = value
movl 16(%ebp), %ecx  # ecx = pointer to the new struct element

movl %eax, (%ecx)  # value
movl $0, 4(%ecx)   # previous set default as nullptr
movl $0, 8(%ecx)   # next set default as nullptr

movl 8(%ebx), %eax
movl %ecx, 8(%ebx) # element -> last element
# element is the last element of the list
movl (%ebx), %edx
cmp $0, %edx     # if (struct_list->size == 0)
jz L1               #   goto L1

movl %ecx, 8(%eax)  # first_element->next = element
movl %eax, 4(%ecx)  # element->previous = first_element
jmp L2

L1:
movl %ecx, 4(%ebx)  # struct_list->first_element = element

L2:
addl $1, (%ebx)     # struct_list->size++

# make the list cyclique
movl 4(%ebx), %eax 
movl 8(%ebx), %ecx
movl %eax, 8(%ecx)
movl %ecx, 4(%eax)

popl %ebx
leave
ret

.globl print_list
print_list:
push %ebp
movl %esp, %ebp
pushl %ebx

movl 8(%ebp), %ebx   # ebx = struct_list

# print the list
movl (%ebx), %ecx  # size of the list
cmp $0, %ecx
jz end_print_list
movl 4(%ebx), %eax  # pointer to the first element

boucle2:
# save register
pushl %eax
pushl %ecx

pushl (%eax)  # value
pushl $print_format
call printf
addl $8, %esp
#recovery register
popl %ecx
popl %eax
movl 8(%eax), %eax  # element = element->next
cmp $0, %eax  # if (element->next == nullptr)
jz end_print_list
loop boucle2

end_print_list:
popl %ebx
leave
ret

.globl remove_liste
remove_liste:
push %ebp
movl %esp, %ebp
pushl %ebx

movl 8(%ebp), %ebx   # ebx = struct_list
movl 12(%ebp), %ecx  # index

movl (%ebx), %eax
cmp $0, %eax
jz remove_liste_L1
cmp $1, %eax
je remove_liste_L1

movl 4(%ebx), %eax

remove_liste_boucle:
cmp $0, %ecx
jz remove_liste_L2
movl 8(%eax), %eax
subl $1, %ecx
jmp remove_liste_boucle
remove_liste_L2:
movl 4(%ebx), %ecx
cmp  %ecx, %eax # verify if its the first element
jne remove_liste_L3
movl 8(%eax), %ecx
movl %ecx, 4(%ebx)

remove_liste_L3:
movl 8(%ebx), %ecx
cmp  %ecx, %eax # verify if its the last element
jne remove_liste_L4
movl 4(%eax), %ecx
movl  %ecx, 8(%ebx)

remove_liste_L4:
movl 4(%eax), %ecx
movl 8(%eax), %edx
movl %ecx, 4(%edx)
movl %edx, 8(%ecx)
subl $1, (%ebx)
jmp end_remove_liste

remove_liste_L1:
movl $0, (%ebx)  # size of the list
movl $0, 4(%ebx) # pointer to the first element
movl $0, 8(%ebx) # pointer to the last element

end_remove_liste:
popl %ebx
leave
ret

.globl set_value_list
set_value_list:
push %ebp
movl %esp, %ebp
pushl %ebx

movl 8(%ebp), %ebx   # ebx = struct_list
movl 12(%ebp), %ecx  # index
movl 16(%ebp), %edx # value

movl (%ebx), %eax
cmp $0, %eax
jz end_set_value

movl 4(%ebx), %eax

set_value_boucle:
cmp $0, %ecx
jz set_value
movl 8(%eax), %eax
subl $1, %ecx
jmp set_value_boucle
set_value:
movl %edx, (%eax) 
end_set_value:
popl %ebx
leave
ret
