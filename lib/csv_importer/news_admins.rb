module CSVImporter
  class NewsAdmins < CSVImporter::Base
    FIELD_DESCRIPTIONS = { 
      :district_user_id =>"Key for user"
    }
    class << self
      def csv_headers
        [:district_user_id]
      end
      def description
        "List of users with access to the edit and create news entries."
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

