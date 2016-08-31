// N64 'Bare Metal' 16BPP 320x240 Cycle1 Texture Triangle RGBA32B RDP Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "Cycle1TextureTriangle16BPPRGBA32B320X240.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP16|AA_MODE_2, $A0100000) // Screen NTSC: 320x240, 16BPP, Resample Only, DRAM Origin $A0100000

  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  DPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start, End

Loop:
  j Loop
  nop // Delay Slot

align(8) // Align 64-Bit
RDPBuffer:
arch n64.rdp
  Set_Scissor 0<<2,0<<2, 0,0, 320<<2,240<<2 // Set Scissor: XH 0.0,YH 0.0, Scissor Field Enable Off,Field Off, XL 320.0,YL 240.0
  Set_Other_Modes CYCLE_TYPE_FILL // Set Other Modes
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $FF01FF01 // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0

  Set_Other_Modes SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER|B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN // Set Other Modes
  Set_Combine_Mode $0,$00, 0,0, $1,$01, $0,$F, 1,0, 0,0,0, 7,7,7 // Set Combine Mode: SubA RGB0,MulRGB0, SubA Alpha0,MulAlpha0, SubA RGB1,MulRGB1, SubB RGB0,SubB RGB1, SubA Alpha1,MulAlpha1, AddRGB0,SubB Alpha0,AddAlpha0, AddRGB1,SubB Alpha1,AddAlpha1


  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,8-1, Texture8x8 // Set Texture Image: FORMAT RGBA,SIZE 32B,WIDTH 8, Texture8x8 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,2, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 32B,Tile Line Size 2 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  // Right Major Triangle (Dir=1)
  //
  //      DxMDy
  //      .___. v[2]:XH,XM(X:64.0) YH(Y:52.0), v[1]:XL(X:80.0) YM(Y:52.0)
  //      |  /
  // DxHDy| /DxLDy
  //      ./    v[0]:(X:64.0) YL(Y:68.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 68.0,YM 52.0,YH 52.0, XL 80.0,DxLDy -1.0, XH 64.0,DxHDy 0.0, XM 64.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 272,208,208, 80,0,-1,0, 64,0,0,0, 64,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 0.0,T 0.0,W 0.0, DsDx 16.0,DtDx 0.0,DwDx 0.0, DsDe 0.0,DtDe 16.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 0,0,0, 16,0,0, 0,0,0, 0,0,0, 0,16,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf
  // Right Major Triangle (Dir=1)
  //
  //        . v[2]:XH,XM(X:80.0) YH(Y:52.0)
  //       /|
  // DxHDy/ |DxMDy
  //    ./__. v[0]:(X:64.0) YL(Y:68.0), v[1]:XL(X:80.0) YM(Y:68.0)
  //    DxLDy
  //
  // Output: Dir 1,Level 0,Tile 0, YL 68.0,YM 68.0,YH 52.0, XL 80.0,DxLDy 0.0, XH 80.0,DxHDy -1.0, XM 80.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 272,272,208, 80,0,0,0, 80,0,-1,0, 80,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 256.0,T -12.0,W 0.0, DsDx 16.0,DtDx 0.0,DwDx 0.0, DsDe -16.0,DtDe 16.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 256,-12,0, 16,0,0, 0,0,0, 0,0,0, -16,16,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf

  Sync_Tile // Sync Tile
  // Right Major Triangle (Dir=1)
  //
  //      DxMDy
  //      .___. v[2]:XH,XM(X:72.0) YH(Y:122.0), v[1]:XL(X:80.0) YM(Y:122.0)
  //      |  /
  // DxHDy| /DxLDy
  //      ./    v[0]:(X:72.0) YL(Y:130.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 130.0,YM 122.0,YH 122.0, XL 80.0,DxLDy -1.0, XH 72.0,DxHDy 0.0, XM 72.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 520,488,488, 80,0,-1,0, 72,0,0,0, 72,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 0.0,T 0.0,W 0.0, DsDx 32.0,DtDx 0.0,DwDx 0.0, DsDe 0.0,DtDe 32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 0,0,0, 32,0,0, 0,0,0, 0,0,0, 0,32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf
  // Right Major Triangle (Dir=1)
  //
  //        . v[2]:XH,XM(X:80.0) YH(Y:122.0)
  //       /|
  // DxHDy/ |DxMDy
  //    ./__. v[0]:(X:72.0) YL(Y:130.0), v[1]:XL(X:80.0) YM(Y:130.0)
  //    DxLDy
  //
  // Output: Dir 1,Level 0,Tile 0, YL 130.0,YM 130.0,YH 122.0, XL 84.0,DxLDy 0.0, XH 84.0,DxHDy -1.0, XM 84.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 520,520,488, 80,0,0,0, 80,0,-1,0, 80,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 256.0,T -24.0,W 0.0, DsDx 32.0,DtDx 0.0,DwDx 0.0, DsDe -32.0,DtDe 32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 256,-24,0, 32,0,0, 0,0,0, 0,0,0, -32,32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf

  Sync_Tile // Sync Tile
  // Right Major Triangle (Dir=1)
  //
  //      DxMDy
  //      .___. v[2]:XH,XM(X:72.0) YH(Y:192.0), v[1]:XL(X:80.0) YM(Y:192.0)
  //      |  /
  // DxHDy| /DxLDy
  //      ./    v[0]:(X:72.0) YL(Y:200.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 200.0,YM 192.0,YH 192.0, XL 80.0,DxLDy -1.0, XH 72.0,DxHDy 0.0, XM 72.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 800,768,768, 80,0,-1,0, 72,0,0,0, 72,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 0.0,T 0.0,W 0.0, DsDx 0.0,DtDx 32.0,DwDx 0.0, DsDe 32.0,DtDe 0.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 0,0,0, 0,32,0, 0,0,0, 0,0,0, 32,0,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf
  // Right Major Triangle (Dir=1)
  //
  //        . v[2]:XH,XM(X:80.0) YH(Y:192.0)
  //       /|
  // DxHDy/ |DxMDy
  //    ./__. v[0]:(X:72.0) YL(Y:200.0), v[1]:XL(X:80.0) YM(Y:200.0)
  //    DxLDy
  //
  // Output: Dir 1,Level 0,Tile 0, YL 200.0,YM 200.0,YH 192.0, XL 80.0,DxLDy 0.0, XH 80.0,DxHDy -1.0, XM 80.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 800,800,768, 80,0,0,0, 80,0,-1,0, 80,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S -24.0,T 256.0,W 0.0, DsDx 0.0,DtDx 32.0,DwDx 0.0, DsDe 32.0,DtDe -32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients -24,256,0, 0,32,0, 0,0,0, 0,0,0, 32,-32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,16-1, Texture16x16 // Set Texture_Image: FORMAT RGBA,SIZE 32B,WIDTH 16, Texture16x16 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,4, $000, 0,0, 0,0,0,SHIFT_T_1, 0,0,0,SHIFT_S_1 // Set Tile: FORMAT RGBA,SIZE 32B,Tile Line Size 4 (64bit Words), TMEM Address $000, Tile 0, Shift T 1,Shift S 1
  Load_Tile 0<<2,0<<2, 0, 15<<2,15<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 15.0,TH 15.0
  // Right Major Triangle (Dir=1)
  //
  //      DxMDy
  //      .___. v[2]:XH,XM(X:136.0) YH(Y:44.0), v[1]:XL(X:168.0) YM(Y:44.0)
  //      |  /
  // DxHDy| /DxLDy
  //      ./    v[0]:(X:136.0) YL(Y:76.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 76.0,YM 44.0,YH 44.0, XL 168.0,DxLDy -1.0, XH 136.0,DxHDy 0.0, XM 136.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 304,176,176, 168,0,-1,0, 136,0,0,0, 136,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 0.0,T 0.0,W 0.0, DsDx 32.0,DtDx 0.0,DwDx 0.0, DsDe 0.0,DtDe 32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 0,0,0, 32,0,0, 0,0,0, 0,0,0, 0,32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf
  // Right Major Triangle (Dir=1)
  //
  //        . v[2]:XH,XM(X:168.0) YH(Y:44.0)
  //       /|
  // DxHDy/ |DxMDy
  //    ./__. v[0]:(X:136.0) YL(Y:76.0), v[1]:XL(X:168.0) YM(Y:76.0)
  //    DxLDy
  //
  // Output: Dir 1,Level 0,Tile 0, YL 76.0,YM 76.0,YH 44.0, XL 168.0,DxLDy 0.0, XH 168.0,DxHDy -1.0, XM 168.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 304,304,176, 168,0,0,0, 168,0,-1,0, 168,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 1024.0,T -24.0,W 0.0, DsDx 32.0,DtDx 0.0,DwDx 0.0, DsDe -32.0,DtDe 32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 1024,-24,0, 32,0,0, 0,0,0, 0,0,0, -32,32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf

  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,4, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 32B,Tile Line Size 4 (64bit Words), TMEM Address $000, Tile 0
  // Right Major Triangle (Dir=1)
  //
  //      DxMDy
  //      .___. v[2]:XH,XM(X:152.0) YH(Y:114.0), v[1]:XL(X:168.0) YM(Y:114.0)
  //      |  /
  // DxHDy| /DxLDy
  //      ./    v[0]:(X:152.0) YL(Y:130.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 130.0,YM 114.0,YH 114.0, XL 168.0,DxLDy -1.0, XH 152.0,DxHDy 0.0, XM 152.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 520,456,456, 168,0,-1,0, 152,0,0,0, 152,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 0.0,T 0.0,W 0.0, DsDx 32.0,DtDx 0.0,DwDx 0.0, DsDe 0.0,DtDe 32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 0,0,0, 32,0,0, 0,0,0, 0,0,0, 0,32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf
  // Right Major Triangle (Dir=1)
  //
  //        . v[2]:XH,XM(X:168.0) YH(Y:114.0)
  //       /|
  // DxHDy/ |DxMDy
  //    ./__. v[0]:(X:152.0) YL(Y:130.0), v[1]:XL(X:168.0) YM(Y:130.0)
  //    DxLDy
  //
  // Output: Dir 1,Level 0,Tile 0, YL 130.0,YM 130.0,YH 114.0, XL 168.0,DxLDy 0.0, XH 168.0,DxHDy -1.0, XM 168.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 520,520,456, 168,0,0,0, 168,0,-1,0, 168,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 512.0,T -24.0,W 0.0, DsDx 32.0,DtDx 0.0,DwDx 0.0, DsDe -32.0,DtDe 32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 512,-24,0, 32,0,0, 0,0,0, 0,0,0, -32,32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf

  Sync_Tile // Sync Tile
  // Right Major Triangle (Dir=1)
  //
  //      DxMDy
  //      .___. v[2]:XH,XM(X:152.0) YH(Y:184.0), v[1]:XL(X:168.0) YM(Y:184.0)
  //      |  /
  // DxHDy| /DxLDy
  //      ./    v[0]:(X:152.0) YL(Y:200.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 200.0,YM 184.0,YH 184.0, XL 168.0,DxLDy -1.0, XH 152.0,DxHDy 0.0, XM 152.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 800,736,736, 168,0,-1,0, 152,0,0,0, 152,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 0.0,T 0.0,W 0.0, DsDx 0.0,DtDx 32.0,DwDx 0.0, DsDe 32.0,DtDe 0.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 0,0,0, 0,32,0, 0,0,0, 0,0,0, 32,0,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf
  // Right Major Triangle (Dir=1)
  //
  //        . v[2]:XH,XM(X:168.0) YH(Y:184.0)
  //       /|
  // DxHDy/ |DxMDy
  //    ./__. v[0]:(X:152.0) YL(Y:200.0), v[1]:XL(X:168.0) YM(Y:200.0)
  //    DxLDy
  //
  // Output: Dir 1,Level 0,Tile 0, YL 200.0,YM 200.0,YH 184.0, XL 168.0,DxLDy 0.0, XH 168.0,DxHDy -1.0, XM 168.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 800,800,736, 168,0,0,0, 168,0,-1,0, 168,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S -24.0,T 512.0,W 0.0, DsDx 0.0,DtDx 32.0,DwDx 0.0, DsDe 32.0,DtDe -32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients -24,512,0, 0,32,0, 0,0,0, 0,0,0, 32,-32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,32-1, Texture32x32 // Set Texture Image: FORMAT RGBA,SIZE 32B,WIDTH 32, Texture32x32 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,8, $000, 0,0, 0,MIRROR_T,MASK_T_4,0, 0,MIRROR_S,MASK_S_4,0 // Set Tile: FORMAT RGBA,SIZE 32B,Tile Line Size 8 (64bit Words), TMEM Address $000, Tile 0, MIRROR T,MASK T 4, MIRROR S,MASK S 4
  Load_Tile 0<<2,0<<2, 0, 31<<2,31<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 31.0,TH 31.0
  // Right Major Triangle (Dir=1)
  //
  //      DxMDy
  //      .___. v[2]:XH,XM(X:212.0) YH(Y:28.0), v[1]:XL(X:276.0) YM(Y:28.0)
  //      |  /
  // DxHDy| /DxLDy
  //      ./    v[0]:(X:212.0) YL(Y:92.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 92.0,YM 28.0,YH 28.0, XL 276.0,DxLDy -1.0, XH 212.0,DxHDy 0.0, XM 212.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 368,112,112, 276,0,-1,0, 212,0,0,0, 212,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 0.0,T 0.0,W 0.0, DsDx 32.0,DtDx 0.0,DwDx 0.0, DsDe 0.0,DtDe 32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 0,0,0, 32,0,0, 0,0,0, 0,0,0, 0,32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf
  // Right Major Triangle (Dir=1)
  //
  //        . v[2]:XH,XM(X:276.0) YH(Y:28.0)
  //       /|
  // DxHDy/ |DxMDy
  //    ./__. v[0]:(X:212.0) YL(Y:92.0), v[1]:XL(X:212.0) YM(Y:92.0)
  //    DxLDy
  //
  // Output: Dir 1,Level 0,Tile 0, YL 92.0,YM 92.0,YH 28.0, XL 276.0,DxLDy 0.0, XH 276.0,DxHDy -1.0, XM 276.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 368,368,112, 276,0,0,0, 276,0,-1,0, 276,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 1024.0,T -24.0,W 0.0, DsDx 32.0,DtDx 0.0,DwDx 0.0, DsDe -32.0,DtDe 32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 1024,-24,0, 32,0,0, 0,0,0, 0,0,0, -32,32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf

  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,8, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 32B,Tile Line Size 8 (64bit Words), TMEM Address $000, Tile 0
  // Right Major Triangle (Dir=1)
  //
  //      DxMDy
  //      .___. v[2]:XH,XM(X:244.0) YH(Y:98.0), v[1]:XL(X:276.0) YM(Y:98.0)
  //      |  /
  // DxHDy| /DxLDy
  //      ./    v[0]:(X:244.0) YL(Y:130.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 130.0,YM 98.0,YH 98.0, XL 276.0,DxLDy -1.0, XH 244.0,DxHDy 0.0, XM 244.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 520,392,392, 276,0,-1,0, 244,0,0,0, 244,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 0.0,T 0.0,W 0.0, DsDx 32.0,DtDx 0.0,DwDx 0.0, DsDe 0.0,DtDe 32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 0,0,0, 32,0,0, 0,0,0, 0,0,0, 0,32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf
  // Right Major Triangle (Dir=1)
  //
  //        . v[2]:XH,XM(X:276.0) YH(Y:98.0)
  //       /|
  // DxHDy/ |DxMDy
  //    ./__. v[0]:(X:244.0) YL(Y:130.0), v[1]:XL(X:212.0) YM(Y:130.0)
  //    DxLDy
  //
  // Output: Dir 1,Level 0,Tile 0, YL 130.0,YM 130.0,YH 98.0, XL 276.0,DxLDy 0.0, XH 276.0,DxHDy -1.0, XM 276.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 520,520,392, 276,0,0,0, 276,0,-1,0, 276,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 1024.0,T -24.0,W 0.0, DsDx 32.0,DtDx 0.0,DwDx 0.0, DsDe -32.0,DtDe 32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 1024,-24,0, 32,0,0, 0,0,0, 0,0,0, -32,32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf

  Sync_Tile // Sync Tile
  // Right Major Triangle (Dir=1)
  //
  //      DxMDy
  //      .___. v[2]:XH,XM(X:244.0) YH(Y:168.0), v[1]:XL(X:276.0) YM(Y:168.0)
  //      |  /
  // DxHDy| /DxLDy
  //      ./    v[0]:(X:244.0) YL(Y:200.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 200.0,YM 168.0,YH 168.0, XL 276.0,DxLDy -1.0, XH 244.0,DxHDy 0.0, XM 244.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 800,672,672, 276,0,-1,0, 244,0,0,0, 244,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 0.0,T 0.0,W 0.0, DsDx 0.0,DtDx 32.0,DwDx 0.0, DsDe 32.0,DtDe 0.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 0,0,0, 0,32,0, 0,0,0, 0,0,0, 32,0,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf
  // Right Major Triangle (Dir=1)
  //
  //        . v[2]:XH,XM(X:276.0) YH(Y:168.0)
  //       /|
  // DxHDy/ |DxMDy
  //    ./__. v[0]:(X:244.0) YL(Y:200.0), v[1]:XL(X:212.0) YM(Y:200.0)
  //    DxLDy
  //
  // Output: Dir 1,Level 0,Tile 0, YL 200.0,YM 200.0,YH 168.0, XL 276.0,DxLDy 0.0, XH 276.0,DxHDy -1.0, XM 276.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 800,800,672, 276,0,0,0, 276,0,-1,0, 276,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S -24.0,T 1024.0,W 0.0, DsDx 0.0,DtDx 32.0,DwDx 0.0, DsDe 32.0,DtDe -32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients -24,1024,0, 0,32,0, 0,0,0, 0,0,0, 32,-32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

