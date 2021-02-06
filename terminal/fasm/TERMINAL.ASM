;---------------------------------------------------------------------------------------------------;
;                                     Drone terminal application                                    ;
;                                           Revision 0001                                           ;
;---------------------------------------------------------------------------------------------------;
;                                  Developed and edited by toqsycc                                  ;
;---------------------------------------------------------------------------------------------------;
;                                  Dec 2020 - Feb 2021 (c) toqsycc                                  ;
;---------------------------------------------------------------------------------------------------;
include "kolibrios/macros.inc"                                                 ; ADDITIVE LIBRARIES ;
                                                                                                    ;
MEOS_APP_START                                                               ; PROGRAM BEGINS HERE  ;
                                                                                                    ;
CODE                                                                                  ; CODE BLOCK  ;
                                                                                                    ;
;---------------------------------------------------------------------------------------------------;
;                                      STRUCT AND CONST BLOCK                                       ;
;---------------------------------------------------------------------------------------------------;
                                                                                                    ;
struct INTERFACEPOS                                                    ; Interface Positions struct ;
   framex                  dd ?                                        ; Frame position (in window) ;
   framey                  dd ?                                                                     ;
   campicpos               dd ?                                                                     ;
   campicsz                dd ?                                                                     ;
   campictxpos             dd ?                                                                     ;
   campicnpos              dd ?                                                                     ;
   cmdfrpos                dd ?                                                                     ;
   cmdfrsz                 dd ?                                                                     ;
   antennapos              dd ?                                                                     ;
   antennasz               dd ?                                                                     ;
   batterypos              dd ?                                                                     ;
   batterysz               dd ?                                                                     ;
   catimppos               dd ?                                                                     ;
   cataddpos               dd ?                                                                     ;
   catdronepos             dd ?                                                                     ;
ends                                                                                                ;
                                                                                                    ;
struct INTERFACECLR                                                                                 ;
   frameclr                dd ?                                                                     ;
   campic1                 dd ?                                                                     ;
   campic2                 dd ?                                                                     ;
   campic3                 dd ?                                                                     ;
   campic4                 dd ?                                                                     ;
   campic5                 dd ?                                                                     ;
   campic6                 dd ?                                                                     ;
   campic7                 dd ?                                                                     ;
   cmdhistory              dd ?                                                                     ;
   cmdlatest               dd ?                                                                     ;
   cmdcurrent              dd ?                                                                     ;
   antennabad              dd ?                                                                     ;
   antennamid              dd ?                                                                     ;
   antennagood             dd ?                                                                     ;
   catgclr                 dd ?                                                                     ;
   sttsidle                dd ?                                                                     ;
   sttsactive              dd ?                                                                     ;
   sttsdanger              dd ?                                                                     ;
   sttsdamage              dd ?                                                                     ;
ends                                                                                                ;
                                                                                                    ;
WINDOWSIZEX = 1024                                                                                  ;
WINDOWSIZEY = 768                                                                                   ;
                                                                                                    ;
