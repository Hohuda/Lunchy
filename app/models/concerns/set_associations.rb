module SetAssociations
  extend ActiveSupport::Concern

  module ClassMethods
    def get_class_and_association_names(target_class)
      class_name = target_class.to_s.singularize.humanize
      associations = class_name.pluralize.downcase
      { class_name: class_name, associations: associations }
    end

    def create_set_associations_by_ids(associations)
      method_name = "set_#{associations}"
      assoc_ids_method_name = "#{associations.singularize}_ids"
      define_method method_name do |*ids|
        new_ids = ids.flatten.select(&:present?).map(&:to_s).uniq
        public_send("#{assoc_ids_method_name}=", new_ids)
      end
    end

    def create_set_association_method_for(target_class)
      names = get_class_and_association_names(target_class)
      create_set_associations_by_ids(names[:associations])
    end
  end
end