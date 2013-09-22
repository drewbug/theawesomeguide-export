#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'json'

hash = {}

noko = Nokogiri::HTML open('http://web.archive.org/web/20120625033923/http://www.theawesomeguide.com/').read

noko.at_css('.wsite-multicol-tr').css('.wsite-multicol-col').css('h2, strong, a').slice_before { |e| e.name == 'h2' }.each do |category|
  h2 = category.shift.text
  hash[h2] = {}

  category.slice_before { |e| e.name == 'strong' }.each do |group|
    if group.first.name == 'strong'
      strong = group.shift.text.chomp(':')
      hash[h2][strong] = {} 
    end

    group.each do |link|
      unless link.text.empty?
        text = link.text.sub(' ', ' ').strip
        url = link['href'].sub(/\A\/web\/20120625033923\//, '')

        if strong
          hash[h2][strong][text] = url
        else
          hash[h2][link.text] = url
        end
      end
    end
  end
end

print JSON.pretty_generate hash
