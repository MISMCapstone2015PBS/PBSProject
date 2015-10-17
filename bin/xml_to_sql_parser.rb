#!/usr/bin/ruby

require 'optparse'
require 'rexml/document'
include REXML

def replace_brackets(s)
    s = s.gsub '[','('
    s = s.gsub ']',')'
    s
end

def process_file(input_file)
    output_file = nil
    table_name = nil
   
    doc = Document.new(File.new(input_file))

    doc.root.elements.each do |element|
        # Resolve table name
        if table_name == nil then
            table_name = element.name
            output_file = table_name + ".sql"
        elsif element.name != table_name then
            next
        end
        # Resolve keys & values
        keys_to_s = replace_brackets(element.attributes.keys.to_s)
        values = element.attributes.values.map! {|val| val.value}
        values_to_s = replace_brackets(values.to_s)
        statement = "INSERT INTO #{table_name} #{keys_to_s} VALUES #{values_to_s};"
        
        File.open(output_file, 'a') do |output_file|
            output_file.puts statement
        end
    end
end

if __FILE__ == $0
    options = {}
    optparse = OptionParser.new do |opts|
        opts.banner = "Usage: xml_to_sql_parser:"
        opts.on("-d", "--dir", "Directory path of xml files") do |dir|
            options[:dir] =  dir
        end
    
        opts.on("-f", "--file", "Single xml file path") do |file|
            options[:file] = file
        end

        opts.on("-h", "--help", "Usage message") do
            puts opts
            exit
        end
    end

    optparse.parse!

    input_file = options[:file]
    if input_file != nil then
        process_file(input_file)
    end

    dir = options[:dir]
    if dir != nil then
        Dir.glob("*.xml") do |filename|
            process_file(filename)
        end
    end
end
