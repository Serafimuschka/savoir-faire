include "macros.inc"            ;
                                ;
MEOS_APP_START                  ; PROGRAM BEGIN MACROS
                                ;
CODE                            ; PROGRAM CODE BLOCK
                                ;
redraw:                         ; Window redrawing
   call draw_window             ; Calling draw_window proc
                                ;
wait_event:                     ; Waiting for an system event
   mov eax, 10                  ; \ Calling SysFn10: Infinite waiting
   mcall                        ; /
   cmp eax, 1                   ; \ If SysEvent = 1, then
   je redraw                    ; / redraw window
   cmp eax, 2                   ; \ If SysEvent = 2, then
   je key                       ; / process pressed key
   mcall -1                     ; Else end process
                                ;
   jmp wait_event               ; Returning back
                                ;
camera_dec:                     ; Switch camera num, backward
   mov al, [numCamera]          ; Move numCamera value to AL register
   cbw                          ; Convert BYTE to WORD
   dec ax                       ; Decrement value of DX register
   mov [numCamera], ah          ; Move AH register value to numCamera
   jmp feedback                 ; Return to processing
                                ;
camera_inc:                     ; Switch camera num, forward
   mov al, [numCamera]          ; Move numCamera value to AL register
   cbw                          ; Convert BYTE to WORD
   inc ax                       ; Increment value of DX register
   mov [numCamera], ah          ; Move AH register value to numCamera
   jmp feedback                 ; Return to processing
                                ;
key:                            ; Getting an ASCII number of pressed key
   mcall 2                      ; Calling SysFn02: Pressed key code
   mov [keyid], ah              ; Move AH register value to keyid
   mov ebp, keyid               ; Move keyid value to EBP register
   cmp ebp, 45                  ; Compare EBP value with 45 (-)
   je camera_dec                ; If EBP = 45 then jump to camera_dec, else continue
   cmp ebp, 43                  ; Compare EBP value with 43 (+)
   je camera_inc                ; If EBP = 43 then jump to camera_inc, else continue
feedback:                       ; Camera_dec and camera_inc returning point
   call draw_window             ; Calling draw_window proc
   jmp wait_event               ; Wait for an system event
                                ;
draw_window:                    ; Drawing a window
   mov eax, 12                  ; \
   mov ebx, 1                   ; | Calling SysFn12: Window redraw, begin
   mcall                        ; /
                                ;
   mov eax, 0                   ; \ Calling SysFn00: Window definition
   mov ebx, 0 * 65536 + 1023    ; | X start position (0) and X-width (1023)
   mov ecx, 0 * 65536 + 767     ; | Y start position (0) and Y-height (767)
   mov edx, wstyle              ; | Window style, 0xXYRRGGBB
   mov esi, wheader             ; | Header color, 0xXYRRGGBB
   mov edi, wframe              ; | Frame color, 0x00RRGGBB
   mcall                        ; /
                                ;
   mov eax, 71                  ; \ Calling SysFn71: Window header
   mov ebx, 2                   ; | Use string address without codepage
   mov ecx, header              ; | String address
   mov edx, 1                   ; | Codepage
   mcall                        ; /
                                ;
   mov eax, 4                   ; \ Calling SysFn04: Text writing
   mov ebx, 30 * 65536 + 10     ; | X start position and Y start position
   mov ecx, tstyle              ; | Text style, 0xXXRRGGBB
   mov edx, string              ; | String begin address
   mcall                        ; /
                                ;
   ;----------------------------;
   ;     Graphics functions     ;
   ;----------------------------;
                                ;
;  mov eax, 13                  ; \ Calling SysFn13: Rect drawing
;  mov ebx, 5 * 65536 + 1012    ; | X start position (5) and X-width (1012)
;  mov ecx, 5 * 65536 + 50      ; | Y start position (5) and Y-height (50)
;  mov edx, 0xFFFFFF            ; | Rect color, 0xRRGGBB
;  mcall                        ; /
                                ;
