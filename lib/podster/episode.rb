require "nokogiri"
require "securerandom"
require "time"

class Episode < Struct.new(*%i{
  id
  title
  recording_date
  file_url
  description
  length_time
  length_bytes
})
  attr_accessor :podcast

  def initialize(*opts)
    super(*opts)
    
    if self[:id].nil?
      self[:id] = SecureRandom.hex(4)
    end

    # Make sure the recording date is, well, a date.
    unless self[:recording_date].is_a? Time
      self[:recording_date] = Time.parse(self[:recording_date])
    end
  end

  def self.from_hash(h, podcast:)
    ep = super(h)
    ep.podcast = podcast
    ep
  end

  def minutes
    time_bits = length_time.split(":")
    seconds = time_bits[-1].to_i
    minutes = time_bits[-2].to_i
    hours = time_bits[-3].to_i || 0

    minutes + (hours * 60)
  end

  def to_xml_node    
    doc = Nokogiri::XML <<-XML
<item>
  <guid>#{file_url}</guid>
  <title>#{title}</title>
  <pubDate>#{recording_date.rfc822}</pubDate>
  <link></link>
  <itunes:duration>#{length_time}</itunes:duration>
  <itunes:author>#{podcast.webmaster_name}</itunes:author>
  <itunes:explicit>#{podcast.explicit? ? "yes" : "no"}</itunes:explicit>
  <itunes:summary>#{description}</itunes:summary>
  <description>#{description}</description>
  <enclosure type="audio/mpeg" url="#{file_url}" length="#{length_bytes}"/>
  <itunes:image href="#{podcast.avatar_image_url}"/>
</item>
XML

    doc.at_css "item"
  end

end
