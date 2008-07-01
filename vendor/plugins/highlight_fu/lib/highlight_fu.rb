
module HighlightFu
    def highlight(text, *options)
      #text.scan(/(<p>&lt;pre lang=&quot;([a-z].+?)&quot;&gt;<\/p>(.+?)<p>&lt;\/pre&gt;<\/p>)/mi).each do |match|
      text.scan(/(<pre lang="([a-z].+?)">(.+?)<\/pre>)/mi).each do |match|
        text.gsub!(match[0], "<textarea name='code' class='#{match[1]}#{make_options *options}'>#{match[2]}</textarea>")
      end
      return text
    end

    def highlight_initialize
        javascript = <<-CMD
            dp.SyntaxHighlighter.ClipboardSwf = "#{compute_public_path 'clipboard', 'javascripts', 'swf'}";
            dp.SyntaxHighlighter.HighlightAll('code');      
        CMD
        content_tag :script, javascript, :type => 'text/javascript'
    end
    
    def highlight_include_assets
      "#{include_stylesheets}
      #{include_javascripts}"
    end

    private
    def include_stylesheets
        stylesheet_link_tag 'SyntaxHighlighter.css'
    end
    
    def include_javascripts
        return <<-EOF
        #{javascript_include_tag("shCore")}
        #{javascript_include_tag("shBrushRuby")}
        #{javascript_include_tag("shBrushXml")}
        #{javascript_include_tag("shBrushJScript")}
        #{javascript_include_tag("shBrushCss")}
        #{javascript_include_tag("shBrushCpp")}
        #{javascript_include_tag("shBrushCSharp")}
        #{javascript_include_tag("shBrushDelphi")}
        #{javascript_include_tag("shBrushJava")}
        #{javascript_include_tag("shBrushPhp")}
        #{javascript_include_tag("shBrushPython")}
        #{javascript_include_tag("shBrushSql")}
        #{javascript_include_tag("shBrushVb")}
        EOF
    end
    
    def make_options(*options)
        if options.last.is_a? Hash
          ops = options.pop {}
          ":#{options.join(":")}:firstline[#{ops[:firstline]}]"
        else
          ":#{options.join(":")}"
        end
    end
end
