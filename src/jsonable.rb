# Taken from https://stackoverflow.com/a/4464721
class JSONable
  def to_json(options={})
    hash = {}
    self.instance_variables.each do |var|
      hash[var] = self.instance_variable_get(var)
    end
    JSON.pretty_generate(hash)
  end

  def from_json!(string)
    JSON.load(string).each do |var, val|
      self.instance_variable_set var, val
    end
  end
end
