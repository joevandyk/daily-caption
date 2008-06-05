my_formats = {
  :long_date => "%A - %b %d, %y",
  :day => "%A",
  :date_and_time => "%a %b %d, %Y %I:%M %p",
  :long_date_and_time => "%a %b %d, %Y %I:%M:S %p",
  :short_date => '%Y-%m-%d',
  :really_short_date => "%b %d",
  :time_only => "%l:%M:%S %p"
}

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(my_formats)