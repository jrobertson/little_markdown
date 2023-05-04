#!/usr/bin/env ruby

# file: little_markdown.rb

require 'rexle'

# The following HTML types are handled:
#
#   * h1, h2, h3 etc
#   * ul, ol
#   * img, a

class LittleMarkdown

  attr_reader :to_html

  def initialize(raws, debug: false)

    @debug = debug

    s = raws.strip
    s2 = ol_parse(s)
    s3 = ul_parse(s2)

    raw_html = s3.lines.map do |line|
      linex = replace(line) {|x| hx_parse(x)}
      linex3 = replace(linex) {|x| p_parse(x)}

    end.join

    doc = Rexle.new("<body>%s</body>" % raw_html)
    xml = doc.xml(pretty: true, declaration: 'none')
    

    xml2 = replace_img(xml)
    xml3 = replace_link(xml2)
    puts 'xml3: ' + xml3.inspect if @debug
    
    @to_html = xml3.strip.lines[1..-2].map {|x| x[2..-1] }.join
    
  end

  private

  def replace(s)

    cur = s =~ />[^>]+$/
    puts 'cur: ' + cur.inspect if @debug

    s2 = cur ? (s[0..cur] + yield(s[cur+1..-1])) : yield(s)
    puts 's2: ' + s2.inspect if @debug
    s2

  end

  def hx_parse(s)
    
    s.sub(/^(#+) ([^\n]+)/) do |x|
      puts 'x: ' + [$1, $2].inspect
      hx, title = [$1, $2]
      "<h%d>%s</h%d>" % [hx.length, title, hx.length]
    end

  end

  def p_parse(s)
    s.sub(/^([^\n]+)/,'<p>\1</p>')
  end

  def ol_parse(s)

    lines = s.lines
    prev_item = nil
    slist = lines.map.with_index do |x, i|

      if x[/^\d+\./] then
        r = if (i == 0 or !prev_item) then
          x.sub(/^\d+\. *(.*)/,'<ol><li>\1</li>')
        else
          x.sub(/^\d+\. *(.*)/,'<li>\1</li>')
        end
        prev_item = true
        r
      else
        if prev_item then
          prev_item = false
          x + '</ol>'
        else
          x
        end
      end

    end.join

    slist += '</ol>' if prev_item
    slist
  end

  def ul_parse(s)

    lines = s.lines
    prev_item = nil
    slist = lines.map.with_index do |x, i|

      if x[/^\* /] then
        r = if (i == 0 or !prev_item) then
          x.sub(/^\* *(.*)/,'<ul><li>\1</li>')
        else
          x.sub(/^\* *(.*)/,'<li>\1</li>')
        end
        prev_item = true
        r
      else
        if prev_item then
          prev_item = false
          x + '</ul>'
        else
          x
        end
      end

    end.join

    slist += '</ul>' if prev_item
    slist

  end

  def replace_link(s5)

    if @debug then
      puts 'inside replace_link'
      puts 's5: ' + s5.inspect
    end

    s5.gsub(/\[[^\]]+\]\([^\)]+\)/m) do |x|

      puts 'x: ' + x.inspect if @debug

      found = x.match(/(?<=\[)([^\]]+)\]\(([^\)]+)/)
      puts 'found: ' + found.inspect if @debug

      if found then
        title, href = found[1..-1] 
        "<a href='%s'>%s</a>" % [title, href]
      else
        x
      end

    end

  end
  
  def replace_img(s5)

    if @debug then
      puts 'inside replace_img'
      puts 's5: ' + s5.inspect
    end

    s5.gsub(/\!\[([^\]]+)\]\(([^\)]+)/m) do |x|

      puts 'x: ' + x.inspect if @debug

      found = x.match(/\[([^\]]+)\]\(([^\)]+)/)
      puts 'found: ' + found.inspect if @debug

      if found then
        title, src = found[1..-1] 
        "<img src='%s' alt='%s'/>" % [src, title]
      else
        x
      end

    end

  end  

end