configure:                                                                                          ;
   mov [IFCPs + INTERFACEPOS.framex],            5                    shl 16   + (WINDOWSIZEX - 6)  ;
   mov [IFCPs + INTERFACEPOS.framey],            5                    shl 16   + 45                 ;
   mov [IFCPs + INTERFACEPOS.campicpos],         140                  shl 16   + 50                 ;
   mov [IFCPs + INTERFACEPOS.campicsz],          644                  shl 16   + 480                ;
   mov [IFCPs + INTERFACEPOS.campictxpos],       370                  shl 16   + 275                ;
   mov [IFCPs + INTERFACEPOS.campicnpos],        654                  shl 16   + 505                ;
   mov [IFCPs + INTERFACEPOS.cmdfrpos],          10                   shl 16   + 10                 ;
   mov [IFCPs + INTERFACEPOS.cmdfrsz],           (WINDOWSIZEX - 20)   shl 16   + 40                 ;
                                                                                                    ;
   mov [IFCLs + INTERFACECLR.frameclr],          0x00FF0000                                         ;
   mov [IFCLs + INTERFACECLR.campic1],           0x00FFFFFF                                         ;
   mov [IFCLs + INTERFACECLR.campic2],           0x00FFFF00                                         ;
   mov [IFCLs + INTERFACECLR.campic3],           0x0000FFFF                                         ;
   mov [IFCLs + INTERFACECLR.campic4],           0x0000FF00                                         ;
   mov [IFCLs + INTERFACECLR.campic5],           0x00FF00FF                                         ;
   mov [IFCLs + INTERFACECLR.campic6],           0x00FF0000                                         ;
   mov [IFCLs + INTERFACECLR.campic7],           0x000000FF                                         ;
   mov [IFCLs + INTERFACECLR.cmdhistory],        0x80646464                                         ;
   mov [IFCLs + INTERFACECLR.cmdlatest],         0x80FF9600                                         ;
   mov [IFCLs + INTERFACECLR.cmdcurrent],        0x8000FF00                                         ;
   mov [IFCLs + INTERFACECLR.antennabad],        0x00FF0000                                         ;
   mov [IFCLs + INTERFACECLR.antennamid],        0x00FFFF00                                         ;
   mov [IFCLs + INTERFACECLR.antennagood],       0x0000FF00                                         ;
   mov [IFCLs + INTERFACECLR.catgclr],           0x80FFFFFF                                         ;
   mov [IFCLs + INTERFACECLR.sttsidle],          0x80646464                                         ;
   mov [IFCLs + INTERFACECLR.sttsactive],        0x80FF9600                                         ;
   mov [IFCLs + INTERFACECLR.sttsdanger],        0x80FFA000                                         ;
   mov [IFCLs + INTERFACECLR.sttsdamage],        0x80FF3232                                         ;
                                                                                                    ;
;---------------------------------------------------------------------------------------------------;
;                                         MAIN PROGRAM BLOCK                                        ;
;---------------------------------------------------------------------------------------------------;
redraw:                                                    ; Window redrawing                       ;
@@:
   call draw_window                                        ; Calling draw_window proc               ;
                                                                                                    ;
wait_event:                                                ; Waiting for an system event            ;
   mov eax, 23                                             ; \ Calling SysFn10: Infinite waiting    ;
   mov ebx, 100
   mcall                                                   ; /                                      ;
   cmp eax, 0                                              ; \ If SysEvent = 1, then                ;
   je redraw
   cmp eax, 1
   je redraw                                               ; / redraw window                        ;
   cmp eax, 2                                              ; \ If SysEvent = 2, then                ;
   je key                                                  ; / process pressed key                  ;
   mcall -1                                                ; Else end process                       ;
   jmp wait_event                                          ; Returning back                         ;
                                                                                                    ;
key:                                                       ; Getting an ASCII number of pressed key ;
   mcall 2                                                 ; Calling SysFn02: Pressed key code      ;
   mov [keyid], ah                                         ; Move AH register value to keyid        ;
   cmp [keyid], 45                                             ; Compare EBP value with 45 (-)          ;
   je .cam_dec                                             ; If EBP = 45 then cam_dec, else continue;
   cmp [keyid], 43                                             ; Compare EBP value with 43 (+)          ;
   je .cam_inc                                             ; If EBP = 43 then cam_inc, else continue;
   jmp @b

.cam_dec:                                                  ; Switch camera num, backward            ;
   mov bl, [numCamera]
   dec bl
   mov [numCamera], bl
   push ebx
   jmp @b

.cam_inc:                                                  ; Switch camera num, forward             ;
   mov bl, [numCamera]                                     ; Move numCamera value to AL register
   inc bl                                                  ; Increment value of DX register         ;
   mov [numCamera], bl
   push ebx                                    ; Move AH register value to numCamera    ;
   jmp @b

