# LibXML SAX parsing for file and with specific callbacks
#
class XmlParser
  def initialize(file_path, callbacks)
    @parser = LibXML::XML::SaxParser.file(file_path)
    @parser.callbacks = callbacks
  end

  def call
    @parser.parse
  end
end
