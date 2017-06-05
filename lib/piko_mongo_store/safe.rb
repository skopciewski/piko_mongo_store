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

require "piko_mongo_store/logger"

module PikoMongoStore
  class Safe
    include Logger

    def initialize(db)
      @db = db
    end

    def execute(success_action = nil)
      logger.debug { format "Performing safe action in DB" }
      handle_result yield(@db), success_action
    rescue Mongo::Error => e
      logger.error { format "%s - %s", e.class.name, e.message }
      false
    end

    private

    def handle_result(result, success_action)
      logger.debug { format "DB result: %s", result.inspect }
      return result.ok? if mongo_operation?(result)
      result = {} if result.nil?
      success_action.call(result) if success_action.is_a?(Proc)
      true
    end

    def mongo_operation?(result)
      result.is_a?(Mongo::Operation::Result)
    end
  end
end