random_byte:
@getSeed:
   rdtsc
   mov [generatorSeed], eax
   mov edx, 0

   cmp [generatorSeed], 0
   je @getSeed

   mov ebx, 255
   div ebx
   mov [generatorSeed], edx

   jmp @f


draw_window:                                               ; Drawing a window                       ;

   mov eax, 12                                             ; \                                      ;
   mov ebx, 1                                              ; | Calling SysFn12: Window redraw, begin;
   mcall                                                   ; /                                      ;
                                                                                                    ;
   mov eax, 0                                              ; \ Calling SysFn00: Window definition   ;
   mov ebx, 0 shl 16 + (WINDOWSIZEX - 1)                   ; | X start position and width           ;
   mov ecx, 0 shl 16 + (WINDOWSIZEY - 1)                   ; | Y start position and height          ;
   mov edx, wstyle                                         ; | Window style, 0xXYRRGGBB             ;
   mov esi, wheader                                        ; | Header color, 0xXYRRGGBB             ;
   mov edi, wframe                                         ; | Frame color, 0x00RRGGBB              ;
   mcall                                                   ; /                                      ;
                                                                                                    ;
   mov eax, 71                                             ; \ Calling SysFn71: Window header       ;
   mov ebx, 2                                              ; | Use string address without codepage  ;
   mov ecx, generatorSeed                                         ; | String address                       ;
   mov edx, 1                                              ; | Codepage                             ;
   mcall                                                   ; /                                      ;
                                                                                                    ;
   mov eax, 4                                              ; \ Calling SysFn04: Text writing        ;
   mov ebx, 30 shl 16 + 10                                 ; | X and Y start position               ;
   mov ecx, tstyle                                         ; | Text style, 0xXXRRGGBB               ;
   mov edx, string                                         ; | String begin address                 ;
   mcall                                                   ; /                                      ;
                                                                                                    ;
                                                           ;----------------------------------------;
                                                           ;           Graphics functions           ;
                                                           ;----------------------------------------;
                                                                                                    ;
;  mov eax, 13                                             ; \ Calling SysFn13: Rect drawing        ;
;  mov ebx, 5 shl 16 + 1012                                ; | X start position and width           ;
;  mov ecx, 5 shl 16 + 50                                  ; | Y start position and height          ;
;  mov edx, 0xFFFFFF                                       ; | Rect color, 0xRRGGBB                 ;
;  mcall                                                   ; /                                      ;
                                                                                                    ;
;  mov eax, 38                                             ; \ Calling SysFn38: Line Drawing        ;
;  mov ebx, 5 shl 16 + 1012                                ; | X start and end position             ;
;  mov ecx, 5 shl 16 + 50                                  ; | Y start and end position             ;
;  mov edx, 0x00FFFFFF                                     ; | Line color, 0x00RRGGBB               ;
;  mcall                                                   ; /                                      ;
                                                                                                    ;
                                                           ;----------------------------------------;
                                                           ;            Antenna drawings            ;
                                                           ;----------------------------------------;                                                                                                    ;
