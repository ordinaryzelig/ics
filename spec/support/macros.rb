module Macros

  def file_with_content(content)
    file = Tempfile.new('tmp')
    file.write content
    file.rewind
    file
  end

end
