;---------------------------------------------------------------------------------------------------;
;                                     Drone terminal application                                    ;
;                                           Revision 0001                                           ;
;---------------------------------------------------------------------------------------------------;
;                                  Developed and edited by toqsycc                                  ;
;---------------------------------------------------------------------------------------------------;
;                                  Dec 2020 - Feb 2021 (c) toqsycc                                  ;
;---------------------------------------------------------------------------------------------------;
include "kolibrios/macros.inc"                                                 ; ADDITIVE LIBRARIES ;
;include "kolibrios/proc32.inc"                                                                     ;
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
   accent                  dd ?                                                                     ;
   background              dd ?                                                                     ;
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
   batbgclr                dd ?                                                                     ;
   batfrclr                dd ?                                                                     ;
   batclr                  dd ?                                                                     ;
ends                                                                                                ;
                                                                                                    ;
struct WNDPRM                                                                                       ;
   style                  dd ?                                                                      ;
   header                 dd ?                                                                      ;
   frame                  dd ?                                                                      ;
   txtcolor               dd ?                                                                      ;
ends                                                                                                ;
                                                                                                    ;
WINDOWSIZEX = 1024                                                                                  ;
WINDOWSIZEY = 768                                                                                   ;
                                                                                                    ;
configure:                                                                                          ;
   mov [IFCPs + INTERFACEPOS.framex],            1                    shl 16   + (WINDOWSIZEX - 2)  ;
   mov [IFCPs + INTERFACEPOS.framey],            5                    shl 16   + 5                  ;
   mov [IFCPs + INTERFACEPOS.campicpos],         140                  shl 16   + 50                 ;
   mov [IFCPs + INTERFACEPOS.campicsz],          644                  shl 16   + 480                ;
   mov [IFCPs + INTERFACEPOS.campictxpos],       (WINDOWSIZEX - 448)  shl 16   + 255                ;
   mov [IFCPs + INTERFACEPOS.campicnpos],        654                  shl 16   + 505                ;
   mov [IFCPs + INTERFACEPOS.cmdfrpos],          10                   shl 16   + 10                 ;
   mov [IFCPs + INTERFACEPOS.cmdfrsz],           (WINDOWSIZEX - 20)   shl 16   + 40                 ;
                                                                                                    ;
   mov [IFCLs + INTERFACECLR.accent],            0x00FF8615                                         ;
   mov [IFCLs + INTERFACECLR.background],        0x000F0F0F                                         ;
   mov [IFCLs + INTERFACECLR.frameclr],          0x00A0A0A0                                         ;
   mov [IFCLs + INTERFACECLR.campic1],           0x00FFFFFF                                         ;
   mov [IFCLs + INTERFACECLR.campic2],           0x00FFFF00                                         ;
   mov [IFCLs + INTERFACECLR.campic3],           0x0000FFFF                                         ;
   mov [IFCLs + INTERFACECLR.campic4],           0x0000FF00                                         ;
   mov [IFCLs + INTERFACECLR.campic5],           0x00FF00FF                                         ;
   mov [IFCLs + INTERFACECLR.campic6],           0x00FF0000                                         ;
   mov [IFCLs + INTERFACECLR.campic7],           0x000000FF                                         ;
   mov [IFCLs + INTERFACECLR.cmdhistory],        0x00646464                                         ;
   mov [IFCLs + INTERFACECLR.cmdlatest],         0x00FF9600                                         ;
   mov [IFCLs + INTERFACECLR.cmdcurrent],        0x0000FF00                                         ;
   mov [IFCLs + INTERFACECLR.antennabad],        0x00FF0000                                         ;
   mov [IFCLs + INTERFACECLR.antennamid],        0x00FFFF00                                         ;
   mov [IFCLs + INTERFACECLR.antennagood],       0x0000FF00                                         ;
   mov [IFCLs + INTERFACECLR.catgclr],           0x80FFFFFF                                         ;
   mov [IFCLs + INTERFACECLR.sttsidle],          0x00646464                                         ;
   mov [IFCLs + INTERFACECLR.sttsactive],        0x00FF9600                                         ;
   mov [IFCLs + INTERFACECLR.sttsdanger],        0x00FFA000                                         ;
   mov [IFCLs + INTERFACECLR.sttsdamage],        0x00FF3232                                         ;
   mov [IFCLs + INTERFACECLR.batbgclr],          0x00555555                                         ;
   mov [IFCLs + INTERFACECLR.batfrclr],          0x00C8C8C8                                         ;
   mov [IFCLs + INTERFACECLR.batclr],            0x00FF8615                                         ;
                                                                                                    ;
   mov [WPs + WNDPRM.style],                     0x30000000                                         ;
   mov [WPs + WNDPRM.header],                    0x01000000                                         ;
   mov [WPs + WNDPRM.frame],                     0x00000000                                         ;
   mov [WPs + WNDPRM.txtcolor],                  0x80000000                                         ;
                                                                                                    ;
