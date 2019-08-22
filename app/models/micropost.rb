class Micropost < ApplicationRecord
  belongs_to :user
  default_scope ->{order created_at: :desc}
  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.maximum_content_mp}
  validate :picture_size

  private

  # Validates the size of an uploaded picture.
  def picture_size
    return unless picture.size > Settings.max_picture_size.megabytes
    errors.add :picture, I18n.t(".picture_size_error")
  end
end
