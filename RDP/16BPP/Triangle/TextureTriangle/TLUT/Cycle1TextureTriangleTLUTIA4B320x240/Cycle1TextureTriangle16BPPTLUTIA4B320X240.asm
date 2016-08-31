// N64 'Bare Metal' 16BPP 320x240 Cycle1 Texture Triangle TLUT IA4B RDP Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "Cycle1TextureTriangle16BPPTLUTIA4B320X240.N64", create
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

  Set_Other_Modes EN_TLUT|TLUT_TYPE|SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER|B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN // Set Other Modes
  Set_Combine_Mode $0,$00, 0,0, $1,$01, $0,$F, 1,0, 0,0,0, 7,7,7 // Set Combine Mode: SubA RGB0,MulRGB0, SubA Alpha0,MulAlpha0, SubA RGB1,MulRGB1, SubB RGB0,SubB RGB1, SubA Alpha1,MulAlpha1, AddRGB0,SubB Alpha0,AddAlpha0, AddRGB1,SubB Alpha1,AddAlpha1

  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1-1, Tlut // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 1-1, Tlut DRAM ADDRESS
  Set_Tile 0,0,0, $100, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: TMEM Address $100, Tile 0
  Load_Tlut 0<<2,0<<2, 0, 47<<2,0<<2 // Load Tlut: SL 0.0,TL 0.0, Tile 0, SH 47.0,TH 0.0


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4-1, Texture16x16 // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 4, Texture16x16 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 15<<2,15<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 15.0,TH 15.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,1, $000, 0,PALETTE_0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0,Palette 0
  // Right Major Triangle (Dir=1)
  //
  //      DxMDy
  //      .___. v[2]:XH,XM(X:52.0) YH(Y:44.0), v[1]:XL(X:84.0) YM(Y:44.0)
  //      |  /
  // DxHDy| /DxLDy
  //      ./    v[0]:(X:52.0) YL(Y:76.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 76.0,YM 44.0,YH 44.0, XL 84.0,DxLDy -1.0, XH 52.0,DxHDy 0.0, XM 52.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 304,176,176, 84,0,-1,0, 52,0,0,0, 52,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 0.0,T 0.0,W 0.0, DsDx 16.0,DtDx 0.0,DwDx 0.0, DsDe 0.0,DtDe 16.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 0,0,0, 16,0,0, 0,0,0, 0,0,0, 0,16,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf
  // Right Major Triangle (Dir=1)
  //
  //        . v[2]:XH,XM(X:84.0) YH(Y:44.0)
  //       /|
  // DxHDy/ |DxMDy
  //    ./__. v[0]:(X:52.0) YL(Y:76.0), v[1]:XL(X:84.0) YM(Y:76.0)
  //    DxLDy
  //
  // Output: Dir 1,Level 0,Tile 0, YL 76.0,YM 76.0,YH 44.0, XL 84.0,DxLDy 0.0, XH 84.0,DxHDy -1.0, XM 84.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 304,304,176, 84,0,0,0, 84,0,-1,0, 84,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 512.0,T -12.0,W 0.0, DsDx 16.0,DtDx 0.0,DwDx 0.0, DsDe -16.0,DtDe 16.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 512,-12,0, 16,0,0, 0,0,0, 0,0,0, -16,16,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf

  Sync_Tile // Sync Tile
  // Right Major Triangle (Dir=1)
  //
  //      DxMDy
  //      .___. v[2]:XH,XM(X:68.0) YH(Y:114.0), v[1]:XL(X:84.0) YM(Y:114.0)
  //      |  /
  // DxHDy| /DxLDy
  //      ./    v[0]:(X:68.0) YL(Y:130.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 130.0,YM 114.0,YH 114.0, XL 84.0,DxLDy -1.0, XH 68.0,DxHDy 0.0, XM 68.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 520,456,456, 84,0,-1,0, 68,0,0,0, 68,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 0.0,T 0.0,W 0.0, DsDx 32.0,DtDx 0.0,DwDx 0.0, DsDe 0.0,DtDe 32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 0,0,0, 32,0,0, 0,0,0, 0,0,0, 0,32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf
  // Right Major Triangle (Dir=1)
  //
  //        . v[2]:XH,XM(X:84.0) YH(Y:114.0)
  //       /|
  // DxHDy/ |DxMDy
  //    ./__. v[0]:(X:68.0) YL(Y:130.0), v[1]:XL(X:84.0) YM(Y:130.0)
  //    DxLDy
  //
  // Output: Dir 1,Level 0,Tile 0, YL 130.0,YM 130.0,YH 114.0, XL 84.0,DxLDy 0.0, XH 84.0,DxHDy -1.0, XM 84.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 520,520,456, 84,0,0,0, 84,0,-1,0, 84,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 512.0,T -24.0,W 0.0, DsDx 32.0,DtDx 0.0,DwDx 0.0, DsDe -32.0,DtDe 32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 512,-24,0, 32,0,0, 0,0,0, 0,0,0, -32,32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf

  Sync_Tile // Sync Tile
  // Right Major Triangle (Dir=1)
  //
  //      DxMDy
  //      .___. v[2]:XH,XM(X:68.0) YH(Y:184.0), v[1]:XL(X:84.0) YM(Y:184.0)
  //      |  /
  // DxHDy| /DxLDy
  //      ./    v[0]:(X:68.0) YL(Y:200.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 200.0,YM 184.0,YH 184.0, XL 84.0,DxLDy -1.0, XH 68.0,DxHDy 0.0, XM 68.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 800,736,736, 84,0,-1,0, 68,0,0,0, 68,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 0.0,T 0.0,W 0.0, DsDx 0.0,DtDx 32.0,DwDx 0.0, DsDe 32.0,DtDe 0.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 0,0,0, 0,32,0, 0,0,0, 0,0,0, 32,0,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf
  // Right Major Triangle (Dir=1)
  //
  //        . v[2]:XH,XM(X:84.0) YH(Y:184.0)
  //       /|
  // DxHDy/ |DxMDy
  //    ./__. v[0]:(X:68.0) YL(Y:200.0), v[1]:XL(X:84.0) YM(Y:200.0)
  //    DxLDy
  //
  // Output: Dir 1,Level 0,Tile 0, YL 200.0,YM 200.0,YH 184.0, XL 84.0,DxLDy 0.0, XH 84.0,DxHDy -1.0, XM 84.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 800,800,736, 84,0,0,0, 84,0,-1,0, 84,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S -24.0,T 512.0,W 0.0, DsDx 0.0,DtDx 32.0,DwDx 0.0, DsDe 32.0,DtDe -32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients -24,512,0, 0,32,0, 0,0,0, 0,0,0, 32,-32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,8-1, Texture32x32 // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 8, Texture32x32 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,2, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 2 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 31<<2,31<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 31.0,TH 31.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,2, $000, 0,PALETTE_1, 0,MIRROR_T,MASK_T_4,0, 0,MIRROR_S,MASK_S_4,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 2 (64bit Words), TMEM Address $000, Tile 0,Palette 1, MIRROR T,MASK T 4, MIRROR S,MASK S 4
  // Right Major Triangle (Dir=1)
  //
  //      DxMDy
  //      .___. v[2]:XH,XM(X:112.0) YH(Y:28.0), v[1]:XL(X:176.0) YM(Y:28.0)
  //      |  /
  // DxHDy| /DxLDy
  //      ./    v[0]:(X:112.0) YL(Y:92.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 92.0,YM 28.0,YH 28.0, XL 176.0,DxLDy -1.0, XH 112.0,DxHDy 0.0, XM 112.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 368,112,112, 176,0,-1,0, 112,0,0,0, 112,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 0.0,T 0.0,W 0.0, DsDx 32.0,DtDx 0.0,DwDx 0.0, DsDe 0.0,DtDe 32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 0,0,0, 32,0,0, 0,0,0, 0,0,0, 0,32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf
  // Right Major Triangle (Dir=1)
  //
  //        . v[2]:XH,XM(X:176.0) YH(Y:28.0)
  //       /|
  // DxHDy/ |DxMDy
  //    ./__. v[0]:(X:112.0) YL(Y:92.0), v[1]:XL(X:176.0) YM(Y:92.0)
  //    DxLDy
  //
  // Output: Dir 1,Level 0,Tile 0, YL 92.0,YM 92.0,YH 28.0, XL 176.0,DxLDy 0.0, XH 176.0,DxHDy -1.0, XM 176.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 368,368,112, 176,0,0,0, 176,0,-1,0, 176,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 1024.0,T -24.0,W 0.0, DsDx 32.0,DtDx 0.0,DwDx 0.0, DsDe -32.0,DtDe 32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 1024,-24,0, 32,0,0, 0,0,0, 0,0,0, -32,32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf

  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,2, $000, 0,PALETTE_1, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 2 (64bit Words), TMEM Address $000, Tile 0,Palette 1
  // Right Major Triangle (Dir=1)
  //
  //      DxMDy
  //      .___. v[2]:XH,XM(X:144.0) YH(Y:98.0), v[1]:XL(X:176.0) YM(Y:98.0)
  //      |  /
  // DxHDy| /DxLDy
  //      ./    v[0]:(X:144.0) YL(Y:130.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 130.0,YM 98.0,YH 98.0, XL 176.0,DxLDy -1.0, XH 144.0,DxHDy 0.0, XM 144.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 520,392,392, 176,0,-1,0, 144,0,0,0, 144,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 0.0,T 0.0,W 0.0, DsDx 32.0,DtDx 0.0,DwDx 0.0, DsDe 0.0,DtDe 32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 0,0,0, 32,0,0, 0,0,0, 0,0,0, 0,32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf
  // Right Major Triangle (Dir=1)
  //
  //        . v[2]:XH,XM(X:176.0) YH(Y:98.0)
  //       /|
  // DxHDy/ |DxMDy
  //    ./__. v[0]:(X:144.0) YL(Y:130.0), v[1]:XL(X:176.0) YM(Y:130.0)
  //    DxLDy
  //
  // Output: Dir 1,Level 0,Tile 0, YL 130.0,YM 130.0,YH 98.0, XL 176.0,DxLDy 0.0, XH 176.0,DxHDy -1.0, XM 176.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 520,520,392, 176,0,0,0, 176,0,-1,0, 176,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 1024.0,T -24.0,W 0.0, DsDx 32.0,DtDx 0.0,DwDx 0.0, DsDe -32.0,DtDe 32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 1024,-24,0, 32,0,0, 0,0,0, 0,0,0, -32,32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf

  Sync_Tile // Sync Tile
  // Right Major Triangle (Dir=1)
  //
  //      DxMDy
  //      .___. v[2]:XH,XM(X:144.0) YH(Y:168.0), v[1]:XL(X:176.0) YM(Y:168.0)
  //      |  /
  // DxHDy| /DxLDy
  //      ./    v[0]:(X:144.0) YL(Y:200.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 200.0,YM 168.0,YH 168.0, XL 176.0,DxLDy -1.0, XH 144.0,DxHDy 0.0, XM 144.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 800,672,672, 176,0,-1,0, 144,0,0,0, 144,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 0.0,T 0.0,W 0.0, DsDx 0.0,DtDx 32.0,DwDx 0.0, DsDe 32.0,DtDe 0.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 0,0,0, 0,32,0, 0,0,0, 0,0,0, 32,0,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf
  // Right Major Triangle (Dir=1)
  //
  //        . v[2]:XH,XM(X:176.0) YH(Y:168.0)
  //       /|
  // DxHDy/ |DxMDy
  //    ./__. v[0]:(X:144.0) YL(Y:200.0), v[1]:XL(X:176.0) YM(Y:200.0)
  //    DxLDy
  //
  // Output: Dir 1,Level 0,Tile 0, YL 200.0,YM 200.0,YH 168.0, XL 176.0,DxLDy 0.0, XH 176.0,DxHDy -1.0, XM 176.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 800,800,672, 176,0,0,0, 176,0,-1,0, 176,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S -24.0,T 1024.0,W 0.0, DsDx 0.0,DtDx 32.0,DwDx 0.0, DsDe 32.0,DtDe -32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients -24,1024,0, 0,32,0, 0,0,0, 0,0,0, 32,-32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,16-1, Texture64x64 // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 16, Texture64x64 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 4 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 63<<2,63<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 63.0,TH 63.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,4, $000, 0,PALETTE_2, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 4 (64bit Words), TMEM Address $000, Tile 0,Palette 2
  // Right Major Triangle (Dir=1)
  //
  //      DxMDy
  //      .___. v[2]:XH,XM(X:228.0) YH(Y:66.0), v[1]:XL(X:292.0) YM(Y:66.0)
  //      |  /
  // DxHDy| /DxLDy
  //      ./    v[0]:(X:228.0) YL(Y:130.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 130.0,YM 66.0,YH 66.0, XL 292.0,DxLDy -1.0, XH 228.0,DxHDy 0.0, XM 228.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 520,264,264, 292,0,-1,0, 228,0,0,0, 228,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 0.0,T 0.0,W 0.0, DsDx 32.0,DtDx 0.0,DwDx 0.0, DsDe 0.0,DtDe 32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 0,0,0, 32,0,0, 0,0,0, 0,0,0, 0,32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf
  // Right Major Triangle (Dir=1)
  //
  //        . v[2]:XH,XM(X:292.0) YH(Y:66.0)
  //       /|
  // DxHDy/ |DxMDy
  //    ./__. v[0]:(X:228.0) YL(Y:130.0), v[1]:XL(X:292.0) YM(Y:130.0)
  //    DxLDy
  //
  // Output: Dir 1,Level 0,Tile 0, YL 130.0,YM 130.0,YH 66.0, XL 292.0,DxLDy 0.0, XH 292.0,DxHDy -1.0, XM 292.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 520,520,264, 292,0,0,0, 292,0,-1,0, 292,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 2048.0,T -24.0,W 0.0, DsDx 32.0,DtDx 0.0,DwDx 0.0, DsDe -32.0,DtDe 32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 2048,-24,0, 32,0,0, 0,0,0, 0,0,0, -32,32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf

  Sync_Tile // Sync Tile
  // Right Major Triangle (Dir=1)
  //
  //      DxMDy
  //      .___. v[2]:XH,XM(X:228.0) YH(Y:136.0), v[1]:XL(X:292.0) YM(Y:136.0)
  //      |  /
  // DxHDy| /DxLDy
  //      ./    v[0]:(X:228.0) YL(Y:200.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 200.0,YM 136.0,YH 136.0, XL 292.0,DxLDy -1.0, XH 228.0,DxHDy 0.0, XM 228.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 800,544,544, 292,0,-1,0, 228,0,0,0, 228,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S 0.0,T 0.0,W 0.0, DsDx 0.0,DtDx 32.0,DwDx 0.0, DsDe 32.0,DtDe 0.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients 0,0,0, 0,32,0, 0,0,0, 0,0,0, 32,0,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf
  // Right Major Triangle (Dir=1)
  //
  //        . v[2]:XH,XM(X:292.0) YH(Y:136.0)
  //       /|
  // DxHDy/ |DxMDy
  //    ./__. v[0]:(X:228.0) YL(Y:200.0), v[1]:XL(X:292.0) YM(Y:200.0)
  //    DxLDy
  //
  // Output: Dir 1,Level 0,Tile 0, YL 200.0,YM 200.0,YH 136.0, XL 292.0,DxLDy 0.0, XH 292.0,DxHDy -1.0, XM 292.0,DxMDy 0.0
     Texture_Triangle 1,0,0, 800,800,544, 292,0,0,0, 292,0,-1,0, 292,0,0,0 // Generated By N64RightMajorTriangleCalc.py
  // Output: S -24.0,T 2048.0,W 0.0, DsDx 0.0,DtDx 32.0,DwDx 0.0, DsDe 32.0,DtDe -32.0,DwDe 0.0, DsDy 0.0,DtDy 0.0,DwDy 0.0
     Texture_Coefficients -24,2048,0, 0,32,0, 0,0,0, 0,0,0, 32,-32,0, 0,0,0, 0,0,0, 0,0,0 // S,T,W, DsDx,DtDx,DwDx, Sf,Tf,Wf, DsDxf,DtDxf,DwDxf, DsDe,DtDe,DwDe, DsDy,DtDy,DwDy, DsDef,DtDef,DwDef, DsDyf,DtDyf,DwDyf

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

