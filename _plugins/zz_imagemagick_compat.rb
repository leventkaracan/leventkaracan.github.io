require 'open3'

module JekyllImagemagick
  # Prefer ImageMagick 7's `magick` wrapper when available, but keep
  # compatibility with older setups that still expose `convert`.
  class ImageConvert
    class << self
      private

      def imagemagick_command
        return 'magick' if executable_on_path?('magick')

        'convert'
      end

      def executable_on_path?(name)
        ENV.fetch('PATH', '').split(File::PATH_SEPARATOR).any? do |path|
          full_path = File.join(path, name)
          File.file?(full_path) && File.executable?(full_path)
        end
      end
    end

    def self.run(input_file, output_file, flags, long_edge, resize_flags)
      Jekyll.logger.info(LOG_PREFIX, "Generating image \"#{output_file}\"")

      cmd = "#{imagemagick_command} \"#{input_file}\" #{flags} "
      if long_edge != 0
        cmd += "-resize \"#{long_edge}>\" #{resize_flags} "
      end
      cmd += "\"#{output_file}\""
      Jekyll.logger.debug(LOG_PREFIX, "Running command \"#{cmd}\"")
      run_cmd(cmd)
    end
  end
end
