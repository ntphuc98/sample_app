module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title page_title
    base_title = I18n.t ".layouts.application.title"
    sub_title = I18n.t ".layouts.application._title"
    page_title.blank? ? base_title : page_title + sub_title + base_title
  end
end
