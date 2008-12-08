# Customized default formatters for ruport. Each class renders text for the 
# next immediate subclass(specified as Class.nesting[1])
class HtmlTextCsv
  class HTML < Ruport::Formatter::HTML
    renders :html, :for => Class.nesting[2]
    build :header do
      output << "Report Generated at #{Time.now}"
    end

    build :body do
      output << data.to_grouping.to_html
    end
  end

  class Text < Ruport::Formatter
    renders :text, :for => Class.nesting[2]
    build :header do
      output << "Report Generated at #{Time.now}\n\n"
    end

    build :body do
      output << data.to_grouping.to_text
    end
  end

  class CSV < Ruport::Formatter::CSV
    renders :csv, :for => Class.nesting[2]

    build :body do
      output << data.to_table.to_csv
    end
  end
end