class Struct

  def self.from_hash(h)
    # Make sure the Hash has symbol keys.
    h = Hash[h.map{ |k, v| [k.to_sym, v] }]

    new(*h.values_at(*self.members))
  end

end