antenna_draw:                                              ; Antenna icon drawer function           ;
.body:                                                     ; Drawing a body                         ;
   mov eax, 38                                             ;                                        ;
   mov ebx, 810    shl 16 + 810                            ;                                        ;
   mov ecx, 10     shl 16 + 26                             ;                                        ;
   mov edx, [IFCLs + INTERFACECLR.antennagood]             ;                                        ;
   mcall                                                   ;                                        ;
                                                                                                    ;
   mov ebx, 804    shl 16 + 816                            ;                                        ;
   mov ecx, 10     shl 16 + 10                             ;                                        ;
   mcall                                                   ;                                        ;
                                                                                                    ;
   mov ebx, 804    shl 16 + 810                            ;                                        ;
   mov ecx, 10     shl 16 + 16                             ;                                        ;
   mcall                                                   ;                                        ;
                                                                                                    ;
   mov ebx, 816    shl 16 + 810                            ;                                        ;
   mcall                                                   ;                                        ;
                                                                                                    ;
   mov edx, [IFCLs + INTERFACECLR.sttsidle]                ;                                        ;
   mov ebx, 816    shl 16 + 816                            ;                                        ;
   mov ecx, 26     shl 16 + 18                             ;                                        ;
   mcall                                                   ;                                        ;
                                                                                                    ;
   mov ebx, 824    shl 16 + 824                            ;                                        ;
   mov ecx, 26     shl 16 + 14                             ;                                        ;
   mcall                                                   ;                                        ;
                                                                                                    ;
   mov ebx, 832    shl 16 + 832                            ;                                        ;
   mov ecx, 26     shl 16 + 10                             ;                                        ;
   mcall                                                   ;                                        ;
                                                                                                    ;
   ;cmp [signalLevel], 0                                    ;                                        ;
   cmp [generatorSeed], 0
   je  .nosignal                                           ;                                        ;
   ;cmp [signalLevel], 170                                  ;                                        ;
   cmp [generatorSeed], 170
   ja  .good                                               ;                                        ;
   ;cmp [signalLevel], 85                                   ;                                        ;
   cmp [generatorSeed], 85
   ja  .normal                                             ;                                        ;
   jmp .bad                                                ;                                        ;
                                                                                                    ;
.bad:                                                      ; Drawing if bad signal                  ;
   mov ebx, 816    shl 16 + 816                            ;                                        ;
   mov ecx, 26     shl 16 + 18                             ;                                        ;
   mov edx, [IFCLs + INTERFACECLR.antennabad]              ;                                        ;
   mcall                                                   ;                                        ;
   jmp @f                                                  ;                                        ;
                                                                                                    ;
.normal:                                                   ; If signal is normal                    ;
   mov ebx, 824    shl 16 + 824                            ;                                        ;
   mov ecx, 26     shl 16 + 14                             ;                                        ;
   mov edx, [IFCLs + INTERFACECLR.antennamid]              ;                                        ;
   mcall                                                                                            ;
                                                           ;                                        ;
   mov ebx, 816    shl 16 + 816                            ;                                        ;
   mov ecx, 26     shl 16 + 18                             ;                                        ;
   mcall                                                   ;                                        ;
   jmp @f                                                                                           ;
                                                                                                    ;
.good:                                                     ; If signal is good                      ;
   mov ebx, 832    shl 16 + 832                            ;                                        ;
   mov ecx, 26     shl 16 + 10   ;                         ;                                        ;
   mov edx, [IFCLs + INTERFACECLR.antennagood]             ;                                        ;
   mcall                                                   ;                                        ;
                                                                                                    ;
   mov ebx, 824    shl 16 + 824                            ;                                        ;
   mov ecx, 26     shl 16 + 14                             ;                                        ;
   mcall                                                   ;                                        ;
                                                                                                    ;
   mov ebx, 816    shl 16 + 816                            ;                                        ;
   mov ecx, 26     shl 16 + 18                             ;                                        ;
   mcall                                                   ;                                        ;
   jmp @f                                                  ;                                        ;
                                                                                                    ;
.nosignal:                                                 ; If no signal                           ;
   mov ebx, 804    shl 16 + 832                            ;                                        ;
   mov ecx, 10     shl 16 + 26                             ;                                        ;
   mov edx, [IFCLs + INTERFACECLR.antennabad]              ;                                        ;
   mcall                                                   ;                                        ;
                                                                                                    ;
   mov ecx, 26     shl 16 + 10                             ;                                        ;
   mcall                                                   ;                                        ;
   jmp @f                                                  ;                                        ;
                                                                                                    ;