;---------------------------------------------------------------------------------------------------;
;                                         MAIN PROGRAM BLOCK                                        ;
;---------------------------------------------------------------------------------------------------;
                                                                                                    ;
redraw:                                                    ; Window redrawing                       ;
@@:                                                                                                 ;
   call draw_window                                        ; Calling draw_window proc               ;
                                                                                                    ;
wait_event:                                                ; Waiting for an system event            ;
   mov eax, 23                                             ; \ Calling SysFn23: Timed waiting       ;
   mov ebx, 4                                              ; | Time of waiting in .01 ms            ;
   mcall                                                   ; /                                      ;
                                                                                                    ;
   cmp eax, 0                                              ; \ If SysEvent = 0, then                ;
   je redraw                                               ; / redraw window                        ;
                                                                                                    ;
   cmp eax, 1                                              ; \ If SysEvent = 1, then                ;
   je redraw                                               ; / redraw window                        ;
                                                                                                    ;
   cmp eax, 2                                              ; \ If SysEvent = 2, then                ;
   je key                                                  ; / process pressed key                  ;
                                                                                                    ;
   mcall -1                                                ; Else end process                       ;
                                                                                                    ;
   jmp wait_event                                          ; Returning back                         ;
                                                                                                    ;
key:                                                       ; Getting an ASCII number of pressed key ;
   mcall 2                                                 ; Calling SysFn02: Pressed key code      ;
   mov [keyid], ah                                         ; Move AH register value to keyid        ;
   cmp [keyid], 45                                         ; Compare keyid with 45 (-)              ;
   je .cam_dec                                             ; If = 45 then cam_dec, else continue    ;
                                                                                                    ;
   cmp [keyid], 43                                         ; Compare keyid with 43 (+)              ;
   je .cam_inc                                             ; If = 43 then cam_inc, else continue    ;
   jmp @b                                                  ; Else go redraw                         ;
                                                                                                    ;
.cam_dec:                                                  ; Switch camera num, backward            ;
   mov bl, [numCamera]                                                                              ;
   dec bl                                                                                           ;
   mov [numCamera], bl                                                                              ;
   xor ebx, ebx                                                                                     ;
   jmp @b                                                                                           ;
                                                                                                    ;
.cam_inc:                                                  ; Switch camera num, forward             ;
   mov bl, [numCamera]                                                                              ;
   inc bl                                                                                           ;
   mov [numCamera], bl                                                                              ;
   xor ebx, ebx                                                                                     ;
   jmp @b                                                                                           ;
                                                                                                    ;
;random_byte:
;@getSeed:
;   rdtsc
;   mov [generatorSeed], eax
;   mov edx, 0
;
;   cmp [generatorSeed], 0
;   je @getSeed
;
;   mov ebx, 255
;   div ebx
;   mov [generatorSeed], edx
;
;   jmp @f

;---------------------------------------------------------------------------------------------------;
;                                           WINDOW DRAWING                                          ;
;---------------------------------------------------------------------------------------------------;
                                                                                                    ;
draw_window:                                               ; Drawing a window                       ;
                                                                                                    ;
   mov eax, 12                                             ; \                                      ;
   mov ebx, 1                                              ; | Calling SysFn12: Window redraw, begin;
   mcall                                                   ; /                                      ;
                                                                                                    ;
   mov eax, 0                                              ; \ Calling SysFn00: Window definition   ;
   mov ebx, 0 shl 16 + (WINDOWSIZEX - 1)                   ; | X start position and width           ;
   mov ecx, 0 shl 16 + (WINDOWSIZEY - 1)                   ; | Y start position and height          ;
   mov edx, [WPs + WNDPRM.style]                           ; | Window style, 0xXYRRGGBB             ;
   xor edx, [IFCLs + INTERFACECLR.background]              ; } Interface bgnd color                 ;
   mov esi, [WPs + WNDPRM.header]                          ; | Header color, 0xXYRRGGBB             ;
   xor esi, [IFCLs + INTERFACECLR.accent]                  ; } Interface accent color               ;
   mov edi, [WPs + WNDPRM.frame]                           ; | Frame color, 0x00RRGGBB              ;
   xor edi, [IFCLs + INTERFACECLR.background]              ; } Interface bgnd color                 ;
   mcall                                                   ; /                                      ;
                                                                                                    ;
   mov eax, 71                                             ; \ Calling SysFn71: Window header       ;
   mov ebx, 2                                              ; | Use string address without codepage  ;
   mov ecx, header                                         ; | String address                       ;
   mov edx, 1                                              ; | Codepage                             ;
   mcall                                                   ; /                                      ;
                                                                                                    ;
