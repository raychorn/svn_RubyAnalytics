class TableReport < Report

  def table_data(column_filter_hash, filter_prefs)
    # use the report's filter_prefs if nothing is defined from the dashboard_report
    filter_prefs = self.filter_prefs if filter_prefs.blank?

    selected_report_queries = selected_report_queries(filter_prefs)

    filtered_columns = self.filtered_columns(column_filter_hash, filter_prefs)

    if !defined?(@table_results) || @table_results.blank?
      @table_results = []
      selected_report_queries.each do |report_query|
        filtered_result_data = report_query.query.filtered_results(
            filter_prefs, :sample_option => self.sample_option, :sql_string => report_query.sql_string
        )
        result_set = filtered_result_data.result_set
        result_set.results_array.each do |row|
          row_hash = {}
          filtered_columns.each_with_index { |col, i| row_hash[col] = result_set.value_at(row, col) }
          @table_results << row_hash
        end
#        filtered_columns.uniq!
      end
    end

    [filtered_columns, @table_results]
  end

  def filtered_columns(column_filter_hash, filter_prefs)
    if @filtered_columns.present?
      @filtered_columns
    elsif self.table_columns.blank?
      @filtered_columns = []
    else
      @filtered_columns = self.table_columns.strip.split(%r{,\s*})
      # TODO fix
#      filter_columns = column_filter_hash['columns']
#
#      if filter_columns.present?
#        @table_columns_array.select! do |tc|
#          if filter_columns.has_key?(tc)
#            # is either true or false
#            filter_columns[tc]
#          else
#            true
#          end
#        end
#      end
    end
  end

  # used by TableData jquery plugin
  def json_data(column_filter_hash, filter_prefs)
    table_data = table_data(column_filter_hash, filter_prefs)
    columns_array = table_data[0]
    results_hash = table_data[1]

    results = results_hash.collect do |data_row|
      columns_array.collect do |col_name|
        DataParameter.lookup_display_value(col_name, data_row[col_name])
      end
    end

    # formatted for TableData jquery plugin
    return { "aaData" => results }.to_json
  end

end