;  mov eax, 38                  ; \ Calling SysFn38: Line Drawing
;  mov ebx, 5 * 65536 + 1012    ; | X start position (5) and X end position (1012)
;  mov ecx, 5 * 65536 + 50      ; | Y start position (5) and Y end position (50)
;  mov edx, 0x00FFFFFF          ; | Line color, 0x00RRGGBB
;  mcall                        ; /
                                ;
   ;----------------------------;
   ;       Frame drawings       ;
   ;----------------------------;
                                ;
   mov eax, 1                   ; \ Calling SysFn01: Draw a pixel
   mov ebx, 1017                ; | Move to EBX register a X-position
   mov ecx, 5                   ; | Move to ECX register a Y-position
   mov edx, 0x00323232          ; / Move to EDX register a color, 0x00RRGGBB
fra:                            ; Frame-A fragment
   mcall                        ; Call SysFn01
   dec ebx                      ; Decrement EBX register value
   cmp ebx, ecx                 ; Compare EBX register value with ECX register value
   jne fra                      ; If EBX != ECX then repeat
                                ;
frb:                            ; Frame-B fragment
   mcall                        ; Call SysFn01
   inc ecx                      ; Increment ECX register value
   cmp ecx, 45                  ; Compare ECX register value with 45
   jne frb                      ; If ECX != 45 then repeat
                                ;
frc:                            ; Frame-C fragment
   mcall                        ; Call SysFn01
   inc ebx                      ; Increment EBX register value
   cmp ebx, 1017                ; Compare EBX register value with 1017
   jne frc                      ; If EBX != 1017 then repeat
                                ;
frd:                            ; Frame-D fragment
   mcall                        ; Call SysFn01
   dec ecx                      ; Decrement ECX register value
   cmp ecx, 5                   ; Compare ECX register value with 5
   jne frd                      ; If ECX != 5 then repeat
                                ;
   ;----------------------------;
   ;   Camera pic placeholder   ; Drawing a placeholder with size 644x480
   ;----------------------------;
                                ;
   mov ebx, picWidth            ; Move to EBX register a X-position
   mov ecx, picHeight           ; Move to ECX register a Y-position
   mov edx, 0x000000FF          ; Move to EDX register a color of Segment-A
a:                              ; Segment-A
   mcall                        ; Call SysFn01
   dec ecx                      ; Decrement ECX register value
   cmp ecx, 50                  ; Compare ECX register value with 50
   jne a                        ; If ECX != 50 then repeat, else
   dec ebx                      ; Decrement EBX register value
   mov ecx, picHeight           ; Move to ECX register a Y-position
   cmp ebx, picWidth - 92 * 1   ; Compare EBX register value with width of segment (92)
   jne a                        ; If EBX != picWidth - 92 * 1 then repeat
                                ;
   mov ebx, picWidth - 92 * 1   ; Move to EBX register a X-position
   mov ecx, picHeight           ; Move to ECX register a Y-position
   mov edx, 0x00FF0000          ; Move to EDX register a color of Segment-B
b:                              ; Segment-B
   mcall                        ; Call SysFn01
   dec ecx                      ; Decrement ECX register value
   cmp ecx, 50                  ; Compare ECX register value with 50
   jne b                        ; If ECX != 50 then repeat, else
   dec ebx                      ; Decrement EBX register value
   mov ecx, picHeight           ; Move to ECX register a Y-position
   cmp ebx, picWidth - 92 * 2   ; Compare EBX register value with width of segment (92)
   jne b                        ; If EBX != picWidth - 92 * 2 then repeat
                                ;
   mov ebx, picWidth - 92 * 2   ; Move to EBX register a X-position
   mov ecx, picHeight           ; Move to ECX register a Y-position
   mov edx, 0x00FF00FF          ; Move to EDX register a color of Segment-C
c:                              ; Segment-C
   mcall                        ; Call SysFn01
   dec ecx                      ; Decrement ECX register value
   cmp ecx, 50                  ; Compare ECX register value with 50
   jne c                        ; If ECX != 50 then repeat, else
   dec ebx                      ; Decrement EBX register value
   mov ecx, picHeight           ; Move to ECX register a Y-position
   cmp ebx, picWidth - 92 * 3   ; If EBX != picWidth - 92 * 3 then repeat
   jne c                        ;
                                ;
   mov ebx, picWidth - 92 * 3   ; Move to EBX register a X-position
   mov ecx, picHeight           ; Move to ECX register a Y-position
   mov edx, 0x0000FF00          ; Move to EDX register a color of Segment-D
