class Echoable < ActiveRecord::Base
  def as_json *args
    (data.try(:slice, *data.try(:keys)) || {}).merge slice(:id)
  end
end