;==========================================================;----------------------------------------;
;==========================================================;           Graphics functions           ;
;==========================================================;----------------------------------------;
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
;==========================================================;----------------------------------------;
;==========================================================;            Battery drawing             ;
;==========================================================;----------------------------------------;
                                                                                                    ;

                                                                                                    ;
;==========================================================;----------------------------------------;
;==========================================================;            Antenna drawing             ;
;==========================================================;----------------------------------------;
                                                                                                    ;
   jmp DrawAntenna                                                                                 ;
@ant_ok:
   jmp DrawBattery
@bat_ok:
                                                                                                    ;                                                                                                 ;
;==========================================================;----------------------------------------;
;==========================================================;             Frame drawing              ;
;==========================================================;----------------------------------------;
                                                                                                    ;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<;
                                                                                                    ;
   mov eax, 4                                                                                       ;
   mov ebx, (WINDOWSIZEX - 98)  shl 16 + 3                                                          ;
   mov ecx, [WPs + WNDPRM.txtcolor]                                                                 ;
   xor ecx, [IFCLs + INTERFACECLR.accent]                                                           ;
   mov edx, prot_dp40                                                                               ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 98)  shl 16 + 12                                                         ;
   mov edx, pingInfinity                                                                            ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 72)  shl 16 + 12                                                         ;
   mov edx, ping_meas                                                                               ;
   mcall                                                                                            ;
                                                                                                    ;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<;
                                                           ; !!! UPDATED FRAME DRAWER               ;
                                                           ; SEE THE SYNTAX IN "Graphics functions" ;
   mov eax, 38                                                                                      ;
   mov ebx, 1                   shl 16 + (WINDOWSIZEX - 2)                                          ;
   mov ecx, 1                   shl 16 + 1                                                          ;
   mov edx, [IFCLs + INTERFACECLR.frameclr]                                                         ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ecx, (WINDOWSIZEY - 24)  shl 16 + (WINDOWSIZEY - 24)                                         ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ecx, 21                  shl 16 + 21                                                         ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 2)   shl 16 + (WINDOWSIZEX - 2)                                          ;
   mov ecx, 1                   shl 16 + (WINDOWSIZEY - 24)                                         ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, 1                   shl 16 + 1                                                          ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ecx, 763                 shl 16 + 763                                                        ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 35)  shl 16 + (WINDOWSIZEX - 35)                                         ;
   mov ecx, 22                  shl 16 + (WINDOWSIZEY - 25)                                         ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, 2                   shl 16 + (WINDOWSIZEX - 36)                                         ;
   mov ecx, (WINDOWSIZEY - 76)  shl 16 + (WINDOWSIZEY - 76)                                         ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 683) shl 16 + (WINDOWSIZEX - 683)                                        ;
   mov ecx, 510                 shl 16 + (WINDOWSIZEY - 80)                                         ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 508) shl 16 + (WINDOWSIZEX - 508)                                        ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 503) shl 16 + (WINDOWSIZEX - 503)                                        ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 39)  shl 16 + (WINDOWSIZEX - 39)                                         ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ecx, 510                 shl 16 + 510                                                        ;
   mov ebx, (WINDOWSIZEX - 683) shl 16 + (WINDOWSIZEX - 509)                                        ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 502) shl 16 + (WINDOWSIZEX - 39)                                         ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ecx, (WINDOWSIZEY - 80)  shl 16 + (WINDOWSIZEY - 80)                                         ;
   mov ebx, (WINDOWSIZEX - 683) shl 16 + (WINDOWSIZEX - 509)                                        ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 502) shl 16 + (WINDOWSIZEX - 39)                                         ;
   mcall                                                                                            ;
                                                                                                    ;
;==========================================================;----------------------------------------;
;==========================================================;    Camera pic plceholder (644x480)     ;
;==========================================================;----------------------------------------;

;   mov ecx, 530
;@newLine:
;   mov ebx, 784
;@newPixel:
;   rdtsc
;   mov [generatorSeed], eax
;   mov edx, 0
;
;   mov ebp, 255
;   div ebp
;   mov [generatorSeed], edx
;
;   mov ebp, [generatorSeed]
;   mov edx, 0x00FFFFFF          ;
;   xor edx, ebp
;   mov ebp, [generatorSeed - 1]
;   xor edx, ebp
;   mov ebp, [generatorSeed - 2]
;   xor edx, ebp
;
;   mov eax, 1
;   mcall
;
;   dec ebx
;   cmp ebx, 140
;   jne @newPixel
;@up:
;   dec ecx
;   cmp ecx, 50
;   jne @newLine
                                                                                                    ;
