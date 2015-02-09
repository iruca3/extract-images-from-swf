#!/usr/bin/env ruby

#-------------------------------------------------------------------------------
# 設定
#-------------------------------------------------------------------------------

PATH_TO_FFDEC_JAR = 'ffdec_4.0.5/ffdec.jar'


#-------------------------------------------------------------------------------
# 本体
#-------------------------------------------------------------------------------

if ARGV.count <= 0
  puts 'Usage: ./extract.rb <file1.swf> <file2.swf> ...'
  exit(1)
end

require 'open3'

ARGV.each do |swf_file|
  filename = File::basename( swf_file, '.*' )
  puts 'Extracting ' + filename
  cmd = 'java -jar "' + PATH_TO_FFDEC_JAR + '" -format "shape:png,image:png" -export "shape,image" "' + filename + '" "' + swf_file + '"'
  out, err, status = Open3.capture3( cmd )

  if status.exitstatus != 0
    puts 'Error: ' + err
    next
  end

  # move extract_path/{images,shapes}/* to extract_path/
  i = 1
  Dir.glob( filename + '/{images,shapes}/*' ).each do |image_file|
    File.rename image_file, filename + '/' + ( '%03d' % i ) + '.png'
    i += 1
  end
  Dir::rmdir( filename + '/images' )
  Dir::rmdir( filename + '/shapes' )

  puts 'Success! ' + ( i - 1 ).to_s + ' images extracted.'
end

