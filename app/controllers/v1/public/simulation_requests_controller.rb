module V1
  module Public
    class SimulationRequestsController < V1::PublicController
      def index
        forbidden
      end

      def show
        forbidden
      end

      def create
        allow_create
      end

      def update
        forbidden
      end

      def destroy
        forbidden
      end

      # This endpoint accepts a file name and returns a presigned URL for uploading
      # a file from the front-end directly to the Digital Ocean CDN.
      #
      # Documentation
      # https://docs.digitalocean.com/products/spaces/reference/s3-sdk-examples/
      # https://stackoverflow.com/questions/66555915/cannot-upload-files-with-acl-public-read-to-digital-ocean-spaces
      #
      def create_upload_url
        return if params[:file_name].blank?

        file_name = params[:file_name]
        environment = Rails.env.production? ? 'production' : 'development'
        cdn_path = "images/simulation-requests/#{environment}/#{file_name}"

        client = Aws::S3::Client.new(
          access_key_id: Rails.application.credentials.dig(:digitalocean, :access),
          secret_access_key: Rails.application.credentials.dig(:digitalocean, :secret),
          endpoint: Rails.application.credentials.dig(:digitalocean, :endpoint),
          force_path_style: false,
          region: Rails.application.credentials.dig(:digitalocean, :region)
        )

        signer = Aws::S3::Presigner.new(client: client)

        upload_url = signer.presigned_url(
          :put_object,
          bucket: Rails.application.credentials.dig(:digitalocean, :bucket),
          key: cdn_path,
          expires_in: 300
        )

        payload = {
          upload_url: upload_url,
          cdn_path: cdn_path
        }

        render json: payload, status: :ok
      end

      private

      def model_class
        SimulationRequest
      end

      def serializer_class
        V1::Public::SimulationRequestSerializer
      end

      def creatable_attributes
        %i[
          id
          project_name
          pallet_width
          pallet_length
          wave_speed
          cycle_time
          flux_brand
          flux_consumption
          board_reference
          known_issue
          solder_process
          flux_process
          full_name
          email
          company_name
          image
        ]
      end
    end
  end
end
