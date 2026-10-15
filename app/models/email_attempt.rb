# == Schema Information
#
# Table name: email_attempts
#
#  id                      :uuid             not null, primary key
#  bcc                     :string
#  cc                      :string
#  created_by_type         :string
#  delivered               :boolean
#  from                    :string
#  postmark_stream         :string
#  postmark_template_alias :string
#  postmark_template_model :jsonb
#  provider                :integer
#  reply_to                :string
#  response_body           :jsonb
#  response_status         :integer
#  to                      :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  created_by_id           :uuid
#
# Indexes
#
#  index_email_attempts_on_created_by     (created_by_type,created_by_id)
#  index_email_attempts_on_response_body  (response_body) USING gin
#
class EmailAttempt < ApplicationRecord
  # The record which created this EmailAttempt
  belongs_to :created_by, polymorphic: true, optional: true

  # The provider which will send the email for us.
  # Rails cannot send emails. It only delegates them.
  # enum :provider, { postmark: 0, sendgrid: 1 }, scopes: true

  after_save :send_email

  private

  def blocker
    return 'no to' if to.nil?
    return 'no from' if from.nil?
    return 'no postmark_stream' if postmark_stream.nil?
    return 'no postmark_template_alias' if postmark_template_alias.nil?
    return 'no postmark_template_model' if postmark_template_model.nil?
    return 'model is not a hash' unless postmark_template_model.is_a? Hash

    # Never deliver an email twice
    # This also allows admins to edit and retry until delivered
    return 'already delivered' if delivered == true

    nil
  end

  def send_email
    log.info "✅ saved EmailAttempt #{id}"

    if blocker.present?
      log.warn "🔥 #{blocker}"
      return
    end

    log.info '✅ sending ...'

    ap from
    ap to
    ap postmark_template_alias
    ap postmark_template_model

    api = Postmark::Api.new(server_token: Rails.application.credentials.postmark_server_token)

    response = api.send_email_with_template(
      message_stream: postmark_stream,
      template_alias: postmark_template_alias,
      template_model: postmark_template_model,
      from: from,
      to: to,
      cc: cc,
      bcc: bcc,
      reply_to: reply_to
    )

    if response.status == 200
      log.info '✅ success'
    else
      log.info '❌ fail'
    end

    ap response.status
    ap response.body

    self.response_status = response.status
    self.response_body = JSON.parse(response.body) if response.body.present?
    self.delivered = response.status == 200

    save!

    log.info '✅ done'
  end
end
