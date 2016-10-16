class Credential < Struct.new(:username, :password)

  def match?(un, pw)
    username == un and password == pw
  end

end
