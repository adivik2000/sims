module CSVImporter
  class SchoolAdmins < CSVImporter::Base
    FIELD_DESCRIPTIONS = { 
      :district_user_id =>"Key for user"
    }
    class << self
      def csv_headers
        [:district_user_id]
      end
      def description
        "School admins, role.  You also need to assign them as an admin to a specific school (edit their user within SIMS)"
      end

      def overwritten
      end

      def load_order
      end

      def removed
      end

#      def related
#      end

      def how_often
      end

#      def alternate
#      end

      def upload_responses
        super
      end

    end


  end
end

