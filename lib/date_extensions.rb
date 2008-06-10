my_formats = {
  :long_date => "%A - %b %d",
  :day => "%A",
  :date_and_time => "%a %b %d, %Y %I:%M %p",
  :long_date_and_time => "%I:%M%p (UTC) on %b %d, %Y",
  :short_date => '%B %d, %Y',
  :really_short_date => "%b %d",
  :time => "%l:%M %p"
}

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(my_formats)