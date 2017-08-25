class NetmultixRecord < ActiveRecord::Base

  establish_connection(
      adapter: "mysql2",
      host: "10.0.0.13",
      encoding: "utf8",
      pool: "5",
      username: "netmultix",
      password: "N3tMult1x@CIMAV",
      socket: "/tmp/mysql.sock",
      database: "netmultix"
  )

  self.abstract_class = true

end