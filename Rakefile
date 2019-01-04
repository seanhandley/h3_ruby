require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

desc "Build H3 C library"
task :build do
  unless File.exists?("ext/h3/src/Makefile")
    `git submodule update --init --recursive`
    print "Building h3..."
    `cd ext/h3; make > /dev/null 2>&1`
    puts " done."
  end
end

desc "Remove compiled H3 library"
task :clean do
  File.delete("ext/h3/src/Makefile") if File.exists?("ext/h3/src/Makefile")
  FileUtils.remove_dir("ext/h3/src/bin") if Dir.exists?("ext/h3/src/bin")
  FileUtils.remove_dir("ext/h3/src/generated") if Dir.exists?("ext/h3/src/generated")
  FileUtils.remove_dir("ext/h3/src/lib") if Dir.exists?("ext/h3/src/lib")
end

task spec: :build

desc "Recompile the H3 C library"
task rebuild: [:clean, :build]

task default: :spec
