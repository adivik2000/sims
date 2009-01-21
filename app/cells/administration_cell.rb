class AdministrationCell < Cell::Base
  def system
    @show=@opts[:district].system_admin? 
  end

  def country
    @current_district=@opts[:district]
    @show=@current_district.country_admin?
  end

  def state
    @current_district=@opts[:district]
    @show=@current_district.admin?
  end

  def district
    @current_district = @opts[:district]
    @show_schools = @opts[:user].authorized_for?('district/schools',:write_access)
    @show_users = @opts[:user].authorized_for?('district/users', :write_access)
    @show_students =@opts[:user].authorized_for?('district/students',:write_access)
    @show_district= @opts[:user].authorized_for?('districts',:write_access)
    
    @show = @show_schools || @show_users || @show_students || @show_district

  end

  def school
    @school = @opts[:school]
    @user = @opts[:user]
    @show = @user.user_school_assignments.admin.find_by_school_id(@school)
  end
end
