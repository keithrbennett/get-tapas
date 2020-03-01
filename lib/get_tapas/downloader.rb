require 'shellwords'

class Downloader

  attr_accessor :html, :options

  def initialize(html, options)
    @html = html
    @options = options
  end


  def episode_num_ok(episode_num)
    min = options.min_episode_num
    max = options.max_episode_num

    return false if min && episode_num < min
    return false if max && episode_num > max
    true
  end


  def ensure_output_dir_exists(dir)
    return if Dir.exist?(dir)
    begin
      FileUtils.mkdir_p(dir)
      puts "Created output data directory #{dir}."
    rescue Errno::EACCES
      puts "Unable to create directory #{dir}. Exiting..."
      exit(-1)
    end
  end


  def filespecs_available(data_dir, links)
    filenames = links.map { |link| link.filename}
    filenames.map { |fn| File.join(data_dir, fn) }
  end


  def filespecs_present(data_dir)
    Dir["#{data_dir}/*"]
  end


  def filespecs_needing_download(available, present)
    available - present
  end


  def download_file_info(links)
    present, absent = links.partition do |link|
      File.file?(link.filespec)
    end
    [links, present, absent]
  end


  def get_link_info(html, dir)
    links = PageParser.parse(html)
    links.each do |link|
      basename = link.url.split('/').last
      link.filespec = File.join(dir, basename + '.mp4')
      link.episode_num = link.filename.split('-').first.to_i
    end
  end


  def validate_downloaded_file(filespec)
    if File.size(filespec) < 20000
      text = File.read(filespec)
      if %r{<Error>}.match(text) && %r{</Error>}.match(text)
        puts "\nDownload error, text was:\n#{text}\n\n\n"
        raise "Download error"
      end
    end
  end


  def download_file(link, data_dir)
    puts "Downloading #{link.filespec}..."
    tempfilespec = File.join(data_dir, 'tempfile')
    command = "curl -o #{tempfilespec} #{Shellwords.shellescape(link.url)}"
    puts command
    `#{command}`
    if $?.exitstatus == 0
      validate_downloaded_file(tempfilespec)
      FileUtils.mv(tempfilespec, link.filespec)
      puts "Finished downloading #{link.filename}\n\n"
    else
      raise "Curl Download failed with exit status #{$0.exitstatus}."
    end
  end


  def call
    data_dir = options.data_dir

    ensure_output_dir_exists(data_dir)
    links = get_link_info(html, data_dir)
    _available, _present, absent = download_file_info(links)

    absent.reverse! if options.reverse

    absent_within_desired_range = absent.select { |a| episode_num_ok(a.episode_num)}

    num_downloads_to_do = absent_within_desired_range.size

    if num_downloads_to_do == 0
      puts "No files within the selection criteria needed to be downloaded."
    elsif options.no_op
      puts "No-op mode requested. The following #{num_downloads_to_do} file(s) would have been downloaded without it:\n\n"
      puts absent_within_desired_range.map(&:filename).join("\n"); puts
      exit(0)
    else
      absent_within_desired_range.each_with_index do |link, index|
        download_file(link, data_dir)
        this_was_the_last_one = (index == num_downloads_to_do - 1)
        if options.sleep_interval && (! this_was_the_last_one)
          puts "Sleeping #{options.sleep_interval} seconds..."
          sleep(options.sleep_interval)
        end
      end
    end
  end
end