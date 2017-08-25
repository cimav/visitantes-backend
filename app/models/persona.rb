class Persona < NetmultixRecord

  attribute :id, :integer

  def id # getter

    case self.tipo
      when 1
        self.clave.to_i
      when 2
        self.clave.to_i + 10000
    end

  end

end

=begin
  clave      | tipo | nombre                                                       | sede |
+------------+------+--------------------------------------------------------------+------+
| 00348      |    1 | ACOSTA SLANE DAMARIS                                         | 1

=end