Texture16x16:
  db $33,$00,$00,$02,$20,$00,$00,$00 // 16x16x4B = 128 Bytes
  db $33,$00,$00,$21,$12,$00,$00,$00
  db $00,$00,$02,$11,$11,$20,$00,$00
  db $00,$00,$21,$11,$11,$12,$00,$00
  db $00,$02,$11,$11,$11,$11,$20,$00
  db $00,$21,$11,$11,$11,$11,$12,$00
  db $02,$11,$11,$11,$11,$11,$11,$20
  db $21,$11,$11,$11,$11,$11,$11,$12
  db $21,$11,$11,$11,$11,$11,$11,$12
  db $22,$22,$22,$11,$11,$22,$22,$22
  db $00,$00,$02,$11,$11,$20,$00,$00
  db $00,$00,$02,$11,$11,$20,$00,$00
  db $00,$00,$02,$11,$11,$20,$00,$00
  db $00,$00,$02,$11,$11,$20,$00,$00
  db $00,$00,$02,$11,$11,$20,$00,$00
  db $00,$00,$02,$22,$22,$20,$00,$00

Texture32x32:
  db $33,$33,$00,$00,$00,$00,$00,$02,$20,$00,$00,$00,$00,$00,$00,$00 // 32x32x4B = 512 Bytes
  db $33,$33,$00,$00,$00,$00,$00,$21,$12,$00,$00,$00,$00,$00,$00,$00
  db $33,$33,$00,$00,$00,$00,$02,$11,$11,$20,$00,$00,$00,$00,$00,$00
  db $33,$33,$00,$00,$00,$00,$21,$11,$11,$12,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$21,$11,$11,$11,$11,$12,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00
  db $00,$00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00,$00
  db $00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00
  db $00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00
  db $00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00
  db $00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00
  db $00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00
  db $00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00
  db $02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20
  db $21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12
  db $21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12
  db $22,$22,$22,$22,$22,$22,$11,$11,$11,$11,$22,$22,$22,$22,$22,$22
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$22,$22,$22,$22,$20,$00,$00,$00,$00,$00

Texture64x64:
  db $33,$33,$33,$33,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // 64x64x4B = 2048 Bytes
  db $33,$33,$33,$33,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$21,$12,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
  db $33,$33,$33,$33,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
  db $33,$33,$33,$33,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$21,$11,$11,$12,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
  db $33,$33,$33,$33,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $33,$33,$33,$33,$00,$00,$00,$00,$00,$00,$00,$00,$00,$21,$11,$11,$11,$11,$12,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $33,$33,$33,$33,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $33,$33,$33,$33,$00,$00,$00,$00,$00,$00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00
  db $00,$00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00,$00
  db $00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00
  db $00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00
  db $00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00
  db $00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00
  db $00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00
  db $00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00
  db $02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20
  db $21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12
  db $21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12
  db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$11,$11,$11,$11,$11,$11,$11,$11,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$22,$22,$22,$22,$22,$22,$22,$22,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

Tlut:
  dh $0000,$FFFF,$00FF,$80FF,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // 4B Palette 0 (4x16B = 8 Bytes)
  dh $0000,$F0FF,$00FF,$80FF,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // 4B Palette 1
  dh $0000,$A0FF,$00FF,$80FF,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // 4B Palette 2