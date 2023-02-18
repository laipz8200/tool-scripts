#!/usr/bin/env ruby

def generate_getters_setters(file_path)
  file_contents = File.read(file_path)

  struct_regex = /type\s+(\w+)\s+struct\s+\{(.+?)\}/m
  field_regex = /^\s*(\w+)\s+([\*\w]+)\s*$/

  file_contents.scan(struct_regex) do |struct_match|
    struct_name = struct_match[0]
    field_declarations = struct_match[1]

    getters_setters = ""

    field_declarations.scan(field_regex) do |field_match|
      field_type = field_match[1]
      field_name = field_match[0]

      getter_name = "#{field_name}"
      getter_name[0] = getter_name[0].upcase
      setter_name = "Set#{field_name}"
      setter_name[3] = setter_name[3].upcase

      self_name = struct_name[0].downcase

      getters_setters += "\n"
      getters_setters += "func (#{self_name} #{struct_name}) #{getter_name}() #{field_type} {\n"
      getters_setters += "  return #{self_name}.#{field_name}\n"
      getters_setters += "}\n"
      getters_setters += "\n"
      getters_setters += "func (#{self_name} *#{struct_name}) #{setter_name}(#{field_name} #{field_type}) {\n"
      getters_setters += "  #{self_name}.#{field_name} = #{field_name}\n"
      getters_setters += "}\n"
      getters_setters += "\n"
    end


    File.open(file_path, "a") do |file|
      file.puts "// Getters and setters for #{struct_name}"
      file.puts getters_setters
    end
  end
end

filename = ARGV[0] # get the first argument from the shell

if filename.nil?
  puts "Please provide a filename as an argument."
  exit
end

if !File.exists?(filename)
  puts "The file '#{filename}' does not exist."
  exit
end

generate_getters_setters(filename)