;==========================================================;----------------------------------------;
;==========================================================;             Other frames               ;
;==========================================================;----------------------------------------;
                                                                                                    ;
   mov eax, 38                                             ; Updated and optimized frame drawing    ;
   mov ebx, (WINDOWSIZEX - 683) shl 16 + (WINDOWSIZEX - 39)                                         ;
   mov ecx, 26                  shl 16 + 26                                                         ;
   mov edx, [IFCLs + INTERFACECLR.accent]                                                           ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ecx, 506                 shl 16 + 506                                                        ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 683) shl 16 + (WINDOWSIZEX - 683)                                        ;
   mov ecx, 26                  shl 16 + 506                                                        ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 39)  shl 16 + (WINDOWSIZEX - 39)                                         ;
   mcall                                                                                            ;
                                                                                                    ;
;==========================================================;----------------------------------------;
;==========================================================;             Text drawing               ;
;==========================================================;----------------------------------------;
                                                                                                    ;
   mov eax, 4                                              ; \ Calling SysFn04: Text writing        ;
   mov ebx, (WINDOWSIZEX - 174) shl 16 + 479               ; | X start position and Y start position;
   mov ecx, 0xC2000000                                     ; | Text style, 0xXXRRGGBB               ;
   xor ecx, [IFCLs + INTERFACECLR.accent]                  ; } Theme accent color                   ;
   mov edx, cam                                            ; | String begin address                 ;
   mov edi, [IFCLs + INTERFACECLR.background]              ; } Theme background color, 0x00RRGGBB   ;
   mcall                                                   ; /                                      ;
                                                                                                    ;
   mov ebx, [IFCPs + INTERFACEPOS.campictxpos]                                                      ;
   mov edx, signal                                                                                  ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 57)  shl 16 + 479               ; Move to EBX register XY coordinate     ;
   mov edx, numCamera                                      ; Move to EDX register string address    ;
   mcall                                                   ; Call SysFn04                           ;
                                                                                                    ;
   mov ebx, 3                   shl 16 + (WINDOWSIZEY - 72)                                         ;
   mov ecx, [WPs + WNDPRM.txtcolor]                                                                 ;
   xor ecx, [IFCLs + INTERFACECLR.cmdhistory]                                                       ;
   mov edx, prevStatus2                                                                             ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, 3                   shl 16 + (WINDOWSIZEY - 62)                                         ;
   mov edx, prevStatus1                                                                             ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, 3                   shl 16 + (WINDOWSIZEY - 52)                                         ;
   mov ecx, [WPs + WNDPRM.txtcolor]                                                                 ;
   xor ecx, [IFCLs + INTERFACECLR.cmdlatest]                                                        ;
   mov edx, currStatus                                                                              ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, 3                   shl 16 + (WINDOWSIZEY - 36)                                         ;
   mov ecx, [WPs + WNDPRM.txtcolor]                                                                 ;
   xor ecx, [IFCLs + INTERFACECLR.cmdcurrent]                                                       ;
   mov edx, terminalIn                                                                              ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 68)  shl 16 + (WINDOWSIZEY - 72)                                         ;
   mov edx, terminalHeader                                                                          ;
   mcall                                                                                            ;
                                                                                                    ;
