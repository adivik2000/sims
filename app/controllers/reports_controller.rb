class ReportsController < ApplicationController
  additional_read_actions :team_notes, :student_overall, :student_overall_options

  def student_overall
    # process params for student_overall_options
    params[:format] = params[:report_params][:format] if params[:report_params]
    params[:format] = 'html' unless defined? PDF::HTMLDoc

    @opts = params[:report_params] || {}

    respond_to do |format|
			@student = current_student

      format.html {}
      format.pdf {send_data render_to_pdf({ :action => 'student_overall', :layout => "pdf_report" }), :filename => "#{@student.studentNum}.pdf" }
		end
  end

  def student_overall_options
    # present choices for report, maybe merge this in via postback if it seems right. 
    @opts = [:top_summary, :flags, :team_notes, :intervention_summary, :checklists_and_or_recommendations]
		@student = current_student
		@filetypes = ['html']
    @filetypes << ['pdf'] if defined? PDF::HTMLDoc
  end

  def team_notes
    @today = Date.current

    if request.post?
      @start_date = build_date(params[:start_date])
      @end_date   = build_date(params[  :end_date])
    else
      @start_date = @end_date = @today
    end

    handle_report_postback TeamNotesReport, 'team_notes', :user => current_user, :start_date => @start_date, :end_date => @end_date
  end

  private

  def handle_report_postback report_class, base_filename, report_options = {}
    flash[:notice] = "Sorry, reports are not available" and redirect_to :back and return unless defined? Ruport

    @filetypes = ['html', 'pdf', 'csv']
    @selected_filetype = 'html'

    if request.post? and params[:generate] and params[:report_params]
      generate_report report_class, base_filename, report_options
    end
  end

  def generate_report report_class, base_filename, report_options
    fmt = params[:report_params][:format]
    @report = report_class.send("render_#{fmt}".to_sym, report_options)

    if ['csv','pdf'].include? fmt
      pdf_headers if fmt == 'pdf'
      send_data @report, :type => "application/#{fmt}",
                         :disposition => "attachment",
                         :filename => "#{base_filename}.#{fmt}"
    end
  end

  def pdf_headers
    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] ||= ''
      headers['Cache-Control'] ||= ''
    else
      headers['Pragma'] ||= 'no-cache'
      headers['Cache-Control'] ||= 'no-cache, must-revalidate'
    end
    headers["Content-Type"] ||= 'application/pdf'
  end

  def build_date date_hash
    if date_hash
      Date.new(date_hash[:year].to_i, date_hash[:month].to_i, date_hash[:day].to_i)
    else
      nil
    end
  end
end