; N64 'Bare Metal' CPU Unsigned Word Multiplication Test Demo by krom (Peter Lemon):

PrintString: macro vram,xpos,ypos,fontfile,string,length ; Print Text String To VRAM Using Font At X,Y Position
  lui t0,vram ; T0 = Frame Buffer Pointer
  addi t0,((xpos*4)+((640*ypos)*4)) ; Place text at XY Position
  la t1,fontfile ; T1 = Characters
  la t2,string ; T2 = Text Offset
  li t3,length ; T3 = Number of Text Characters to Print
  DrawChars\@:
    li t4,7 ; T4 = Character X Pixel Counter
    li t5,7 ; T5 = Character Y Pixel Counter

    lb t6,0(t2) ; T6 = Next Text Character
    addi t2,1

    sll t6,8 ; Add Shift to Correct Position in Font (* 256)
    add t6,t1

    DrawCharX\@:
      lw t7,0(t6) ; Load Font Text Character Pixel
      addi t6,4
      sw t7,0(t0) ; Store Font Text Character Pixel into Frame Buffer
      addi t0,4

      bnez t4,DrawCharX\@ ; IF Character X Pixel Counter != 0 GOTO DrawCharX
      subi t4,1 ; Decrement Character X Pixel Counter

      addi t0,$9E0 ; Jump down 1 Scanline, Jump back 1 Char ((SCREEN_X * 4) - (CHAR_X * 4))
      li t4,7 ; Reset Character X Pixel Counter
      bnez t5,DrawCharX\@ ; IF Character Y Pixel Counter != 0 GOTO DrawCharX
      subi t5,1 ; Decrement Character Y Pixel Counter

    subi t0,$4FE0 ; ((SCREEN_X * 4) * CHAR_Y) - CHAR_X * 4
    bnez t3,DrawChars\@ ; Continue to Print Characters
    subi t3,1 ; Subtract Number of Text Characters to Print
    endm

PrintValue: macro vram,xpos,ypos,fontfile,value,length ; Print HEX Chars To VRAM Using Font At X,Y Position
  lui t0,vram ; T0 = Frame Buffer Pointer
  addi t0,((xpos*4)+((640*ypos)*4)) ; Place text at XY Position
  la t1,fontfile ; T1 = Characters
  la t2,value ; T2 = Value Offset
  li t3,length ; T3 = Number of HEX Chars to Print
  DrawHEXChars\@:
    li t4,7 ; T4 = Character X Pixel Counter
    li t5,7 ; T5 = Character Y Pixel Counter

    lb t6,0(t2) ; T6 = Next 2 HEX Chars
    addi t2,1

    srl t7,t6,4 ; T7 = 2nd Nibble
    andi t7,$F
    subi t8,t7,9
    bgtz t8,HEXLetters\@
    addi t7,$30 ; Delay Slot
    j HEXEnd\@
    nop ; Delay Slot

    HEXLetters\@:
    addi t7,7
    HEXEnd\@:

    sll t7,8 ; Add Shift to Correct Position in Font (* 256)
    add t7,t1

    DrawHEXCharX\@:
      lw t8,0(t7) ; Load Font Text Character Pixel
      addi t7,4
      sw t8,0(t0) ; Store Font Text Character Pixel into Frame Buffer
      addi t0,4

      bnez t4,DrawHEXCharX\@ ; IF Character X Pixel Counter != 0 GOTO DrawCharX
      subi t4,1 ; Decrement Character X Pixel Counter

      addi t0,$9E0 ; Jump down 1 Scanline, Jump back 1 Char ((SCREEN_X * 4) - (CHAR_X * 4))
      li t4,7 ; Reset Character X Pixel Counter
      bnez t5,DrawHEXCharX\@ ; IF Character Y Pixel Counter != 0 GOTO DrawCharX
      subi t5,1 ; Decrement Character Y Pixel Counter

    subi t0,$4FE0 ; ((SCREEN_X * 4) * CHAR_Y) - CHAR_X * 4

    li t5,7 ; Reset Character Y Pixel Counter

    andi t7,t6,$F ; T7 = 1st Nibble
    subi t8,t7,9
    bgtz t8,HEXLettersB\@
    addi t7,$30 ; Delay Slot
    j HEXEndB\@
    nop ; Delay Slot

    HEXLettersB\@:
    addi t7,7
    HEXEndB\@:

    sll t7,8 ; Add Shift to Correct Position in Font (* 256)
    add t7,t1

    DrawHEXCharXB\@:
      lw t8,0(t7) ; Load Font Text Character Pixel
      addi t7,4
      sw t8,0(t0) ; Store Font Text Character Pixel into Frame Buffer
      addi t0,4

      bnez t4,DrawHEXCharXB\@ ; IF Character X Pixel Counter != 0 GOTO DrawCharX
      subi t4,1 ; Decrement Character X Pixel Counter

      addi t0,$9E0 ; Jump down 1 Scanline, Jump back 1 Char ((SCREEN_X * 4) - (CHAR_X * 4))
      li t4,7 ; Reset Character X Pixel Counter
      bnez t5,DrawHEXCharXB\@ ; IF Character Y Pixel Counter != 0 GOTO DrawCharX
      subi t5,1 ; Decrement Character Y Pixel Counter

    subi t0,$4FE0 ; ((SCREEN_X * 4) * CHAR_Y) - CHAR_X * 4

    bnez t3,DrawHEXChars\@ ; Continue to Print Characters
    subi t3,1 ; Subtract Number of Text Characters to Print
    endm

  include LIB\N64.INC ; Include N64 Definitions
  dcb 2097152,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  include LIB\N64_INIT.ASM ; Include Initialisation Routine
  include LIB\N64_GFX.INC  ; Include Graphics Macros

  ScreenNTSC 640,480, BPP32|INTERLACE|AA_MODE_2, $A0100000 ; Screen NTSC: 640x480, 32BPP, Interlace, Reample Only, DRAM Origin = $A0100000

  lui t0,$A010 ; T0 = VRAM Start Offset
  addi t1,t0,((640*480*4)-4) ; T1 = VRAM End Offset
  li t2,$000000FF ; T2 = Black
