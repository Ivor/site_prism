module SitePrism::PageContainer

  def page(page_name, klass = nil)
    build_getter(page_name, klass)
  end
  alias :realm :page

  private

  def convert_to_class(class_name)
    klass = if class_name.is_a? String
      Kernel.const_get underscore_to_camel_case(class_name)
    elsif class_name.is_a? Class
      class_name
    end
  end

  def build_getter(name, klass)
    klass = convert_to_class(klass || name.to_s)
    define_method name do
      klass.new
    end
  end

  def underscore_to_camel_case(phrase)
    phrase[0] = phrase[0].upcase
    phrase = phrase.split("_").map(&:capitalize).join if phrase.include?("_")
    return phrase
  end


end

