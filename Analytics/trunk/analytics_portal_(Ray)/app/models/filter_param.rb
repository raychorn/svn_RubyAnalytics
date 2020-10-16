class FilterParam < ActiveRecord::Base
  belongs_to :report
  belongs_to :report_query
  has_many :filter_prefs, :dependent => :destroy

  validates_presence_of :column, :filter_param_type, :report_id

  def name
    "#{filter_param_type} - #{column}"
  end

  DAY_DATE = 'day_date'
  MONTH_DATE = 'month_date'
  CONNECTION_TYPE = 'connection_type'
  CHECK_BOXES = 'check_boxes'
  KPI = 'kpi'

  def options_for_filter_param_type
    [
      [DAY_DATE, 'date filter (by day)'],
      [MONTH_DATE, 'date picker (by month)'],
      [CONNECTION_TYPE, 'connection type'],
      [CHECK_BOXES, 'check boxes'],
      [KPI, 'kpi']
    ]
  end

  def all_options_for_period
    [
        [604800, 'last week'],
        [2592000, 'last month'],
        [7776000, 'last 3 months'],
        [31557600, 'last year'],
        [0, 'fixed range:']
    ]
  end

  def options_for_period
    all_options_for_period.select { |opt| (opt.first >= self.min_period || opt.first == 0) }
  end

  def options_for_default_period
    all_options_for_period - [[0, 'fixed range:']]
  end

  def options_for_min_period
    all_options_for_period - [[0, 'fixed range:']]
  end

  def options_for_connection_type
    [
        [ nil, 'All Connection Types'],
        ['3GDevice', '3G'],
        ['4GDevice', '4G'],
        ['WiFiDevice', 'Wi-Fi'],
        ['EthernetDevice', 'Ethernet']
    ]
  end

  def options_for_check_boxes
    self.values.present? ? JSON.parse(self.values).collect : []
  end

  def options_for_interval
    [
        ['day', 'day'],
        ['week', 'week'],
        ['month', 'month']
    ]
  end

  HIGHER_IS_BETTER = 1
  LOWER_IS_BETTER = 0

  def self.options_for_alert_direction
    [
        [HIGHER_IS_BETTER, 'Higher is better'],
        [LOWER_IS_BETTER, 'Lower is better']
    ]
  end
end
