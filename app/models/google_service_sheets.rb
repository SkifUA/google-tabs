class GoogleServiceSheets
  require 'google/apis/sheets_v4'

  def initialize(user)
    @spreadsheet_id = '1rRKvUfMveR5cggGzSc2hWn3KmQ96iTAvgTHtqqegOIY'
    @secrets = GoogleClientSecrets.secrets(user)
  end

  def service
    client = Google::Apis::SheetsV4::SheetsService.new
    client.authorization = @secrets.to_authorization
    client.authorization.grant_type = 'refresh_token'
    client.authorization.refresh!
    client
  end

  def read(page, cells)
    range = "#{page}!#{cells}"
    puts service.get_spreadsheet_values(@spreadsheet_id, range)
  end

  def update_all(objects)
    rows = []
    objects.each { |object| rows << row_for_sheets(object) }

    range = "products!A2:D#{rows.count + 1}"
    value_range_object = {
        range: "products!A2:D#{rows.count + 1}",
        major_dimension: "ROWS",
        values: rows
    }

    response = service.update_spreadsheet_value(
        @spreadsheet_id,
        range,
        value_range_object,
        include_values_in_response: true,
        value_input_option: 'USER_ENTERED'
    )

    puts response.to_json
  end

  private

  def row_for_sheets(object)
    [object.id, object.name, object.quantity, object.description]
  end
end