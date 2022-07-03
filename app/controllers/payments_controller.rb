require 'mercadopago'

class PaymentsController < ApplicationController
  def new
    # Agrega credenciales
    sdk = Mercadopago::SDK.new(ENV['MP_ACCESS_TOKEN'])

    # Crea un objeto de preferencia
    preference_data = {
      items: [
        {
          title: 'Mi producto',
          unit_price: 75.56,
          quantity: 1

        }
      ],
      back_urls: {
        success: payments_success_url,
        failure: payments_failure_url,
        pending: payments_pending_url
      },
      notification_url: ENV['NGROK'] ? payments_notification_url(protocol: 'https', host: ENV['NGROK'], port: nil) : payments_notification_url
    }

    preference_response = sdk.preference.create(preference_data)
    @preference = preference_response[:response]

    # Este valor reemplazará el string "<%= @preference_id %>" en tu HTML
    # @preference_id = preference['id']
  end

  def success; end

  def failure; end

  def pending; end

  def notification
    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