Texture8x8:
  dw $FF0000FF,$00000000,$00000000,$000000FF,$000000FF,$00000000,$00000000,$00000000 // 8x8x32B = 256 Bytes
  dw $00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000
  dw $00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000
  dw $000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF
  dw $000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF
  dw $000000FF,$000000FF,$000000FF,$FFFFFFFF,$FFFFFFFF,$000000FF,$000000FF,$000000FF
  dw $00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000
  dw $00000000,$00000000,$000000FF,$000000FF,$000000FF,$000000FF,$00000000,$00000000

Texture16x16:
  dw $FF0000FF,$FF0000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000 // 16x16x32B = 1024 Bytes
  dw $FF0000FF,$FF0000FF,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000
  dw $00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000
  dw $000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF
  dw $000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF
  dw $000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000

Texture32x32:
  dw $FF0000FF,$FF0000FF,$FF0000FF,$FF0000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000 // 32x32x32B = 4096 Bytes
  dw $FF0000FF,$FF0000FF,$FF0000FF,$FF0000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $FF0000FF,$FF0000FF,$FF0000FF,$FF0000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $FF0000FF,$FF0000FF,$FF0000FF,$FF0000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000
  dw $00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000
  dw $000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF
  dw $000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF
  dw $000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
  dw $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$000000FF,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000