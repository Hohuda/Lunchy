class Symbol
  # Converts string to pluralized symbol
  def pluralize
    to_s.pluralize.to_sym
  end
end