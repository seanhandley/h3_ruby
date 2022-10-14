require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

desc "Build H3 C library"
task :build do
  unless File.exist?("ext/h3/src/build/Makefile")
    `git submodule update --init --recursive`
    print "Building h3..."
    `cd ext/h3; make > /dev/null 2>&1`
    puts " done."
  end
end

desc "Remove compiled H3 library"
task :clean do
  FileUtils.remove_dir("ext/h3/src/build") if Dir.exist?("ext/h3/src/build")
end

task spec: :build

desc "Recompile the H3 C library"
task rebuild: %i[clean build]

task default: :spec
