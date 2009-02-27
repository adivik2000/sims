class DailyJobs
  def self.run
    self.regenerate_intervention_reports
  end

  def self.regenerate_intervention_reports
    District.all.each do |d|
      CreateInterventionPdfs.generate(d)
    end
  end

  def self.run_weekly
    self.reset_demo if defined?(SIMS_DOMAIN) && SIMS_DOMAIN == "sims-open.vegantech.com"
  end

  def self.reset_demo
    Intervention.destroy_all
    CustomFlag.destroy_all
    Checklist.destroy_all
    Recommendation.destroy_all
    PrincipalOverride.destroy_all
    StudentComment.destroy_all
    RailmailDelivery.destroy_all if defined?RailmailDelivery
    puts "Reset Demo"
  end

end
