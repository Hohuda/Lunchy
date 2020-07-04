module SetAssociations
  extend ActiveSupport::Concern

  module ClassMethods
    def get_class_and_association_names(class_name)
      class_name = class_name.singularize.humanize
      associations = class_name.pluralize.downcase
      { class_name: class_name, associations: associations }
    end

    def create_set_associations_by_ids(class_name:, associations:)
      method_name = "set_#{associations}"
      klass = class_name.constantize
      define_method method_name do |*ids|
        ids.filter! { |i| i unless i.blank? }
        comp = (self.public_send(associations).ids <=> ids)
        if comp == 1
          diff = self.public_send(associations).ids - ids
          self.public_send(associations).delete(klass.find(diff))
        elsif comp == -1
          diff = ids - self.public_send(associations).ids
          self.public_send(associations) << klass.find(diff)
        end
      end
    end

    def create_set_association_method(class_name)
      names = get_class_and_association_names(class_name)
      create_set_associations_by_ids(names)
    end
  end
end