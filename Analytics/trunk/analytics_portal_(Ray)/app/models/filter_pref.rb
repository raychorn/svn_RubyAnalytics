class FilterPref < ActiveRecord::Base
  belongs_to :optionable, :polymorphic => true
  belongs_to :filter_param
  belongs_to :user

  serialize :values, Hash

  # TODO secure filter_param_id
  attr_accessible :filter_param_id, :values, :start_date, :end_date, :period, :selected, :filter_enabled, :enable_email,
                  :alert_direction, :name, :target, :user_id

  # TODO add validations

  # used by forms
  def options_for_column
    [[nil, 'all']].concat self.optionable.report.report_queries.collect {
        |rq| [rq.query_select_group, rq.query_select_group] }.uniq
  end

  def options_for_kpi_filter_params(report)
    report.filter_params.select {|filter_param|
      filter_param.filter_param_type == FilterParam::KPI
    }.collect {|fp| [fp.id, fp.default_name] }
  end

  def period_selected?
    period != 0
  end

end
