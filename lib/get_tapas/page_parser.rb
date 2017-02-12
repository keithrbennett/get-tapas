require 'nokogiri'

require_relative 'download_link'

module PageParser


  # Example Input: "https://rubytapas-media.s3.amazonaws.com/298-file-find.mp4?response-content-disposition=...
  # Example Return: '298-file-find.mp4'
  RUBY_TAPAS_URL_TO_FILENAME = ->(url) { url.split('?').first.split('/').last }


  # @param html_string an HTML string from https://www.rubytapas.com/download-list/
  # @return an array of DownloadLink instances.
  def self.parse(html_string, fn_url_to_filename = RUBY_TAPAS_URL_TO_FILENAME)
    html_doc = Nokogiri::HTML(html_string)
    html_links = html_doc.xpath("//*[contains(@class, 'video-download-link')]")

    html_links.map do |link|
      url         = link.children.first.attributes['href'].value
      description = link.children.first.text.strip
      filename    = fn_url_to_filename.(url)
      DownloadLink.new(url, filename, description)
    end
  end
end