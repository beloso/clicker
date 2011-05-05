module AdminsHelper
  def current_adm
    @current_admin ||= current_admin
    @current_admin.name
  end
end
