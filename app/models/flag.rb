# == Schema Information
# Schema version: 20090623023153
#
# Table name: flags
#
#  id          :integer(4)      not null, primary key
#  category    :string(255)
#  user_id     :integer(4)
#  district_id :integer(4)
#  student_id  :integer(4)
#  reason      :text
#  type        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Flag < ActiveRecord::Base
	ORDERED_TYPE_KEYS = %w{attendance suspension math languagearts science socialstudies gifted ignored custom}

  TYPES = {
      "attendance" => {:icon => "A.gif", :humanize => "Attendance",
        :how_often_to_upload => "If using this flag, needs to be done daily or weekly to be effective."
                      },
      "suspension" => {:icon=> "B.gif", :humanize => "Behavior",
        :how_often_to_upload =>
                      "As soon as possible after availability. 
          (Note - if you are using this data for flags, it needs to be uploaded quickly in order to be used effectively.)"
                      },
      "math" => {:icon => "M.gif", :humanize => "Math"},
      "languagearts" => {:icon => "LA.gif", :humanize => "Language Arts"},
      "science" => {:icon=> "Beaker.png", :humanize => "Science"},
      "socialstudies" => {:icon=> "world_edit.png", :humanize => "Social Studies"},
      "gifted" => {:icon=> "lightbulb.png", :humanize => "Gifted/Talented"},
      "ignored" => {:icon => "I.gif", :humanize => "Ignored"},
      "custom" => {:icon => "C.gif", :humanize => "Custom"}
    }
  ORDERED_HUMANIZED_ALL=ORDERED_TYPE_KEYS.collect{|e| TYPES[e][:humanize]}
  ORDERED_HUMANIZED_TYPES=ORDERED_HUMANIZED_ALL[0..-3]
  FLAGTYPES= TYPES.reject{|i,j| i=="custom" || i=="ignored"}

  belongs_to :student, :touch => true
  belongs_to :user
  belongs_to :district
  validates_presence_of :category, :reason, :type
  validates_inclusion_of :category, :in => FLAGTYPES.keys

  acts_as_reportable if defined? Ruport


  named_scope :custom, :conditions=>{:type=>'CustomFlag'}
  named_scope :ignore, :conditions=>{:type=>'IgnoreFlag'}
  named_scope :system, :conditions=>{:type=>'SystemFlag'}

  def summary
    "#{reason}- by #{user} on #{created_at}"
  end

  def icon
    TYPES[self.category][:icon]
  end

  def self.summary
    all.collect(&:summary)
  end

  def self.current
    #FIXME doesn't handle ignores
    # all.group_by(&:category)
    all.reject do |f|
      (f[:type] == 'IgnoreFlag') or (f[:type] == 'SystemFlag' and IgnoreFlag.find_by_category_and_student_id(f.category, f.student_id))
    end.group_by(&:category)
  end
end
