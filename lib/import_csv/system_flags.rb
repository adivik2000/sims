module ImportCSV::SystemFlags
  
  def load_system_flags_from_csv file_name
    #85 seconds
    @student_ids_by_id_district = ids_by_id_district Student
    if load_from_csv file_name, 'system_flag'
      SystemFlag.connection.execute("delete from flags using flags inner join students on flags.student_id = students.id where type='SystemFlag' and students.district_id = #{@district.id} and students.id_district is not null")
      bulk_insert SystemFlag
    end
  end

  def process_system_flag_line line
      category = line[:category].to_s.downcase
    student_id_district =  line[:student_id_district].to_i

    if Flag::FLAGTYPES.keys.include?(category)
      student_id = @student_ids_by_id_district[student_id_district]
      
      @inserts << SystemFlag.new(:student_id => student_id, :category => category, :reason => line[:reason]) unless student_id.nil?
    else
      @messages << "Unknown category for #{category}"
    end
  end
end

