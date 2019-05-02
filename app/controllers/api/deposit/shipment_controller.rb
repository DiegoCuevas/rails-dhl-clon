class Api::Deposit::ShipmentController < ApiController

  def index
    @shipment = Shipment.all
    render json: @shipment, status: :ok
  end

  def show
    render json: Shipment.find(params[:id])
  end


  def search
    if Shipment.exists?(tracking_id: params[:tracking_id])
      redirect_to deposit_path(params[:tracking_id])
    else
      flash[:alert] = "Shipment with tracking number #{params[:tracking_id]} not found. Try again"
      redirect_back(fallback_location: root_path)
    end
  end

  def check_in
    params[:tracking_id]
    shipment_id = Shipment.find_by(tracking_id: params[:tracking_id]).id
    reception_date = DateTime.now
    country = current_user.country
    city = current_user.city
    ShipmentLocation.create(shipment_id: shipment_id, reception_date: reception_date, country: country, city: city)
    flash[:notice] = "Shipment checked in"
    redirect_to deposit_path(params[:tracking_id])
  end

end