d:                              ; Segment-D
   mcall                        ; Call SysFn01
   dec ecx                      ; Decrement ECX register value
   cmp ecx, 50                  ; Compare ECX register value with 50
   jne d                        ; If ECX != 50 then repeat, else
   dec ebx                      ; Decrement EBX register value
   mov ecx, picHeight           ; Move to ECX register a Y-position
   cmp ebx, picWidth - 92 * 4   ; Compare EBX register value with width of segment (92)
   jne d                        ; If EBX != picWidth - 92 * 4 then repeat
                                ;
   mov ebx, picWidth - 92 * 4   ; Move to EBX register a X-position
   mov ecx, picHeight           ; Move to ECX register a Y-position
   mov edx, 0x0000FFFF          ; Move to EDX register a color of Segment-E
e:                              ; Segment-E
   mcall                        ; Call SysFn01
   dec ecx                      ; Decrement ECX register value
   cmp ecx, 50                  ; Compare ECX register value with 50
   jne e                        ; If ECX != 50 then repeat, else
   dec ebx                      ; Decrement EBX register value
   mov ecx, picHeight           ; Move to ECX register a Y-position
   cmp ebx, picWidth - 92 * 5   ; Compare EBX register value with width of segment (92)
   jne e                        ; If EBX != picWidth - 92 * 5 then repeat
                                ;
   mov ebx, picWidth - 92 * 5   ; Move to EBX register a X-position
   mov ecx, picHeight           ; Move to ECX register a Y-position
   mov edx, 0x00FFFF00          ; Move to EDX register a color of Segment-F
f:                              ; Segment-F
   mcall                        ; Call SysFn01
   dec ecx                      ; Decrement ECX register value
   cmp ecx, 50                  ; Compare ECX register value with 50
   jne f                        ; If ECX != 50 then repeat, else
   dec ebx                      ; Decrement EBX register value
   mov ecx, picHeight           ; Move to ECX register a Y-position
   cmp ebx, picWidth - 92 * 6   ; Compare EBX register value with width of segment (92)
   jne f                        ; If EBX != picWidth - 92 * 6 then repeat
                                ;
   mov ebx, picWidth - 92 * 6   ; Move to EBX register a X-position
   mov ecx, picHeight           ; Move to ECX register a Y-position
   mov edx, 0x00FFFFFF          ; Move to EDX register a color of Segment-G
g:                              ; Segment-G
   mcall                        ; Call SysFn01
   dec ecx                      ; Decrement ECX register value
   cmp ecx, 50                  ; Compare ECX register value with 50
   jne g                        ; If ECX != 50 then repeat, else
   dec ebx                      ; Decrement EBX register value
   mov ecx, picHeight           ; Move to ECX register a Y-position
   cmp ebx, picWidth - 92 * 7   ; Compare EBX register value with width of segment (92)
   jne g                        ; If EBX != picWidth - 92 * 7 then repeat
                                ;
   ;----------------------------;
   ;        Other frames        ;
   ;----------------------------;
                                ;
   mov eax, 4                   ; \ Calling SysFn04: Text writing
   mov ebx, 370 * 65535 + 275   ; | X start position and Y start position
   mov ecx, 0xC2FFFFFF          ; | Text style, 0xXXRRGGBB
   mov edx, signal              ; | String begin address
   mov edi, 0x00000000          ; | Font background color, 0x00RRGGBB
   mcall                        ; /
                                ;
   mov eax, 1                   ; \ Calling SysFn01: Draw a pixel
   mov ebx, 121                 ; | Move to EBX register a X-position
   mov ecx, 50                  ; | Move to ECX register a Y-position
   mov edx, 0x00FFFF00          ; / Move to EDX register a color, 0x00RRGGBB
frva:                           ; FrameV-A
   mcall                        ; Call SysFn01
   inc ebx                      ; Increment EBX register value
   cmp ebx, 784                 ; Compare EBX register value with 784
   jne frva                     ; If EBX != 784 then repeat
                                ;
frvb:                           ; FrameV-B
   mcall                        ; Call SysFn01
   inc ecx                      ; Increment ECX register value
   cmp ecx, 530                 ; Compare ECX register value with 530
   jne frvb                     ; If ECX != 530 then repeat
                                ;
