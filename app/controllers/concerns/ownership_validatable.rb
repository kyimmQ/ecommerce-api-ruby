module OwnershipValidatable
  extend ActiveSupport::Concern
  def validate_ownership
    unless @product.owner == current_user
        render json: { errors: { ownership: "You do not have permission to perform this action." } }, status: :forbidden
    end
    true
  end
end