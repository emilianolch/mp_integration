require 'mercadopago'

class PaymentsController < ApplicationController
  before_action :get_sdk, only: %i[new notification]
  skip_before_action :verify_authenticity_token, only: :notification

  def new
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
      notification_url: if ENV['NGROK']
                          payments_notification_url(protocol: 'https', host: ENV['NGROK'],
                                                    port: nil)
                        else
                          payments_notification_url
                        end
    }

    preference_response = @sdk.preference.create(preference_data)
    @preference = preference_response[:response]

    # Este valor reemplazará el string "<%= @preference_id %>" en tu HTML
    # @preference_id = preference['id']
  end

  def success; end

  def failure; end

  def pending; end

  def notification
    respond_to do |format|
      format.json do
        if params[:topic] == 'merchant_order'
          merchant_order = @sdk.merchant_order.get(params[:id])[:response]
          logger.debug "Merchant order received. Preference ID: #{merchant_order['preference_id']}"
        end
        head :ok
      end
    end
  end

  private

  def get_sdk
    @sdk = Mercadopago::SDK.new(ENV['MP_ACCESS_TOKEN'])
  end
end
