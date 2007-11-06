module ClientsHelper

  def join_currencies_link(account)
    link_to l("Join Currencies"), join_om_account_path(@account)
  end
end
