task :default => [:clean]

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
      puts("#{branch} #{f} (#{'%.2f' % (File.size(f).to_f / 2**20)} MB) ...")
      i += 1
    end

    FileUtils.remove_dir(d) if File.exist?(d)
  end

  # Remove unnecessary files
  delete_ext = %w[.psd .pdn .xcf]
  Dir[File.join('cars', '**', '*')].reject { |p| File.directory? p }.each do |f|
    next unless delete_ext.include? File.extname(f)

    deleted_bytes += File.size(f).to_f
    puts("Removing #{f} (#{'%.2f' % (File.size(f).to_f / 2**20)} MB) ...")
    File.delete(f) if File.exist?(f)
  end

  if deleted_bytes == 0.0
    puts 'Nothing to remove.'
  else
    puts "Total removed: #{'%.2f' % (deleted_bytes / 2**20)} MB."
  end

  puts 'OK.'
end