frvc:                           ; FrameV-C
   mcall                        ; Call SysFn01
   dec ebx                      ; Decrement EBX register value
   cmp ebx, 120                 ; Compare EBX register value with 120
   jne frvc                     ; If EBX != 120 then repeat
                                ;
frvd:                           ; FrameV-D
   mcall                        ; Call SysFn01
   dec ecx                      ; Decrement ECX register value
   cmp ecx, 50                  ; Compare ECX register value with 50
   jne frvd                     ; If ECX != 50 then repeat
                                ;
   ;----------------------------;
   ;        Text drawing        ;
   ;----------------------------;
                                ;
   mov eax, 4                   ; \ Calling SysFn04: Text writing
   mov ebx, 654 * 65536 + 505   ; | X start position and Y start position
   mov ecx, 0xC2FFFFFF          ; | Text style, 0xXXRRGGBB
   mov edx, cam                 ; | String begin address
   mov edi, 0x00000000          ; | Font background color, 0x00RRGGBB
   mcall                        ; /
                                ;
   mov ebx, 768 * 65536 + 505   ; Move to EBX register XY coordinate
   mov edx, numCamera           ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 10 * 65536 + 6      ; Move to EBX register XY coordinate
   mov ecx, ts_idle             ; Move to ECX register a color value
   mov edx, prevStatus2         ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 10 * 65536 + 16     ; Move to EBX register XY coordinate
   mov edx, prevStatus1         ;
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 10 * 65536 + 26     ; Move to EBX register XY coordinate
   mov ecx, ts_danger           ; Move to ECX register a color value
   mov edx, currStatus          ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 10 * 65536 + 36     ; Move to EBX register XY coordinate
   mov ecx, ts_active           ; Move to ECX register a color value
   mov edx, terminalIn          ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 10 * 65536 + 50     ; Move to EBX register XY coordinate
   mov ecx, ts_category         ; Move to ECX register a color value
   mov edx, flagshd             ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 15 * 65536 + 60     ; Move to EBX register XY coordinate
   mov ecx, ts_error            ; Move to ECX register a color value
   mov edx, droneStatus         ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 15 * 65536 + 70     ; Move to EBX register XY coordinate
   mov edx, droneBattery        ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 15 * 65536 + 80     ; Move to EBX register XY coordinate
   mov edx, droneMovement       ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 15 * 65536 + 90     ; Move to EBX register XY coordinate
   mov edx, droneAutomove       ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 15 * 65536 + 100    ; Move to EBX register XY coordinate
   mov edx, droneManipulator    ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 15 * 65536 + 110    ; Move to EBX register XY coordinate
   mov edx, droneAutoasm        ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 15 * 65536 + 120    ; Move to EBX register XY coordinate
   mov edx, droneWarning        ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 15 * 65536 + 130    ; Move to EBX register XY coordinate
   mov edx, droneDamaged        ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 10 * 65536 + 150    ; Move to EBX register XY coordinate
   mov ecx, ts_category         ; Move to ECX register a color value
   mov edx, flagshd2            ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 15 * 65536 + 160    ; Move to EBX register XY coordinate
   mov ecx, ts_active           ; Move to ECX register a color value
   mov edx, droneIdle           ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 15 * 65536 + 170    ; Move to EBX register XY coordinate
   mov ecx, ts_idle             ; Move to ECX register a color value
   mov edx, droneThumper        ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 15 * 65536 + 180    ; Move to EBX register XY coordinate
   mov edx, droneElon           ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 15 * 65536 + 190    ; Move to EBX register XY coordinate
   mov ecx, ts_danger           ; Move to ECX register a color value
   mov edx, droneLights         ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 15 * 65536 + 200    ; Move to EBX register XY coordinate
   mov edx, droneLaser          ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 800 * 65535 + 50    ; Move to EBX register XY coordinate
   mov ecx, ts_category         ; Move to ECX register a color value
   mov edx, flagshd3            ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 805 * 65535 + 60    ; Move to EBX register XY coordinate
   mov ecx, ts_idle             ; Move to ECX register a color value
   mov edx, aboutCOM            ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 805 * 65535 + 70    ; Move to EBX register XY coordinate
   mov edx, control             ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 805 * 65535 + 80    ; Move to EBX register XY coordinate
   mov edx, speedConf           ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 800 * 65535 + 100   ; Move to EBX register XY coordinate
   mov ecx, ts_category         ; Move to ECX register a color value
   mov edx, flagshd4            ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov ebx, 805 * 65535 + 110   ; Move to EBX register XY coordinate
   mov ecx, ts_idle             ; Move to ECX register a color value
   mov edx, aboutDrone          ; Move to EDX register string address
   mcall                        ; Call SysFn04
                                ;
   mov eax, 12                  ; \ Calling SysFn12: Window redraw, end
   mov ebx, 2                   ; /
   mcall                        ; Call SysFn12
   ret                          ;
                                ;
   ;----------------------------;
   ;    ADDITIONAL FUNCTIONS    ;
   ;----------------------------;
                                ;