;==========================================================;----------------------------------------;
;==========================================================;             Text drawing               ;
;==========================================================;----------------------------------------;

   mov eax, 38
   mov ebx, (WINDOWSIZEX - 41) shl 16 + (WINDOWSIZEX - 116)
   mov ecx, 512 shl 16 + 512
   mov edx, [IFCLs + INTERFACECLR.frameclr]
   mcall

   mov ebx, (WINDOWSIZEX - 118) shl 16 + (WINDOWSIZEX - 193)
   mcall

   mov ebx, (WINDOWSIZEX - 195) shl 16 + (WINDOWSIZEX - 270)
   mcall

   mov ebx, (WINDOWSIZEX - 272) shl 16 + (WINDOWSIZEX - 347)
   mcall

   mov ebx, (WINDOWSIZEX - 349) shl 16 + (WINDOWSIZEX - 424)
   mcall

   mov ebx, (WINDOWSIZEX - 426) shl 16 + (WINDOWSIZEX - 501)
   mcall

   mov ecx, 529 shl 16 + 529
   mov ebx, (WINDOWSIZEX - 41) shl 16 + (WINDOWSIZEX - 116)
   mcall

   mov ebx, (WINDOWSIZEX - 118) shl 16 + (WINDOWSIZEX - 193)
   mcall

   mov ebx, (WINDOWSIZEX - 195) shl 16 + (WINDOWSIZEX - 270)
   mcall

   mov ebx, (WINDOWSIZEX - 272) shl 16 + (WINDOWSIZEX - 347)
   mcall

   mov ebx, (WINDOWSIZEX - 349) shl 16 + (WINDOWSIZEX - 424)
   mcall

   mov ebx, (WINDOWSIZEX - 426) shl 16 + (WINDOWSIZEX - 501)
   mcall

   mov ecx, 531 shl 16 + 531
   mov ebx, (WINDOWSIZEX - 41) shl 16 + (WINDOWSIZEX - 116)
   mcall

   mov ebx, (WINDOWSIZEX - 118) shl 16 + (WINDOWSIZEX - 193)
   mcall

   mov ebx, (WINDOWSIZEX - 195) shl 16 + (WINDOWSIZEX - 270)
   mcall

   mov ebx, (WINDOWSIZEX - 272) shl 16 + (WINDOWSIZEX - 347)
   mcall

   mov ebx, (WINDOWSIZEX - 349) shl 16 + (WINDOWSIZEX - 424)
   mcall

   mov ebx, (WINDOWSIZEX - 426) shl 16 + (WINDOWSIZEX - 501)
   mcall

   mov ecx, 548 shl 16 + 548
   mov ebx, (WINDOWSIZEX - 41) shl 16 + (WINDOWSIZEX - 116)
   mcall

   mov ebx, (WINDOWSIZEX - 118) shl 16 + (WINDOWSIZEX - 193)
   mcall

   mov ebx, (WINDOWSIZEX - 195) shl 16 + (WINDOWSIZEX - 270)
   mcall

   mov ebx, (WINDOWSIZEX - 272) shl 16 + (WINDOWSIZEX - 347)
   mcall

   mov ebx, (WINDOWSIZEX - 349) shl 16 + (WINDOWSIZEX - 424)
   mcall

   mov ebx, (WINDOWSIZEX - 426) shl 16 + (WINDOWSIZEX - 501)
   mcall

   mov ecx, 550 shl 16 + 550
   mov ebx, (WINDOWSIZEX - 41) shl 16 + (WINDOWSIZEX - 116)
   mcall

   mov ebx, (WINDOWSIZEX - 118) shl 16 + (WINDOWSIZEX - 193)
   mcall

   mov ebx, (WINDOWSIZEX - 195) shl 16 + (WINDOWSIZEX - 270)
   mcall

   mov ebx, (WINDOWSIZEX - 272) shl 16 + (WINDOWSIZEX - 347)
   mcall

   mov ebx, (WINDOWSIZEX - 349) shl 16 + (WINDOWSIZEX - 424)
   mcall

   mov ebx, (WINDOWSIZEX - 426) shl 16 + (WINDOWSIZEX - 501)
   mcall

   mov ecx, 567 shl 16 + 567
   mov ebx, (WINDOWSIZEX - 41) shl 16 + (WINDOWSIZEX - 116)
   mcall

   mov ebx, (WINDOWSIZEX - 118) shl 16 + (WINDOWSIZEX - 193)
   mcall

   mov ebx, (WINDOWSIZEX - 195) shl 16 + (WINDOWSIZEX - 270)
   mcall

   mov ebx, (WINDOWSIZEX - 272) shl 16 + (WINDOWSIZEX - 347)
   mcall

   mov ebx, (WINDOWSIZEX - 349) shl 16 + (WINDOWSIZEX - 424)
   mcall

   mov ebx, (WINDOWSIZEX - 426) shl 16 + (WINDOWSIZEX - 501)
   mcall

   mov ecx, 569 shl 16 + 569
   mov ebx, (WINDOWSIZEX - 41) shl 16 + (WINDOWSIZEX - 116)
   mcall

   mov ebx, (WINDOWSIZEX - 118) shl 16 + (WINDOWSIZEX - 193)
   mcall

   mov ebx, (WINDOWSIZEX - 195) shl 16 + (WINDOWSIZEX - 270)
   mcall

   mov ebx, (WINDOWSIZEX - 272) shl 16 + (WINDOWSIZEX - 347)
   mcall

   mov ebx, (WINDOWSIZEX - 349) shl 16 + (WINDOWSIZEX - 424)
   mcall

   mov ebx, (WINDOWSIZEX - 426) shl 16 + (WINDOWSIZEX - 501)
   mcall

   mov ecx, 586 shl 16 + 586
   mov ebx, (WINDOWSIZEX - 41) shl 16 + (WINDOWSIZEX - 116)
   mcall

   mov ebx, (WINDOWSIZEX - 118) shl 16 + (WINDOWSIZEX - 193)
   mcall

   mov ebx, (WINDOWSIZEX - 195) shl 16 + (WINDOWSIZEX - 270)
   mcall

   mov ebx, (WINDOWSIZEX - 272) shl 16 + (WINDOWSIZEX - 347)
   mcall

   mov ebx, (WINDOWSIZEX - 349) shl 16 + (WINDOWSIZEX - 424)
   mcall

   mov ebx, (WINDOWSIZEX - 426) shl 16 + (WINDOWSIZEX - 501)
   mcall

   mov ecx, 588 shl 16 + 588
   mov ebx, (WINDOWSIZEX - 41) shl 16 + (WINDOWSIZEX - 116)
   mcall

   mov ebx, (WINDOWSIZEX - 118) shl 16 + (WINDOWSIZEX - 193)
   mcall

   mov ebx, (WINDOWSIZEX - 195) shl 16 + (WINDOWSIZEX - 270)
   mcall

   mov ebx, (WINDOWSIZEX - 272) shl 16 + (WINDOWSIZEX - 347)
   mcall

   mov ebx, (WINDOWSIZEX - 349) shl 16 + (WINDOWSIZEX - 424)
   mcall

   mov ebx, (WINDOWSIZEX - 426) shl 16 + (WINDOWSIZEX - 501)
   mcall

   mov ecx, 605 shl 16 + 605
   mov ebx, (WINDOWSIZEX - 41) shl 16 + (WINDOWSIZEX - 116)
   mcall

   mov ebx, (WINDOWSIZEX - 118) shl 16 + (WINDOWSIZEX - 193)
   mcall

   mov ebx, (WINDOWSIZEX - 195) shl 16 + (WINDOWSIZEX - 270)
   mcall

   mov ebx, (WINDOWSIZEX - 272) shl 16 + (WINDOWSIZEX - 347)
   mcall

   mov ebx, (WINDOWSIZEX - 349) shl 16 + (WINDOWSIZEX - 424)
   mcall

   mov ebx, (WINDOWSIZEX - 426) shl 16 + (WINDOWSIZEX - 501)
   mcall

   mov ecx, 607 shl 16 + 607
   mov ebx, (WINDOWSIZEX - 41) shl 16 + (WINDOWSIZEX - 116)
   mcall

   mov ebx, (WINDOWSIZEX - 118) shl 16 + (WINDOWSIZEX - 193)
   mcall

   mov ebx, (WINDOWSIZEX - 195) shl 16 + (WINDOWSIZEX - 270)
   mcall

   mov ebx, (WINDOWSIZEX - 272) shl 16 + (WINDOWSIZEX - 347)
   mcall

   mov ebx, (WINDOWSIZEX - 349) shl 16 + (WINDOWSIZEX - 424)
   mcall

   mov ebx, (WINDOWSIZEX - 426) shl 16 + (WINDOWSIZEX - 501)
   mcall

   mov ecx, 624 shl 16 + 624
   mov ebx, (WINDOWSIZEX - 41) shl 16 + (WINDOWSIZEX - 116)
   mcall

   mov ebx, (WINDOWSIZEX - 118) shl 16 + (WINDOWSIZEX - 193)
   mcall

   mov ebx, (WINDOWSIZEX - 195) shl 16 + (WINDOWSIZEX - 270)
   mcall

   mov ebx, (WINDOWSIZEX - 272) shl 16 + (WINDOWSIZEX - 347)
   mcall

   mov ebx, (WINDOWSIZEX - 349) shl 16 + (WINDOWSIZEX - 424)
   mcall

   mov ebx, (WINDOWSIZEX - 426) shl 16 + (WINDOWSIZEX - 501)
   mcall

   mov ecx, 626 shl 16 + 626
   mov ebx, (WINDOWSIZEX - 41) shl 16 + (WINDOWSIZEX - 116)
   mcall

   mov ebx, (WINDOWSIZEX - 118) shl 16 + (WINDOWSIZEX - 193)
   mcall

   mov ebx, (WINDOWSIZEX - 195) shl 16 + (WINDOWSIZEX - 270)
   mcall

   mov ebx, (WINDOWSIZEX - 272) shl 16 + (WINDOWSIZEX - 347)
   mcall

   mov ebx, (WINDOWSIZEX - 349) shl 16 + (WINDOWSIZEX - 424)
   mcall

   mov ebx, (WINDOWSIZEX - 426) shl 16 + (WINDOWSIZEX - 501)
   mcall

   mov ecx, 643 shl 16 + 643
   mov ebx, (WINDOWSIZEX - 41) shl 16 + (WINDOWSIZEX - 116)
   mcall

   mov ebx, (WINDOWSIZEX - 118) shl 16 + (WINDOWSIZEX - 193)
   mcall

   mov ebx, (WINDOWSIZEX - 195) shl 16 + (WINDOWSIZEX - 270)
   mcall

   mov ebx, (WINDOWSIZEX - 272) shl 16 + (WINDOWSIZEX - 347)
   mcall

   mov ebx, (WINDOWSIZEX - 349) shl 16 + (WINDOWSIZEX - 424)
   mcall

   mov ebx, (WINDOWSIZEX - 426) shl 16 + (WINDOWSIZEX - 501)
   mcall

   mov ecx, 645 shl 16 + 645
   mov ebx, (WINDOWSIZEX - 41) shl 16 + (WINDOWSIZEX - 116)
   mcall

   mov ebx, (WINDOWSIZEX - 118) shl 16 + (WINDOWSIZEX - 193)
   mcall

   mov ebx, (WINDOWSIZEX - 195) shl 16 + (WINDOWSIZEX - 270)
   mcall

   mov ebx, (WINDOWSIZEX - 272) shl 16 + (WINDOWSIZEX - 347)
   mcall

   mov ebx, (WINDOWSIZEX - 349) shl 16 + (WINDOWSIZEX - 424)
   mcall

   mov ebx, (WINDOWSIZEX - 426) shl 16 + (WINDOWSIZEX - 501)
   mcall

   mov ecx, 662 shl 16 + 662
   mov ebx, (WINDOWSIZEX - 41) shl 16 + (WINDOWSIZEX - 116)
   mcall

   mov ebx, (WINDOWSIZEX - 118) shl 16 + (WINDOWSIZEX - 193)
   mcall

   mov ebx, (WINDOWSIZEX - 195) shl 16 + (WINDOWSIZEX - 270)
   mcall

   mov ebx, (WINDOWSIZEX - 272) shl 16 + (WINDOWSIZEX - 347)
   mcall

   mov ebx, (WINDOWSIZEX - 349) shl 16 + (WINDOWSIZEX - 424)
   mcall

   mov ebx, (WINDOWSIZEX - 426) shl 16 + (WINDOWSIZEX - 501)
   mcall

   mov ecx, 664 shl 16 + 664
   mov ebx, (WINDOWSIZEX - 41) shl 16 + (WINDOWSIZEX - 116)
   mcall

   mov ebx, (WINDOWSIZEX - 118) shl 16 + (WINDOWSIZEX - 193)
   mcall

   mov ebx, (WINDOWSIZEX - 195) shl 16 + (WINDOWSIZEX - 270)
   mcall

   mov ebx, (WINDOWSIZEX - 272) shl 16 + (WINDOWSIZEX - 347)
   mcall

   mov ebx, (WINDOWSIZEX - 349) shl 16 + (WINDOWSIZEX - 424)
   mcall

   mov ebx, (WINDOWSIZEX - 426) shl 16 + (WINDOWSIZEX - 501)
   mcall

   mov ecx, 681 shl 16 + 681
   mov ebx, (WINDOWSIZEX - 41) shl 16 + (WINDOWSIZEX - 116)
   mcall

   mov ebx, (WINDOWSIZEX - 118) shl 16 + (WINDOWSIZEX - 193)
   mcall

   mov ebx, (WINDOWSIZEX - 195) shl 16 + (WINDOWSIZEX - 270)
   mcall

   mov ebx, (WINDOWSIZEX - 272) shl 16 + (WINDOWSIZEX - 347)
   mcall

   mov ebx, (WINDOWSIZEX - 349) shl 16 + (WINDOWSIZEX - 424)
   mcall

   mov ebx, (WINDOWSIZEX - 426) shl 16 + (WINDOWSIZEX - 501)
   mcall

                                ;

   mov eax, 12                  ; \ Calling SysFn12: Window redraw, end
   mov ebx, 2                   ; /
   mcall                        ; Call SysFn12
   ret                          ;