@@:                                                                                                 ;
                                                           ;----------------------------------------;
                                                           ;             Frame drawings             ;
                                                           ;----------------------------------------;
                                                           ; Updated and optimized frame drawer
   mov ebx, [IFCPs + INTERFACEPOS.framex]                  ; See the syntax on line 90
   mov ecx, [IFCPs + INTERFACEPOS.framey]                  ;
   mov edx, [IFCLs + INTERFACECLR.frameclr]                ;
   mcall                                                   ;

   mov ecx, 45 * 65536 + 45                                ;
   mcall
                                ;
   mov ebx, 1017 * 65536 + 1017 ;
   mov ecx, 5 * 65536 + 763     ;
   mcall                        ;
                                ;
   mov ebx, 5 * 65536 + 5       ;
   mcall                        ;
                                ;
   mov ebx, 5 * 65536 + 1017    ;
   mov ecx, 763 * 65536 + 763   ;
   mcall                        ;
                                ;
   ;----------------------------;
   ;   Camera pic placeholder   ; Drawing a placeholder with size 644x480
   ;----------------------------;
   ;

   mov ecx, 530
@newLine:
   mov ebx, 784
@newPixel:
   rdtsc
   mov [generatorSeed], eax
   mov edx, 0

   mov ebp, 255
   div ebp
   mov [generatorSeed], edx

   mov ebp, [generatorSeed]
   mov edx, 0x00FFFFFF          ;
   xor edx, ebp
   mov ebp, [generatorSeed - 1]
   xor edx, ebp
   mov ebp, [generatorSeed - 2]
   xor edx, ebp

   mov eax, 1
   mcall

   dec ebx
   cmp ebx, 140
   jne @newPixel
@up:
   dec ecx
   cmp ecx, 50
   jne @newLine


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
   mov eax, 38                  ; Updated and optimized frame drawing
   mov ebx, 140 * 65536 + 784   ;
   mov ecx, 50 * 65536 + 50     ;
   mov edx, 0x00FFFF00          ;
   mcall                        ;
                                ;
   mov ecx, 530 * 65536 + 530   ;
   mcall                        ;
                                ;
   mov ebx, 140 * 65536 + 140   ;
   mov ecx, 50 * 65536 + 530    ;
   mcall                        ;
                                ;
   mov ebx, 784 * 65536 + 784   ;
   mcall                        ;
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

   mov ebx, [IFCPs + INTERFACEPOS.campictxpos]
   mov edx, signal
   mcall
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
   keyid db 0                  ; Reserved for pressed key ID's (1 byte)
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
   IFCPs             rd   15
   IFCLs             rd   19

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
   terminalIn        db   '#terminal > ', 0
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
   droneSF           db   'Savoir-Faire'
                                ;
   measure           db   'm/s^2', 0
   accelX            db   'X ACCELERATION: ', 0
   accelY            db   'Y ACCELERATION: ', 0
   accelZ            db   'Z ACCELERATION: ', 0
   transmission      db   'TRANSMISSION TYPE: ', 0
   trans_slow        db   'Slow', 0
   trans_normal      db   'Normal', 0
   trans_fast        db   'Fast', 0
   ping              db   'CONNECTION PING: ', 0
   ping_meas         db   'ms', 0

   signalLevel       db   0
   generatorSeed     dd   0, 0

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
   mvmt_idle         =     0x00646464
   mvmt_active       =     0x00FF6464
   accel_xaxis       =     0x00FF0000
   accel_yaxis       =     0x00FFFF00
   accel_zaxis       =     0x0000FF00
                                ;
   console_idle      =     0x00A0A0A0
   console_type      =     0x00D0D0D0
                                ;
   connect_bad       =     0x00FF0000
   connect_mid       =     0x00FFFF00
   connect_good      =     0x0000FF00
   connect_na        =     0x00A0A0A0
                                ;
   ;----------------------------;
   ;       DATA BLOCK END       ;
   ;----------------------------;
                                ;
UDATA                           ; PROGRAM UDATA BLOCK
                                ;
MEOS_APP_END                    ; PROGRAM END MACROS
