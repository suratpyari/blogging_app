require 'hpricot'
require 'open-uri'
require 'builder'

namespace :plugin do
  desc 'Generates sitemap.xml file in public directory'

  task :generate_sitemap do
    
    # set domain to crawl
    DOMAIN = 'localhost:3000'
    BASE_URL = 'http://' + DOMAIN

    # holds pages to go into map, and pages crawled
    @pages = []
    @pages_crawled = []

    # start with home page
    crawl_for_links('/')

    # crawl each page in pages array unless it's already been crawled
    @pages.each {|page|
      crawl_for_links(page) unless @pages_crawled.include?(page)
    }

    # create xml for sitemap
    xml = Builder::XmlMarkup.new( :indent => 2 )  
    xml.instruct!
    xml.comment! "Generated on: " + Time.now.to_s
    xml.urlset("xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9") {
      # loop through array of pages, and build sitemap.xml
      @pages.sort.each {|link|
        xml.url {
          xml.loc BASE_URL + link
          # TODO - set changefreq
          xml.changefreq 'daily'
        }
      }
    }

    # convert builder xml to xml string, and save
    xml_string = xml.to_s.gsub("<to_s/>","")
    filename = RAILS_ROOT + "/public/sitemap.xml"
    xml_file = File.new(filename, "w")
    xml_file << xml_string
    xml_file.close

  end

  # end task, begin helper methods

  # uses Hpricot to grab links from a URI
  # adds uri to @pages_crawled
  # loops each link found
  # adds link to pages array if it should be included, unless it already exists
  def crawl_for_links(uri)
    if uri.include?('http')
      return unless uri.include?(DOMAIN)
      url = uri
    else
      url = BASE_URL + uri
    end
    doc = Hpricot(open(url)) rescue nil
    return unless doc
    @pages_crawled << uri
    (doc/"a").each { |a|
      if a['href'] && should_be_included?(a['href'])
        @pages << a['href'] unless(link_exists?(a['href'],@pages))
      end
    }
  end

  # returns true if any of the following are true:
  # - link isn't external (eg, contains 'http://') and doesn't contain 'mailto:'
  # - is equal to '/'
  # - link contains BASE_URL
  def should_be_included?(str)
    if ((!str.include?('http://') && !str.include?('mailto:')) || str == '/' || str.include?(BASE_URL))
      unless str.slice(0,1) == "#"
        return true
      end
    end
  end

  # checks each value in a given array for the given string
  # removes '/' character before comparison
  def link_exists?(str, array)
    array.detect{|l| strip_slashes(l) == strip_slashes(str)}
  end

  # removes '/' character from string
  def strip_slashes(str)
    str.gsub('/','')
  end
  
end
