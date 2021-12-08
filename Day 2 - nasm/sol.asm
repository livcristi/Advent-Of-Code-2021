; NASM program for Advent of Code 2021 day 2: https://adventofcode.com/2021/day/2

bits 32

global start        


extern exit, fopen, fread, fclose, fscanf, printf
import exit msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import fscanf msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll


segment data use32 class=data
    ; variables used for computation
    horizontal dw 0
    vertical_1 dw 0
    vertical_2 dd 0
    aim dw 0
    result dd 0
    com_value dd 0
    command db 10
    
    ; variables for files and printing the result
    file_name db "input.txt", 0
    access_mode db "r", 0
    file_descriptor dd -1
    
    read_format db "%s %d", 0
    print_format_1 db "Part 1 result is: %d", 10, 0
    print_format_2 db "Part 2 result is: %d", 10, 0


segment code use32 class=code
    start:
        ; idea in pseudocode/C (computing both parts at once): 
        ; while(fscanf(file_descriptor, "%s %d", command, &com_value) > 0)
        ;  if(command[0] == 'f')
        ;   horizontal += com_value, vertical_2 += aim * com_value
        ;  else if(command[0] == 'd')
        ;   vertical_1 += com_value
        ;   aim += com_value
        ;  else
        ;   vertical_2 -= com_value
        ;   aim -= com_value
        ;
        ; printf("Part 1 result is: %d\n", horizontal * vertical_1)
        ; printf("Part 2 result is: %d\n", horizontal * vertical_2)
      
        
        ; eax = fopen(file_name, access_mode)
        push dword access_mode     
        push dword file_name
        call [fopen]
        add esp, 4 * 2              ; clean-up the stack

        mov [file_descriptor], eax  ; store the file descriptor returned by fopen

        ; check if fopen() has successfully created the file (EAX != 0)
        cmp eax, 0
        je final
          
        read_loop:
            ; eax = fscanf(file_descriptor, "%s %d", command, &com_value)
            push dword com_value
            push dword command
            push dword read_format
            push dword [file_descriptor]
            call [fscanf]
            add esp, 4 * 4
            
            ; if(eax <= 0) print_result 
            cmp eax, 0
            jle print_result
            
                ; if(command[0] == 'f') horizontal += com_value, vertical_2 += aim * com_value;
                mov bl, 'f'
                cmp [command], bl
                jne comm_not_forward
                
                ; cx = com_value; horizontal += dx
                mov cx, [com_value]
                add [horizontal], cx
                
                ; ax = aim; dx:ax = ax * com_value; vertical_2 += ax
                mov eax, 0
                mov ax, [aim]
                mul cx
                add [vertical_2], eax
                
                jmp read_loop
                    
                    ; else if(command[0] == 'd') vertical_1, aim += com_value
                    comm_not_forward:
                    
                    mov bl, 'd'
                    cmp [command], bl
                    jne comm_not_down
                    
                    ; dx = com_value; vertical_1, aim += dx;
                    mov dx, [com_value]
                    add [vertical_1], dx
                    add [aim], dx

                    jmp read_loop
                    
                        ; else aim, vertical_1 -= com_value
                        comm_not_down:
                        ; dx = com_value; vertical_1, aim -= dx
                        mov dx, [com_value]
                        sub [vertical_1], dx
                        sub [aim], dx
                        jmp read_loop
                    
        
        print_result:
            ; printf("Part 1 result is: %d", horizontal * vertical_1)
            ; eax = horizontal * vertical
            mov ax, [horizontal]
            mul word [vertical_1]
            push dx
            push ax 
            pop eax
            
            push eax 
            push dword print_format_1
            call [printf]
            add esp, 4 * 2
            
            ; printf("Part 2 result is: %d", horizontal * vertical_2)
            ; edx:eax = horizontal * vertical_2 (we only need 32 bits so edx will not be used)
            mov ax, [horizontal]
            mul dword [vertical_2]
            
            push eax 
            push dword print_format_2
            call [printf]
            add esp, 4 * 2

        ; call fclose() to close the file
        ; fclose(file_descriptor)
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
        
    final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
