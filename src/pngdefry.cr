require "./pngdefry/*"
require "file_utils"

# Pngdefry is a wrapper for pngdefry that reverses the optimization Xcode does on png image included
# into ipa files to make the images readable by the browser.
#
#
# ### Quick start
#
# ```
# Pngdefry.decode("input.png", "output.png")
# ```
module Pngdefry
  extend self

  # Reverse optimization png image and store it to output path.
  #
  # ### Paramters
  #
  # - `input`: optimized png file.
  # - `output`: reversed png file.
  # - `overwrite`: overwrite output file if it was exists.
  # - `update_alpha`: do de-multiply alpha
  # - `chunk_size`: max IDAT chunk size in bytes, minimum: 1024; default: 524288 (512K)
  # - `ignore_crc32`: ignore bad CRC32 (recommended: do **NOT** use this, as a bad CRC32 may indicate a deliberately damaged file)
  # - `list_all_chunks`: list all chunks
  # - `force_process`: process all files, not just iphone ones (for debugging purposed only)
  # - `debug`: very verbose processing (for debugging purposes only)
  # - `verbose`: verbose processing
  def decode(input : String, output : String, overwrite = false,
             update_alpha = true, chunk_size = LibPngdefry.repack_IDAT_size,
             ignore_crc32 = false, list_all_chunks = false, force_process = false,
             debug = false, verbose = false) : Bool
    LibPngdefry.flag_UpdateAlpha = bool_as_int(update_alpha)
    LibPngdefry.repack_IDAT_size = chunk_size
    LibPngdefry.flag_Process_Anyway = bool_as_int(force_process)
    LibPngdefry.flag_Ignore_CRC32 = bool_as_int(ignore_crc32)
    LibPngdefry.flag_List_Chunks = bool_as_int(list_all_chunks)
    LibPngdefry.flag_Debug = bool_as_int(debug)
    LibPngdefry.flag_Verbose = bool_as_int(verbose)

    raise_error!("Input file not exists: #{input}") unless File.exists?(input)
    raise_error!("Input file unreadable: #{input}") unless File.readable?(input)
    raise_error!("Output file was existed: #{output}. You can pass overwirte: true to overwrite") if File.exists?(output) && !overwrite

    # Ensure the output directory exists
    FileUtils.mkdir_p(File.dirname(output))

    result = LibPngdefry.process(input, output)
    handle_result(result)
    result == 1
  end

  private def handle_result(result)
    case result
    when 0, 1 then return
    when -100 then raise_error!("Input file not exists or unreadable")
    when -101 then raise_error!("Not a PNG file")
    when -102 then raise_error!("Not an iphone crushed PNG file")
    when -103 then raise_error!("Missing IEND chunk")
    when -104 then raise_error!("CRC32 check invalid!")
    when -105 then raise_error!("No IHDR chunk found")
    when -106 then raise_error!("IHDR chunk length incorrect")
    when -107 then raise_error!("Image dimensions invalid")
    when -108 then raise_error!("Unknown compression type")
    when -109 then raise_error!("Unknown filter type")
    when -110 then raise_error!("Unknown interlace type")
    when -111 then raise_error!("Unknown color type")
    when -112 then raise_error!("Invalid bit depth")
    when -113 then raise_error!("No IDAT chunks found")
    when -114 then raise_error!("IDAT chunks are not consecutive")
    when -115 then raise_error!("All IDAT chunks are empty")
    when -116, -202 then raise_error!("Out of memory")
    when -117 then raise_error!("Unspecified decompression error")
    when -118 then raise_error!("Decompression error")
    when -119 then raise_error!("Unknown row filter type")
    when -120 then raise_error!("Unspecified compression error")
    when -121 then raise_error!("Failed to create output file")
    when -201 then raise_error!("Invalid chunk size")
    when -203 then raise_error!("Premature end of file")
    when -204 then raise_error!("Invalid CRC")
    else           raise_error!("Catched unkown error code: #{result}")
    end
  end

  private def bool_as_int(value : Bool)
    value ? 1 : 0
  end

  private def raise_error!(message : String)
    raise Error.new(message)
  end

  # :nodoc:
  class Error < Exception; end
end
