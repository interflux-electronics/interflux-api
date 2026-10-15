class SanityController < ApplicationController
  def check
    render status: 200, json: payload
  end

  private

  def payload
    {
      status: 200,
      code: 'all-good',
      msg: 'This back-end is live and running. This request just successfully got passed Nginx, SSL, Puma, Rack, Rails and back! Have a beer.',
      build: {
        environment: environment,
        git: {
          branch: git_branch,
          revision: git_revision
        }
      }
    }
  end

  def environment
    Rails.env || '?'
  end

  def git_branch
    `git branch --show-current`.strip || '?'
  end

  def git_revision
    `git rev-parse HEAD`.strip || '?'
  end
end
