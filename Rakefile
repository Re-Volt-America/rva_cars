# frozen_string_literal: true

task default: %i[clean carboxes]

task :clean do
  deleted_bytes = 0.0.to_f

  # Remove unnecessary directories
  delete_dir = %w[extra paintkit]
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
  delete_file = %w[preview.jpg preview.png carbox512.bmp]
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

    params_path = if File.exist?("cars/#{f}/parameters.txt")
                    "cars/#{f}/parameters.txt"
                  else
                    puts "Skipped #{f}/... parameters.txt not found. It's probably a skin."
                    next
                  end

    carbox_path = ''
    known_carbox_files = %w[carbox256.bmp additional/carbox256.bmp carbox.bmp box.bmp]
    known_carbox_files.each do |kcf|
      (carbox_path = "cars/#{f}/#{kcf}") and break if File.exist?("cars/#{f}/#{kcf}")
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
