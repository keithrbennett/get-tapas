class DownloadLink < Struct.new(
    :url,
    :filename,
    :description,
    :filespec,
    :episode_num)

  def to_s
    to_h.to_s
 end
end