ClearScreen:
  sw t2,0(t0)
  bne t0,t1,ClearScreen
  addi t0,4 ; Delay Slot




  PrintString $A010,88,8,FontRed,RSRTHEX,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,232,8,FontRed,RSRTDEC,14 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,384,8,FontRed,LOHIHEX,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,528,8,FontRed,TEST,10 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,0,16,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,8,24,FontRed,MULTU,4 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUEWORDA ; T0 = Word Data Offset
  lw t0,0(t0)      ; T0 = Word Data
  la t1,VALUEWORDB ; T1 = Word Data Offset
  lw t1,0(t1)      ; T1 = Word Data
  multu t0,t1 ; HI/LO = Test Word Data
  mflo t0 ; T0 = LO
  la t1,LOWORD ; T1 = LOWORD Offset
  sw t0,0(t1)  ; LOWORD = Word Data
  mfhi t0 ; T0 = HI
  la t1,HIWORD ; T1 = HIWORD Offset
  sw t0,0(t1)  ; HIWORD = Word Data
  PrintString $A010,144,24,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,24,FontBlack,VALUEWORDA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,24,FontBlack,TEXTWORDA,0  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,24,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,24,FontBlack,LOWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,32,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,32,FontBlack,VALUEWORDB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,32,FontBlack,TEXTWORDB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,32,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,32,FontBlack,HIWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,LOWORD        ; T0 = Word Data Offset
  lw t1,0(t0)         ; T1 = Word Data
  la t0,MULTULOCHECKA ; T0 = Word Check Data Offset
  lw t2,0(t0)         ; T2 = Word Check Data
  beq t1,t2,MULTULOPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,24,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTUENDA
  nop ; Delay Slot
  MULTULOPASSA:
  PrintString $A010,528,24,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,HIWORD        ; T0 = Word Data Offset
  lw t1,0(t0)         ; T1 = Word Data
  la t0,MULTUHICHECKA ; T0 = Word Check Data Offset
  lw t2,0(t0)         ; T2 = Word Check Data
  beq t1,t2,MULTUHIPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTUENDA
  nop ; Delay Slot
  MULTUHIPASSA:
  PrintString $A010,528,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULTUENDA:

  la t0,VALUEWORDB ; T0 = Word Data Offset
  lw t0,0(t0)      ; T0 = Word Data
  la t1,VALUEWORDC ; T1 = Word Data Offset
  lw t1,0(t1)      ; T1 = Word Data
  multu t0,t1 ; HI/LO = Test Word Data
  mflo t0 ; T0 = LO
  la t1,LOWORD ; T1 = LOWORD Offset
  sw t0,0(t1)  ; LOWORD = Word Data
  mfhi t0 ; T0 = HI
  la t1,HIWORD ; T1 = HIWORD Offset
  sw t0,0(t1)  ; HIWORD = Word Data
  PrintString $A010,144,48,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,48,FontBlack,VALUEWORDB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,48,FontBlack,TEXTWORDB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,48,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,48,FontBlack,LOWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,56,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,56,FontBlack,VALUEWORDC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,56,FontBlack,TEXTWORDC,5  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,56,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,56,FontBlack,HIWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,LOWORD        ; T0 = Word Data Offset
  lw t1,0(t0)         ; T1 = Word Data
  la t0,MULTULOCHECKB ; T0 = Word Check Data Offset
  lw t2,0(t0)         ; T2 = Word Check Data
  beq t1,t2,MULTULOPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,48,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTUENDB
  nop ; Delay Slot
  MULTULOPASSB:
  PrintString $A010,528,48,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,HIWORD        ; T0 = Word Data Offset
  lw t1,0(t0)         ; T1 = Word Data
  la t0,MULTUHICHECKB ; T0 = Word Check Data Offset
  lw t2,0(t0)         ; T2 = Word Check Data
  beq t1,t2,MULTUHIPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTUENDB
  nop ; Delay Slot
  MULTUHIPASSB:
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULTUENDB:

  la t0,VALUEWORDC ; T0 = Word Data Offset
  lw t0,0(t0)      ; T0 = Word Data
  la t1,VALUEWORDD ; T1 = Word Data Offset
  lw t1,0(t1)      ; T1 = Word Data
  multu t0,t1 ; HI/LO = Test Word Data
  mflo t0 ; T0 = LO
  la t1,LOWORD ; T1 = LOWORD Offset
  sw t0,0(t1)  ; LOWORD = Word Data
  mfhi t0 ; T0 = HI
  la t1,HIWORD ; T1 = HIWORD Offset
  sw t0,0(t1)  ; HIWORD = Word Data
  PrintString $A010,144,72,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,72,FontBlack,VALUEWORDC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,72,FontBlack,TEXTWORDC,5  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,72,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,72,FontBlack,LOWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,80,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,80,FontBlack,VALUEWORDD,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,80,FontBlack,TEXTWORDD,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,80,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,80,FontBlack,HIWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,LOWORD        ; T0 = Word Data Offset
  lw t1,0(t0)         ; T1 = Word Data
  la t0,MULTULOCHECKC ; T0 = Word Check Data Offset
  lw t2,0(t0)         ; T2 = Word Check Data
  beq t1,t2,MULTULOPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,72,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTUENDC
  nop ; Delay Slot
  MULTULOPASSC:
  PrintString $A010,528,72,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,HIWORD        ; T0 = Word Data Offset
  lw t1,0(t0)         ; T1 = Word Data
  la t0,MULTUHICHECKC ; T0 = Word Check Data Offset
  lw t2,0(t0)         ; T2 = Word Check Data
  beq t1,t2,MULTUHIPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,80,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTUENDC
  nop ; Delay Slot
  MULTUHIPASSC:
  PrintString $A010,528,80,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULTUENDC:

  la t0,VALUEWORDD ; T0 = Word Data Offset
  lw t0,0(t0)      ; T0 = Word Data
  la t1,VALUEWORDE ; T1 = Word Data Offset
  lw t1,0(t1)      ; T1 = Word Data
  multu t0,t1 ; HI/LO = Test Word Data
  mflo t0 ; T0 = LO
  la t1,LOWORD ; T1 = LOWORD Offset
  sw t0,0(t1)  ; LOWORD = Word Data
  mfhi t0 ; T0 = HI
  la t1,HIWORD ; T1 = HIWORD Offset
  sw t0,0(t1)  ; HIWORD = Word Data
  PrintString $A010,144,96,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,96,FontBlack,VALUEWORDD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,96,FontBlack,TEXTWORDD,8   ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,96,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,96,FontBlack,LOWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,104,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,104,FontBlack,VALUEWORDE,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,104,FontBlack,TEXTWORDE,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,104,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,104,FontBlack,HIWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,LOWORD        ; T0 = Word Data Offset
  lw t1,0(t0)         ; T1 = Word Data
  la t0,MULTULOCHECKD ; T0 = Word Check Data Offset
  lw t2,0(t0)         ; T2 = Word Check Data
  beq t1,t2,MULTULOPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,96,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTUENDD
  nop ; Delay Slot
  MULTULOPASSD:
  PrintString $A010,528,96,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,HIWORD        ; T0 = Word Data Offset
  lw t1,0(t0)         ; T1 = Word Data
  la t0,MULTUHICHECKD ; T0 = Word Check Data Offset
  lw t2,0(t0)         ; T2 = Word Check Data
  beq t1,t2,MULTUHIPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTUENDD
  nop ; Delay Slot
  MULTUHIPASSD:
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULTUENDD:

  la t0,VALUEWORDE ; T0 = Word Data Offset
  lw t0,0(t0)      ; T0 = Word Data
  la t1,VALUEWORDF ; T1 = Word Data Offset
  lw t1,0(t1)      ; T1 = Word Data
  multu t0,t1 ; HI/LO = Test Word Data
  mflo t0 ; T0 = LO
  la t1,LOWORD ; T1 = LOWORD Offset
  sw t0,0(t1)  ; LOWORD = Word Data
  mfhi t0 ; T0 = HI
  la t1,HIWORD ; T1 = HIWORD Offset
  sw t0,0(t1)  ; HIWORD = Word Data
  PrintString $A010,144,120,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,120,FontBlack,VALUEWORDE,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,120,FontBlack,TEXTWORDE,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,120,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,120,FontBlack,LOWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,128,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,128,FontBlack,VALUEWORDF,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,128,FontBlack,TEXTWORDF,6  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,128,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,128,FontBlack,HIWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,LOWORD        ; T0 = Word Data Offset
  lw t1,0(t0)         ; T1 = Word Data
  la t0,MULTULOCHECKE ; T0 = Word Check Data Offset
  lw t2,0(t0)         ; T2 = Word Check Data
  beq t1,t2,MULTULOPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,120,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTUENDE
  nop ; Delay Slot
  MULTULOPASSE:
  PrintString $A010,528,120,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,HIWORD        ; T0 = Word Data Offset
  lw t1,0(t0)         ; T1 = Word Data
  la t0,MULTUHICHECKE ; T0 = Word Check Data Offset
  lw t2,0(t0)         ; T2 = Word Check Data
  beq t1,t2,MULTUHIPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTUENDE
  nop ; Delay Slot
  MULTUHIPASSE:
  PrintString $A010,528,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULTUENDE:

  la t0,VALUEWORDF ; T0 = Word Data Offset
  lw t0,0(t0)      ; T0 = Word Data
  la t1,VALUEWORDG ; T1 = Word Data Offset
  lw t1,0(t1)      ; T1 = Word Data
  multu t0,t1 ; HI/LO = Test Word Data
  mflo t0 ; T0 = LO
  la t1,LOWORD ; T1 = LOWORD Offset
  sw t0,0(t1)  ; LOWORD = Word Data
  mfhi t0 ; T0 = HI
  la t1,HIWORD ; T1 = HIWORD Offset
  sw t0,0(t1)  ; HIWORD = Word Data
  PrintString $A010,144,144,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,144,FontBlack,VALUEWORDF,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,144,FontBlack,TEXTWORDF,6  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,144,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,144,FontBlack,LOWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,152,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,152,FontBlack,VALUEWORDG,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,152,FontBlack,TEXTWORDG,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,152,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,152,FontBlack,HIWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,LOWORD        ; T0 = Word Data Offset
  lw t1,0(t0)         ; T1 = Word Data
  la t0,MULTULOCHECKF ; T0 = Word Check Data Offset
  lw t2,0(t0)         ; T2 = Word Check Data
  beq t1,t2,MULTULOPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,144,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTUENDF
  nop ; Delay Slot
  MULTULOPASSF:
  PrintString $A010,528,144,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,HIWORD        ; T0 = Word Data Offset
  lw t1,0(t0)         ; T1 = Word Data
  la t0,MULTUHICHECKF ; T0 = Word Check Data Offset
  lw t2,0(t0)         ; T2 = Word Check Data
  beq t1,t2,MULTUHIPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,152,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTUENDF
  nop ; Delay Slot
  MULTUHIPASSF:
  PrintString $A010,528,152,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULTUENDF:

  la t0,VALUEWORDA ; T0 = Word Data Offset
  lw t0,0(t0)      ; T0 = Word Data
  la t1,VALUEWORDG ; T1 = Word Data Offset
  lw t1,0(t1)      ; T1 = Word Data
  multu t0,t1 ; HI/LO = Test Word Data
  mflo t0 ; T0 = LO
  la t1,LOWORD ; T1 = LOWORD Offset
  sw t0,0(t1)  ; LOWORD = Word Data
  mfhi t0 ; T0 = HI
  la t1,HIWORD ; T1 = HIWORD Offset
  sw t0,0(t1)  ; HIWORD = Word Data
  PrintString $A010,144,168,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,168,FontBlack,VALUEWORDA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,168,FontBlack,TEXTWORDA,0  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,168,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,168,FontBlack,LOWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,176,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,176,FontBlack,VALUEWORDG,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,176,FontBlack,TEXTWORDG,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,176,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,176,FontBlack,HIWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,LOWORD        ; T0 = Word Data Offset
  lw t1,0(t0)         ; T1 = Word Data
  la t0,MULTULOCHECKG ; T0 = Word Check Data Offset
  lw t2,0(t0)         ; T2 = Word Check Data
  beq t1,t2,MULTULOPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,168,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTUENDG
  nop ; Delay Slot
  MULTULOPASSG:
  PrintString $A010,528,168,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,HIWORD        ; T0 = Word Data Offset
  lw t1,0(t0)         ; T1 = Word Data
  la t0,MULTUHICHECKG ; T0 = Word Check Data Offset
  lw t2,0(t0)         ; T2 = Word Check Data
  beq t1,t2,MULTUHIPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,176,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTUENDG
  nop ; Delay Slot
  MULTUHIPASSG:
  PrintString $A010,528,176,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULTUENDG:


  PrintString $A010,0,184,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  lui t0,VI_BASE ; Load VI Base Register