;---------------------------------------------------------------------------------------------------;
;                                           PROCEDURE BLOCK                                         ;
;---------------------------------------------------------------------------------------------------;
                                                                                                    ;
DrawAntenna:                                                                                        ;
.body:                                                     ; Drawing a body                         ;
   mov eax, 38                                                                                      ;
   mov ebx, (WINDOWSIZEX - 119) shl 16 + (WINDOWSIZEX - 119)                                        ;
   mov ecx, 3                   shl 16 + 19                                                         ;
   mov edx, [IFCLs + INTERFACECLR.antennagood]                                                      ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 125) shl 16 + (WINDOWSIZEX - 113)                                        ;
   mov ecx, 3                   shl 16 + 3                                                          ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 125) shl 16 + (WINDOWSIZEX - 119)                                        ;
   mov ecx, 3                   shl 16 + 9                                                          ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 113) shl 16 + (WINDOWSIZEX - 119)                                        ;
   mcall                                                                                            ;
                                                                                                    ;
   mov edx, [IFCLs + INTERFACECLR.sttsidle]                                                         ;
   mov ebx, (WINDOWSIZEX - 113) shl 16 + (WINDOWSIZEX - 113)                                        ;
   mov ecx, 19                  shl 16 + 11                                                         ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 107) shl 16 + (WINDOWSIZEX - 107)                                        ;
   mov ecx, 19                  shl 16 + 7                                                          ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 101) shl 16 + (WINDOWSIZEX - 101)                                        ;
   mov ecx, 19                  shl 16 + 3                                                          ;
   mcall                                                                                            ;
                                                                                                    ;
   cmp [signalLevel], 0                                                                             ;
   je  .nosignal                                                                                    ;
   cmp [signalLevel], 170                                                                           ;
   ja  .good                                                                                        ;
   cmp [signalLevel], 85                                                                            ;
   ja  .normal                                                                                      ;
   jmp .bad                                                                                         ;
                                                                                                    ;