com_debug:                      ; COM port feedback
   mov eax, 4                   ; \ Calling SysFn04: Text writing
   mov ebx, 30 * 65536 + 30     ; | X start position and Y start position
   mov ecx, tstyle              ; | Text style, 0xXXRRGGBB
   mov edx, string              ; | String begin address
   mcall                        ; /
                                ;
com_send:                       ; COM port using
   mov eax, 43                  ; \ Calling SysFn43: I/O ports
   mov ebx, 0x0F                ; | Move to EBX register a data to send
   mov ecx, 0x4                 ; | Move to ECX register a port to use
   mcall                        ; /
   xor eax, 0                   ; Comparing EAX register value with 0
   js com_debug                 ; If EAX = 0 then jump to com_debug
                                ;
DATA                            ; PROGRAM DATA BLOCK
   keyid: rb 1                  ; Reserved for pressed key ID's (1 byte)
                                ;
   picWidth = 784               ; Const for drawing algorithm
   picHeight = 530              ; Const for drawing algorithm
                                ;
   ;----------------------------;
   ;      DATA BLOCK BEGIN      ;
   ;----------------------------;
   ; name        | type | value ;
   ;----------------------------;
                                ;
   numCamera         db   49, 0
   header            db   'toqsycc labs : drone terminal mk.1 rev.0', 0
   string            db   'Sample string', 0
   signal            db   'NO SIGNAL!', 0
   aboutCOM          db   'RC on COM ', 0
   aboutDrone        db   'Connected: ', 0
   speedConf         db   'Speeds group: ', 0
   control           db   'Controller: ', 0
   flagshd           db   'IMP FLAGS :', 0
   flagshd2          db   'ADD FLAGS :', 0
   flagshd3          db   'COM FLAGS :', 0
   flagshd4          db   'DRONE DATA :', 0
   cam               db   'CAMERA ', 0
   currStatus        db   'Terminal initialised successfully.', 0
   prevStatus1       db   'COM port not found. Task ignored.', 0
   prevStatus2       db   'Receiver not found. Task ignored.', 0
   terminalIn        db   '#toqsycc > ', 0
                                ;
   droneStatus       db   'Online', 0
   droneLaser        db   'Laser', 0
   droneThumper      db   'Thumper', 0
   droneElon         db   'Mecanum', 0
   droneMovement     db   'Movement', 0
   droneIdle         db   'Idling', 0
   droneBattery      db   'Battery', 0
   droneAutomove     db   'Automovement', 0
   droneAutoasm      db   'Autoassembling', 0
   droneLights       db   'Light', 0
   droneManipulator  db   'Manipulator', 0
   droneWarning      db   'Warning', 0
   droneDamaged      db   'Damaged', 0
   droneDigger       db    'Digger Offline', 0
                                ;
   ;----------------------------;
   ;  ADDITIVE CONSTANTS BLOCK  ;
   ;----------------------------;
   ; name            | value    ;
                                ;
   wstyle            =     0x30000000
   wheader           =     0x01000000
   wframe            =     0x00323232
   tstyle            =     0x80000000
   ts_active         =     0x8000FF16
   ts_idle           =     0x80646464
   ts_error          =     0x80FF0000
   ts_danger         =     0x80FF9600
   ts_category       =     0x80FFFFFF
                                ;
   ;----------------------------;
   ;       DATA BLOCK END       ;
   ;----------------------------;
                                ;
UDATA                           ; PROGRAM UDATA BLOCK
                                ;
MEOS_APP_END                    ; PROGRAM END MACROS
