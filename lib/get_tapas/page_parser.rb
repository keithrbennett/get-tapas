require 'nokogiri'

require_relative 'download_link'

module PageParser


  # Example Input: "https://rubytapas-media.s3.amazonaws.com/298-file-find.mp4?response-content-disposition=...
  # Example Return: '298-file-find.mp4'
  def self.ruby_tapas_url_to_filename(url)
    url.split('/').last
  end


  # @param html_string an HTML string from https://www.rubytapas.com/download-list/
  # @return an array of DownloadLink instances.
  def self.parse(html_string)
    html_doc = Nokogiri::HTML(html_string)
    html_links = html_doc.xpath("//li[contains(@class, 'su-post')]")
    download_links = html_links.map do |link|
      a_element = link.children.first
      url = a_element.attributes.first.last.value
      puts url
      description = a_element.children.first.text
      filename = ruby_tapas_url_to_filename(url)
      puts filename
      DownloadLink.new(url, filename, description)
    end

    if download_links.empty?
      raise "No screencast links found. Are you sure about the input HTML source?"
    end
    download_links
  end
end