.bad:                                                      ; Drawing if bad signal                  ;
   mov ebx, (WINDOWSIZEX - 113) shl 16 + (WINDOWSIZEX - 113)                                        ;
   mov ecx, 19                  shl 16 + 11                                                         ;
   mov edx, [IFCLs + INTERFACECLR.antennabad]                                                       ;
   mcall                                                                                            ;
   jmp @ant_ok                                                                                      ;
                                                                                                    ;
.normal:                                                   ; If signal is normal                    ;
   mov ebx, (WINDOWSIZEX - 107) shl 16 + (WINDOWSIZEX - 107)                                        ;
   mov ecx, 19                  shl 16 + 7                                                          ;
   mov edx, [IFCLs + INTERFACECLR.antennamid]                                                       ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 113) shl 16 + (WINDOWSIZEX - 113)                                        ;
   mov ecx, 19                  shl 16 + 11                                                         ;
   mcall                                                                                            ;
   jmp @ant_ok                                                                                      ;
                                                                                                    ;
.good:                                                     ; If signal is good                      ;
   mov ebx, (WINDOWSIZEX - 101) shl 16 + (WINDOWSIZEX - 101)                                        ;
   mov ecx, 19                  shl 16 + 3   ;                                                      ;
   mov edx, [IFCLs + INTERFACECLR.antennagood]                                                      ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 107) shl 16 + (WINDOWSIZEX - 107)                                        ;
   mov ecx, 19                  shl 16 + 7                                                          ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 113) shl 16 + (WINDOWSIZEX - 113)                                        ;
   mov ecx, 19                  shl 16 + 11                                                         ;
   mcall                                                                                            ;
   jmp @ant_ok                                                                                      ;
                                                                                                    ;
