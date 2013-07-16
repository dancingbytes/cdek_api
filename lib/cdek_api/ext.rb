# encoding: UTF-8
require 'unicode'

class String

  class_eval '

    def first_capitalize

      str     = self
      str[0]  = Unicode::capitalize(str[0] || "")
      str

    end # first_capitalize
  '

end # String
