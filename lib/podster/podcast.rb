require "nokogiri"


module Podster
  class Podcast < Struct.new(*%i{
    title
    url
    language
    webmaster_name
    webmaster_email
    description
    explicit?
    avatar_image_url
    category
    episodes_hash
  })

    def initialize(*opts)
      super(*opts)
      episodes_hash = episodes_hash || []
    end

    # A list of episodes, returned in reverse chronological order
    # (the latest episode will be first)
    def episodes
      episodes_hash
        .map { |h| Episode.from_hash(h, podcast: self) }
        .sort_by { |ep| ep.recording_date }
        .reverse
    end

    def episode(id)
      episodes.find { |ep| ep.id == id }
    end

    def add_episode(e)
      episodes_hash << e.to_h
      e.podcast = self
      self
    end

    # Replaces an existing episode with the given one.
    # Episodes are checked on ID.
    def update_episode(e)
      delete_episode(e.id)
      add_episode(e)
    end

    def delete_episode(id)
      new_episodes_hash = episodes_hash.reject { |h| h[:id] == id }
      raise "Cannot find episode!" if new_episodes_hash.length == episodes_hash.length
      self[:episodes_hash] = new_episodes_hash
      self
    end

    def publish_date
      Time.now
    end

    def to_xml    
      doc = Nokogiri::XML <<-XML
  <rss xmlns:atom="http://www.w3.org/2005/Atom" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" version="2.0">
    <channel>
      <title>#{title}</title>
      <link>#{url}</link>
      <pubDate>#{publish_date.rfc822}</pubDate>
      <lastBuildDate>#{publish_date.rfc822}</lastBuildDate>
      <ttl>60</ttl>
      <language>#{language}</language>
      <copyright>All rights reserved</copyright>
      <webMaster>#{webmaster_email} (#{webmaster_name})</webMaster>
      <description>#{description}</description>
      <itunes:owner>
        <itunes:name>#{webmaster_name}</itunes:name>
        <itunes:email>#{webmaster_email}</itunes:email>
      </itunes:owner>
      <itunes:author>#{webmaster_name}</itunes:author>
      <itunes:explicit>#{explicit? ? "yes" : "no"}</itunes:explicit>
      <itunes:image href="#{avatar_image_url}"/>
      <image>
        <url>#{avatar_image_url}</url>
        <title>#{title}</title>
        <link>#{url}</link>
      </image>
      <itunes:category text="#{category}"/>
    </channel>
  </rss>
  XML

      episodes.each do |ep|
        doc.at_css("channel").add_child ep.to_xml_node
      end

      doc.to_xml
    end

  end
end
