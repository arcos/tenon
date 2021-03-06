module ApplicationHelper
  def tenon_content(object, field)
    klass = 'tn-tc-row row'
    rows = []
    object.send("#{field}_tenon_content_rows").decorate.each do |row|
      rows << content_tag(:div, render(row.partial, row: row), class: klass)
    end
    rows.join('').html_safe
  end
end
