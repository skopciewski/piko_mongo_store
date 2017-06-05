# frozen_string_literal: true

# Copyright (C) 2017 Szymon Kopciewski
#
# This file is part of PikoMongoStore.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require "mongo"
require "digest/md5"
require "logger2r"

module PikoMongoStore
  class DbFactory
    @connections = {}

    def self.create_db_connection(config)
      config_copy = config.dup
      hosts = config_copy.delete(:hosts)
      default_config = { logger: Logger2r.for_class("Mongo::Client") }
      config_hash = Digest::MD5.hexdigest(config.inspect)
      @connections[config_hash] ||= Mongo::Client.new(hosts, default_config.merge(config_copy))
    end
  end
end
