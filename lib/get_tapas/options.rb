class Options < Struct.new( \
    :data_dir,
    :input_spec,
    :min_episode_num,
    :max_episode_num,
    :no_op,
    :reverse,
    :sleep_interval
)

  DEFAULT_TAPAS_DIR = '~/ruby-tapas'

  def initialize
    super
    self.data_dir ||= DEFAULT_TAPAS_DIR
  end

  # Convert '~' to $HOME if necessary.
  def data_dir=(dir)
    if dir.is_a?(String) && dir[0,2] == '~/'
      dir = File.join(ENV['HOME'], dir[2..-1])
    end
    super(dir)
  end
end