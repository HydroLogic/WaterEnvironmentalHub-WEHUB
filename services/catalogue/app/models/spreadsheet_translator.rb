require 'csv' 

class SpreadsheetTranslator
  
  def initialize(filename, uploads_directory='public/uploads', spreadsheets_directory='tmp/spreadsheets')
    @filename = filename
    @spreadsheets_directory = spreadsheets_directory
    
    filename_upload = "#{uploads_directory}/#{@filename}"
    
    if !is_csv
      @spreadsheet = Roo::Spreadsheet.open(filename_upload)
      @spreadsheet.default_sheet = @spreadsheet.sheets.first
      
      save_as_csv
    else
      begin
        file = CSV.open(filename_upload)
        file.readline        
        %x[cp #{filename_upload} #{filename_csv}]
      rescue Exception => e
        raise ArgumentError, "SpreadsheetTranslator: Invalid comma-seperated values. Please check for unterminated quoted fields and remove all carriage returns (\\r or \\r\\n) within fields"
      end
    end
    
    @field_names = load_fieldnames

    delete_fieldnames_row
  end
  
  def fieldnames
    @field_names
  end
  
  def fields_sql
    field_names_with_datatypes = ''  
    @field_names.each do |field|
      sanitized_field = field.gsub('"','')
      field_names_with_datatypes << "\"#{sanitized_field}\" character varying(255),"
    end
    field_names_with_datatypes.chop!
    field_names_with_datatypes
  end
  
  def filename
    File.path(filename_csv)
  end
  
  private 

  def is_csv
    !@filename.match(/\.csv$/).nil?
  end
  
  def load_fieldnames
    if !is_csv
      @spreadsheet.row(@spreadsheet.first_row)
    else    
      File.open(filename_csv, "r") do |file|
        while (row = file.gets)
            return row.gsub('\n','').split(',')
        end
      end
    end
  end
  
  def filename_csv
    "#{@spreadsheets_directory}/#{@filename.split('.')[0]}.csv"
  end
    
  def save_as_csv
    @spreadsheet.to_csv(filename_csv)
  end
  
  # The Roo Gem (providing spreadsheet conversion) is read only, doesn't support editing spreadsheets 
  #  since I can't edit the spreadsheet, I'm deleting the fieldnames through the commandline  
  def delete_fieldnames_row
    filename_temp = "#{@spreadsheets_directory}/#{@filename.split('.')[0]}.processed.csv"
    # Clean up the first line, it contains the field names
    %x[tail -n +2 #{filename_csv} > #{filename_temp}]
    # Clean up the csv file, remove double newlines    
    %x[sed ':a;N;$!ba;s/\\n\\n/\\n/g' #{filename_temp} > #{filename_csv}]
    # Clean up the temp file
    %x[rm #{filename_temp}]
  end

end
