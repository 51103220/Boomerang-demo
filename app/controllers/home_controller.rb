class HomeController < ApplicationController
  def index
    @_8051_files = Array.new
    Dir['boomerang-exe/test/_8051/*'].each do |item|
      f = File.read(item)
      @_8051_files.push(f)
    end
    @sparc_files = Array.new
    Dir['boomerang-exe/test/sparc_assembly/*'].each do |item|
      f = File.read(item)
      @sparc_files.push(f)
    end
  	render :index
  end

  def decompile
    string  = String.new params[:code].to_s
    content = string.gsub(/<br>/,"\n")
    require 'sanitize'
    content = Sanitize.clean(content)
    
    cmd = "sudo ./boomerang -h"
    if params[:machine] == "sparc"
    	cmd = "sudo ./boomerang -o output/result -as test/demo-input"
    elsif params[:machine] == "_8051"
      if content[content.length - 1] != "\n"
        content = content + "\n"
      end
     	cmd = "sudo ./boomerang -o output/result -as8 test/demo-input"
    else
      `sudo rm -rf boomerang-exe/output/result/binary/*`
      path = params[:temp_value].gsub(/boomerang-exe\//,"") 
      if params[:abi] == "yes"
        cmd = "sudo ./boomerang -o output/result/binary -ab #{path}"
      else
        cmd = "sudo ./boomerang -o output/result/binary #{path}"
      end
    end

    File.open("boomerang-exe/test/demo-input", 'w') { |file| file.write(content)}
    Dir.chdir("boomerang-exe") do
    	`#{cmd}`
    end

    @result = "\n"
    if params[:machine] != "binary"
      Dir['boomerang-exe/output/result/testfolder/*'].each do |item|
        @result << File.read(item)
      end
    else
      Dir['boomerang-exe/output/result/binary/*'].each do |item|
        if File.directory?(item)
          Dir["#{item}/*"].each do |i|
            @result << File.read(i)
          end
        end
      end
    end
      
    end
    respond_to do |format|
        format.js
    end

  def load_inputs
    @inputs = []
    dir = ''
   
    if params[:value] == "SPARC"
      dir = 'boomerang-exe/test/sparc/*'
    elsif params[:value] == "PENTIUM"
      dir = 'boomerang-exe/test/pentium/*'
    elsif params[:value] == "PPC"
      dir = 'boomerang-exe/test/ppc/*'
    elsif params[:value] == "TESTCASE"
      dir = 'boomerang-exe/test/testcases/**/*'  
    end
    require 'find'

    Dir[dir].each do |item|
      h =  Hash["path" => item, "name" => File.basename(item)]
      @inputs << h
    end
    

    require 'json'
    respond_to do |format|
          format.json { 
              render json: @inputs.to_json
          }
    end
  end

  def toolkit
    render:toolkit
  end

  def toolkit_demo
    machine = 'unknown'
    if params[:available_machine] == "SPARC"
      machine = 'sparc'
    elsif params[:available_machine] == "8051"
      machine = '_8051'
    end
    @spec = File.read("boomerang-toolkit/input/#{machine}/core.spec")
    @skeleton = File.read("boomerang-toolkit/input/#{machine}/#{machine}decoder.m")
    cmd = "sudo ruby main.rb ./input/#{machine}"
    Dir.chdir("boomerang-toolkit") do
      `#{cmd}`
    end
    @decoder =  File.read("boomerang-toolkit/output/#{machine}/decoder.cpp")
    respond_to do |format|
        format.js
    end
  end 
end
