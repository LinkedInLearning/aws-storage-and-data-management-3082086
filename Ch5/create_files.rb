#! /usr/bin/ruby

content = ""
10000.times{ content += "x" }

subdirectory = "./smallfiles/"
`mkdir -p #{subdirectory}`
100.times do 

  # random name generator
  filename = (0...8).map { (65 + rand(26)).chr }.join
  out_file = File.new( subdirectory + filename + ".txt", "w")
  out_file.print(content)
  out_file.close

end

out_file = File.new( "./bigfile.txt", "w")
1000.times do 
  out_file.print(content)
end
   
out_file.close
