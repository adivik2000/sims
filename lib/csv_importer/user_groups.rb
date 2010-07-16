module CSVImporter
  class UserGroups < CSVImporter::Base
    #125.01763010025 seconds!
    #135 with district constrained delete
    #
    #
    FIELD_DESCRIPTIONS = { 
      :district_example_id => 'the primary key used in the student information system by the district',
      :example_text => 'some other field'
    }
    class << self
      def description
        "Assigns users to groups."
      end

      def csv_headers
        [:district_user_id, :username, :first_name, :middle_name, :last_name, :suffix, :email, :passwordhash, :salt]
      end

      def overwritten
        "What will get overwritten/changed when this file is uploaded."
      end

      def load_order
        "When to upload this file in relation to other files."
      end

      def removed
        "What gets removed when this file is uploaded."
      end

      def related
        "links to related files with explanations."
      end

      def how_often
        "Notes on how often this file should be imported after initial import."
      end

      def alternate
        "links to files that can be used instead of this one, with explanation."
      end

      def upload_responses
        "What you see on the screen or in the email after uploading this file and what the different messages mean. <br />
        In this case you'll see unknown file examples.csv"
      end

    end


  private

    def load_data_infile
      headers=csv_headers
      headers[-1]="@principal"
      <<-EOF
          LOAD DATA LOCAL INFILE "#{@clean_file}" 
            INTO TABLE #{temporary_table_name}
            FIELDS TERMINATED BY ','
            OPTIONALLY ENCLOSED BY '"'
            (#{headers.join(", ")})
        set    principal= case trim(lower(@principal)) 
        when 't' then true 
        when 'y' then true 
        when 'yes' then true 
        when 'true' then true 
        when '-1' then true 
        when '1' then true 
        else false 
        end ;
        EOF
    end
 
    def index_options
      [[:district_user_id, :district_group_id]]
    end

    def csv_headers
      [:district_user_id, :district_group_id, :principal]
    end

    def migration t
      t.string :district_user_id
      t.string :district_group_id
      t.boolean :principal
    end

    def delete
      query = "delete from uga using user_group_assignments uga
      inner join users on uga.user_id = users.id
      inner join groups on uga.group_id = groups.id
      inner join schools on groups.school_id = schools.id
      where schools.district_id = #{@district.id} and users.district_id = #{@district.id} and groups.district_group_id is not null and groups.district_group_id !=''
      "

extra ="      where not exists (
        select 1 from #{temporary_table_name} tug
        where tug.district_user_id = users.district_user_id and tug.district_group_id = groups.district_group_id)
      )"
      UserGroupAssignment.connection.execute query
    end

    def insert
      query=("insert into user_group_assignments
      (user_id,group_id, is_principal, created_at, updated_at)
      select u.id , g.id, principal, CURDATE(), CURDATE() from #{temporary_table_name} tug inner join 
      users u on u.district_user_id = tug.district_user_id
      inner join groups g
      on tug.district_group_id = g.district_group_id
      and u.district_id = #{@district.id}  
      "
      )
      Group.connection.execute query
    end
  end
end