Loop:
  WaitScanline $200 ; Wait For Scanline To Reach Vertical Blank
  WaitScanline $202

  li t1,$00000800 ; Even Field
  sw t1,VI_Y_SCALE(t0)

  WaitScanline $200 ; Wait For Scanline To Reach Vertical Blank
  WaitScanline $202

  li t1,$02000800 ; Odd Field
  sw t1,VI_Y_SCALE(t0)

  j Loop
  nop ; Delay Slot

MULTU: db "MULTU"

LOHIHEX: db "LO/HI (Hex)"
RSRTHEX: db "RS/RT (Hex)"
RSRTDEC: db "RS/RT (Decimal)"
TEST: db "Test Result"
FAIL: db "FAIL"
PASS: db "PASS"

DOLLAR: db "$"

TEXTWORDA: db "0"
TEXTWORDB: db "123456789"
TEXTWORDC: db "123456"
TEXTWORDD: db "123451234"
TEXTWORDE: db "1234512345"
TEXTWORDF: db "1234567"
TEXTWORDG: db "1234567897"

PAGEBREAK: db "--------------------------------------------------------------------------------"

  align 8 ; Align 64-bit
VALUEWORDA: dw 0
VALUEWORDB: dw 123456789
VALUEWORDC: dw 123456
VALUEWORDD: dw 123451234
VALUEWORDE: dw 1234512345
VALUEWORDF: dw 1234567
VALUEWORDG: dw 1234567891

MULTULOCHECKA: dw $00000000
MULTUHICHECKA: dw $00000000
MULTULOCHECKB: dw $AF14CF40
MULTUHICHECKB: dw $00000DDC
MULTULOCHECKC: dw $86345C80
MULTUHICHECKC: dw $00000DDC
MULTULOCHECKD: dw $9B272412
MULTUHICHECKD: dw $021D70E0
MULTULOCHECKE: dw $6FE6776F
MULTUHICHECKE: dw $00056A26
MULTULOCHECKF: dw $674DDF45
MULTUHICHECKF: dw $00056A36
MULTULOCHECKG: dw $00000000
MULTUHICHECKG: dw $00000000

LOWORD: dw 0
HIWORD: dw 0

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin