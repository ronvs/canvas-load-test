require "rest-client"
require "nokogiri"
require "open-uri"

module Content

  module Wikipedia
    extend self

    def random_article
      "http://en.wikipedia.org/wiki/Special:Random"
    end

    def random_content
      doc = Nokogiri::HTML(open random_article)
      unless doc.css('p').first.content.nil?
        doc.css('p').first.content
      else
        "This should be a random content from a random Wikipedia article"
      end
    end

    def random_title
      doc = Nokogiri::HTML(open random_article)
      unless doc.css('title').first.content.nil?
        doc.css('title').first.content
      else
        "This should be a random title from a random Wikipedia article"
      end
    end
  end

end