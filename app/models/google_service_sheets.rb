class GoogleServiceSheets
  require 'google/apis/sheets_v4'

  def initialize(user, sheets_id)
    @spreadsheet_id = sheets_id
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
    response = service.get_spreadsheet_values(@spreadsheet_id, range)
    response.values
  end

  def number_row(column, id)
    number = 0
    column.each do |row|
      number += 1
      break if row.first == id.to_s
    end
    number
  end

  def update(object)
    rows = read('products', 'A1:A')
    updated_row = number_row(rows, object.id)

    range = "products!A#{updated_row}:D#{updated_row}"
    value_range_object = {
        range: range,
        major_dimension: "ROWS",
        values: [row_for_sheets(object)]
    }

    service.update_spreadsheet_value(
        @spreadsheet_id,
        range,
        value_range_object,
        include_values_in_response: true,
        value_input_option: 'USER_ENTERED'
    )

  end

  def create(object)
    rows = read('products', 'A1:A')
    updated_row = rows.count + 1

    range = "products!A#{updated_row}:D#{updated_row}"
    value_range_object = {
        range: range,
        major_dimension: "ROWS",
        values: [row_for_sheets(object)]
    }

    service.update_spreadsheet_value(
        @spreadsheet_id,
        range,
        value_range_object,
        include_values_in_response: true,
        value_input_option: 'USER_ENTERED'
    )
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

  # TODO added method for destroy row
  # def destroy(object_id)
  # end

  private

  def row_for_sheets(object)
    [object.id, object.name, object.quantity, object.description]
  end
end