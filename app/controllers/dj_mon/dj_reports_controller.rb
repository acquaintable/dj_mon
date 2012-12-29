module DjMon
  class DjReportsController < ActionController::Base
    respond_to :json, :html
    layout 'dj_mon'

    if Rails.configuration.dj_mon.use_devise
      before_filter :authenticate_user!
      before_filter :is_admin? if Rails.configuration.dj_mon.use_devise_require_admin
    else
      before_filter :authenticate
    end
    before_filter :set_api_version

    def index
    end

    def all
      respond_with DjReport.all_reports
    end

    def failed
      respond_with DjReport.failed_reports
    end

    def active
      respond_with DjReport.active_reports
    end

    def queued
      respond_with DjReport.queued_reports
    end

    def dj_counts
      respond_with DjReport.dj_counts
    end

    def settings
      respond_with DjReport.settings
    end

    def retry
      DjMon::Backend.retry params[:id]
      respond_to do |format|
        format.html { redirect_to root_url, :notice => "The job has been queued for a re-run" }
        format.json { head(:ok) }
      end
    end

    def destroy
      DjMon::Backend.destroy params[:id]
      respond_to do |format|
        format.html { redirect_to root_url, :notice => "The job was deleted" }
        format.json { head(:ok) }
      end
    end

    def make_success
      DjMon::Backend.make_success params[:id]
      respond_to do |format|
        format.html { redirect_to root_url, :notice => "The job was made success" }
        format.json { head(:ok) }
      end
    end

    def make_fail
      DjMon::Backend.make_fail params[:id]
      respond_to do |format|
        format.html { redirect_to root_url, :notice => "The job was deleted" }
        format.json { head(:ok) }
      end
    end

    protected

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == Rails.configuration.dj_mon.username &&
        password == Rails.configuration.dj_mon.password
      end
    end

    def set_api_version
      response.headers['DJ-Mon-Version'] = DjMon::VERSION
    end

    private
    def is_admin?
      redirect_to '/' unless current_user.admin?
    end

  end

end
