class GoogleServiceScript
  require 'google/apis/script_v1'

  def initialize(user)
    @script_id = 'M5Rar7VYHwoWufi20N8Wo0yK8GE_NkQWo'
    @secrets = GoogleClientSecrets.secrets(user)
  end

  def service
    client = Google::Apis::ScriptV1::ScriptService.new
    client.authorization = @secrets.to_authorization
    client.authorization.grant_type = 'refresh_token'
    client.authorization.refresh!
    client
  end

  def script
    # Create an execution request object.
    request = Google::Apis::ScriptV1::ExecutionRequest.new(
        function: 'getFoldersUnderRoot'
    )

    begin
      # Make the API request.
      resp = service.run_script(@script_id, request)

      if resp.error
        # The API executed, but the script returned an error.

        # Extract the first (and only) set of error details. The values of this
        # object are the script's 'errorMessage' and 'errorType', and an array of
        # stack trace elements.
        error = resp.error.details[0]

        puts "Script error message: #{error['errorMessage']}"

        if error['scriptStackTraceElements']
          # There may not be a stacktrace if the script didn't start executing.
          puts "Script error stacktrace:"
          error['scriptStackTraceElements'].each do |trace|
            puts "\t#{trace['function']}: #{trace['lineNumber']}"
          end
        end
      else
        # The structure of the result will depend upon what the Apps Script function
        # returns. Here, the function returns an Apps Script Object with String keys
        # and values, and so the result is treated as a Ruby hash (folderSet).
        folder_set = resp.response['result']
        if folder_set.length == 0
          puts "No folders returned!"
        else
          puts "Folders under your root folder:"
          folder_set.each do |id, folder|
            puts "\t#{folder} (#{id})"
          end
        end
      end
    rescue Google::Apis::ClientError
      # The API encountered a problem before the script started executing.
      puts "Error calling API!"
    end
  end
end