.nosignal:                                                 ; If no signal                           ;
   mov ebx, (WINDOWSIZEX - 125) shl 16 + (WINDOWSIZEX - 101)                                        ;
   mov ecx, 3                   shl 16 + 19                                                         ;
   mov edx, [IFCLs + INTERFACECLR.antennabad]                                                       ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ecx, 19                  shl 16 + 3                                                          ;
   mcall                                                                                            ;
   jmp @ant_ok                                                                                      ;
                                                                                                    ;
DrawBattery:                                                                                        ;
.frame:                                                                                             ;
   mov eax, 13                                                                                      ;
   mov ebx, (WINDOWSIZEX - 57) shl 16 + 50                                                          ;
   mov ecx, 3 shl 16 + 16                                                                           ;
   mov edx, [IFCLs + INTERFACECLR.batbgclr]                                                         ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 7) shl 16 + 4                                                            ;
   mov ecx, 6 shl 16 + 10                                                                           ;
   mcall                                                                                            ;
                                                                                                    ;
                                                                                                    ;
.body:                                                                                              ;
   mov ebx, (WINDOWSIZEX - 56) shl 16 + 48                                                          ;
   mov ecx, 4 shl 16 + 14                                                                           ;
   mov edx, [IFCLs + INTERFACECLR.batfrclr]                                                         ;
   mcall                                                                                            ;
                                                                                                    ;
   mov ebx, (WINDOWSIZEX - 6) shl 16 + 2                                                            ;
   mov ecx, 7 shl 16 + 8                                                                            ;
   mcall                                                                                            ;
                                                                                                    ;
.charge:                                                                                            ;
   mov ebx, (WINDOWSIZEX - 55) shl 16                                                               ;
   xor bx, [batteryCharge];                                                                         ;
   mov ecx, 5 shl 16 + 12                                                                           ;
   mov edx, [IFCLs + INTERFACECLR.batclr]                                                           ;
   mcall                                                                                            ;
   xor bx, bx                                                                                       ;
   jmp @bat_ok                                                                                      ;
                                                                                                    ;
                                                           ;----------------------------------------;
                                                           ;          ADDITIONAL FUNCTIONS          ;
                                                           ;----------------------------------------;
                                ;
com_debug:                      ; COM port feedback
   mov eax, 4                   ; \ Calling SysFn04: Text writing
   mov ebx, 30 * 65536 + 30     ; | X start position and Y start position
   mov ecx, tstyle              ; | Text style, 0xXXRRGGBB
;   mov edx, string              ; | String begin address
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
   IFCLs             rd   24
   WPs               rd   4

   numCamera         db   49, 0
   header            db   '                                DRONE TERMINAL | REV. 0001 | TOQSYCC LABS 2020-2021', 0
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
   terminalIn        db   '#terminal > _', 0
   terminalHeader    db   'DEBUG', 0
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
   pingInfinity      db   'inf', 0
   prot_dp40         db   'DP-40', 0

   signalLevel       db   0
   pingValue         db   0
   generatorSeed     dd   0
   batteryCharge     dw   40

                                ;
   ;----------------------------;
   ;  ADDITIVE CONSTANTS BLOCK  ;
   ;----------------------------;
   ; name            | value    ;
                                ;
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
