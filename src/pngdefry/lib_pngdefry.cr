@[Link(ldflags: "#{__DIR__}/../../ext/pngdefry.o")]

lib LibPngdefry
  $flag_Verbose : LibC::Int
  $flag_Process_Anyway : LibC::Int
  $flag_List_Chunks : LibC::Int
  $flag_Debug : LibC::Int
  $flag_UpdateAlpha : LibC::Int
  $flag_Ignore_CRC32 : LibC::Int
  $repack_IDAT_size : LibC::Int

  fun process(filename : LibC::Char*, write_file_name : LibC::Char*) : LibC::Int
end
