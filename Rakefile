# frozen_string_literal: true

require 'zip'
require 'digest'
require_relative 'data'

task default: %i[clean package carboxes version]

task :clean do
  deleted_bytes = 0.0.to_f

  # Remove unnecessary directories
  delete_dir = %w[extra paintkit additional]
  Dir[File.join('cars', '**', '*')].select { |p| File.directory? p }.each do |d|
    next unless delete_dir.include? File.basename(d)

    puts "Removing #{d}/"
    subdirs = Dir[File.join(d, '**', '*')].reject { |p| File.directory? p }
    i = 0
    subdirs.each do |f|
      branch = if subdirs.size == i + 1
                 '  └──'
               else
                 '  ├──'
               end

      deleted_bytes += File.size(f).to_f
      puts("#{branch} #{f} (#{bytes_to_mb(File.size(f))} MB) ...")
      i += 1
    end

    FileUtils.remove_dir(d) if File.exist?(d)
  end

  # Remove unnecessary files
  delete_ext = %w[.psd .pdn .xcf .zip .rar .tar .7z]
  delete_file = %w[preview.jpg preview.png carbox256.bmp carbox512.bmp]
  Dir[File.join('cars', '**', '*')].reject { |p| File.directory? p }.each do |f|
    next unless delete_ext.include?(File.extname(f)) || delete_file.any? { |df| f.include? df }

    deleted_bytes += File.size(f).to_f
    puts("Removing #{f} (#{bytes_to_mb(File.size(f))} MB) ...")
    File.delete(f) if File.exist?(f)
  end

  if deleted_bytes == 0.0
    puts 'Nothing to remove.'
  else
    puts "Total removed: #{bytes_to_mb(deleted_bytes)} MB."
  end

  puts 'OK.'
end

task :package do
  zipfile_name = "#{RVACars::NAME}.zip"
  File.delete(zipfile_name) if File.exist?(zipfile_name)

  puts "Packaging into #{zipfile_name} ..."

  exclude = %w[. .. Gemfile Gemfile.lock Rakefile .git .gitignore .idea data.rb README.md packages.json]
  zf = ZipFileGenerator.new('.', zipfile_name, exclude)
  zf.write

  puts "Packaging complete! (#{bytes_to_mb(File.size(zipfile_name))} MB)."
  puts 'OK.'
end

task version: [:package] do
  checksum = nil
  checksum = Digest::SHA256.hexdigest File.read "#{RVACars::NAME}.zip" if File.exist?("#{RVACars::NAME}.zip")

  contents = [
    '{',
    "\t\"rva_cars\":",
    "\t{",
    "\t\t\"description\": \"#{RVACars::DESCRIPTION}\",",
    "\t\t\"version\": \"#{RVACars::VERSION}\",",
    "\t\t\"checksum\": \"#{checksum}\",",
    "\t\t\"url\": \"#{RVACars::URL}\"",
    "\t}",
    '}'
  ]

  File.open('packages.json', 'w+') do |f|
    contents.each { |l| f.puts(l) }
  end
end

task :carboxes do
  car_ratings = {
    0 => 'rookie',
    1 => 'amateur',
    2 => 'advanced',
    3 => 'semi-pro',
    4 => 'pro',
    5 => 'super-pro',
    6 => 'clockwork'
  }

  Dir.mkdir('carboxes') unless File.exist?('carboxes')
  (0..6).each do |i|
    Dir.mkdir("carboxes/#{car_ratings[i]}") unless File.exist?("carboxes/#{car_ratings[i]}")
  end

  Dir.entries('cars').each do |f|
    next if f.eql?('.') || f.eql?('..')

    params_path = "cars/#{f}/parameters.txt"
    carbox_path = if File.exist?("cars/#{f}/carbox.bmp")
                    "cars/#{f}/carbox.bmp"
                  else
                    "cars/#{f}/box.bmp"
                  end

    car_rating = nil
    car_slug = nil
    File.open(params_path) do |pf|
      pf.each_line do |l|
        car_slug = l.split.drop(1).join(' ').gsub('"', '').gsub(' ', '_').downcase if l.start_with? 'Name'

        next unless l.start_with? 'Rating'

        car_rating = if !car_slug.nil? && car_slug.start_with?('clockwork')
                       6
                     else
                       l.split[1].to_i
                     end
      end
    end

    FileUtils.cp(carbox_path, "carboxes/#{car_ratings[car_rating]}/#{car_slug}.bmp")
  end
end

def bytes_to_mb(bytes)
  format_number((bytes.to_f / 2**20).round(2))
end

def format_number(number)
  whole, decimal = number.to_s.split('.')
  num_groups = whole.chars.to_a.reverse.each_slice(3)
  whole_with_commas = num_groups.map(&:join).join(',').reverse
  [whole_with_commas, decimal].compact.join('.')
end

# This is a simple example which uses rubyzip to
# recursively generate a zip file from the contents of
# a specified directory. The directory itself is not
# included in the archive, rather just its contents.
#
# Usage:
#   directory_to_zip = "/tmp/input"
#   output_file = "/tmp/out.zip"
#   zf = ZipFileGenerator.new(directory_to_zip, output_file, exclude)
#   zf.write()
class ZipFileGenerator
  # Initialize with the directory to zip and the location of the output archive.
  def initialize(input_dir, output_file, exclude = [])
    @input_dir = input_dir
    @output_file = output_file
    @exclude = exclude
  end

  # Zip the input directory.
  def write
    packaged = Dir.entries(@input_dir).select { |p| File.extname(p) == '.zip' }
    entries = Dir.entries(@input_dir) - %w[. ..].concat(@exclude).concat(packaged)

    ::Zip::File.open(@output_file, ::Zip::File::CREATE) do |zipfile|
      write_entries entries, '', zipfile
    end
  end

  private

  # A helper method to make the recursion work.
  def write_entries(entries, path, zipfile)
    entries.each do |e|
      zipfile_path = path == '' ? e : File.join(path, e)
      disk_file_path = File.join(@input_dir, zipfile_path)
      puts zipfile_path
      if File.directory? disk_file_path
        recursively_deflate_directory(disk_file_path, zipfile, zipfile_path)
      else
        put_into_archive(disk_file_path, zipfile, zipfile_path)
      end
    end
  end

  def recursively_deflate_directory(disk_file_path, zipfile, zipfile_path)
    zipfile.mkdir zipfile_path
    subdir = Dir.entries(disk_file_path) - %w[. ..]
    write_entries subdir, zipfile_path, zipfile
  end

  def put_into_archive(disk_file_path, zipfile, zipfile_path)
    zipfile.add(zipfile_path, disk_file_path)
  end
end
