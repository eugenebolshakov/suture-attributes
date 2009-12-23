module SutureAttributes
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.send(:extend, ClassMethods)
    base.before_validation :sanitize_numeric_attributes
  end
  
  module ClassMethods
    def strip_attributes(*attrs)
      before_validation :strip_attributes
      
      write_inheritable_attribute :attributes_to_strip, attrs
      class_inheritable_reader    :attributes_to_strip
    end
  end

  module InstanceMethods
  
  protected

    def sanitize_numeric_attributes
      self.class.columns.select(&:number?).each do |column|
        next if column.primary
        send("#{column.name}=", sanitize_number(send("#{column.name}_before_type_cast")))
      end
    end

    def sanitize_number(number)
      number.to_s.gsub(/[^\d\.-]/, '')
    end

    def strip_attributes
      self.class.attributes_to_strip.each do |attr|
        value = send(attr)
        unless value.nil?
          send("#{attr}=", value.to_s.strip)
        end
      end
    end
  end
end
