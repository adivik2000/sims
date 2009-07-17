class TeamAgendasController < ApplicationController
  skip_before_filter :authorize
  # GET /team_agendas
  # GET /team_agendas.xml
  def index
    @team_agendas = TeamAgenda.all
    @team_consultation = TeamConsultation.find(params[:consultation_id])
    @agenda = TeamAgenda.find_or_initialize_by_date(Date.today)
    @agenda.notes = 'No notes yet' if @agenda.new_record?

    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.xml  { render :xml => @team_agendas }
    end
  end

  # GET /team_agendas/1
  # GET /team_agendas/1.xml
  def show
    
    d=params[:date]
    date=Date.civil(d["year"].to_i,d["month"].to_i, d["day"].to_i)
    @agenda = TeamAgenda.find_or_initialize_by_date(date)

    @agenda.notes = 'No notes yet' if @agenda.new_record?
    respond_to do |format|
      format.js
    
      format.html # show.html.erb
      format.xml  { render :xml => @team_agenda }
    end
  end

  # GET /team_agendas/new
  # GET /team_agendas/new.xml
  def new
    @team_agenda = TeamAgenda.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @team_agenda }
    end
  end

  # GET /team_agendas/1/edit
  def edit
    @team_agenda = TeamAgenda.find(params[:id])
  end

  # POST /team_agendas
  # POST /team_agendas.xml
  def create
    @team_agenda = TeamAgenda.new(params[:team_agenda])

    respond_to do |format|
      if @team_agenda.save
        flash[:notice] = 'TeamAgenda was successfully created.'
        format.html { redirect_to(@team_agenda) }
        format.xml  { render :xml => @team_agenda, :status => :created, :location => @team_agenda }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @team_agenda.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /team_agendas/1
  # PUT /team_agendas/1.xml
  def update
    @team_agenda = TeamAgenda.find(params[:id])

    respond_to do |format|
      if @team_agenda.update_attributes(params[:team_agenda])
        flash[:notice] = 'TeamAgenda was successfully updated.'
        format.html { redirect_to(@team_agenda) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @team_agenda.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /team_agendas/1
  # DELETE /team_agendas/1.xml
  def destroy
    @team_agenda = TeamAgenda.find(params[:id])
    @team_agenda.destroy

    respond_to do |format|
      format.html { redirect_to(team_agendas_url) }
      format.xml  { head :ok }
    end
  end

  def set_agenda_notes
    d=params[:date]
    date=Date.civil(d["year"].to_i,d["month"].to_i, d["day"].to_i)
    @agenda = TeamAgenda.find_or_initialize_by_date(date)
    @agenda.notes = params[:value]
    @agenda.save
    render :text => params[:value]
  end
end
