class Notification < ApplicationRecord
  belongs_to :user
  after_initialize :set_default_is_read, if: :new_record?

  enum notification_type: {
    payment: 0,
    reservation: 1,
    observation: 2
  }

  private

  def set_default_is_read
    self.is_read ||= 0
  end
end
